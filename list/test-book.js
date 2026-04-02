const fs = require("node:fs");
const path = require("node:path");

const INPUT_FILE = path.resolve("books.to.fetch.json");
const OUTPUT_BOOKS_FILE = path.resolve("books.raw.json");
const OUTPUT_AUTHORS_FILE = path.resolve("authors.raw.json");
const OUTPUT_FAILED_FILE = path.resolve("books.failed.json");

const CONCURRENCY = 3;
const RETRY_TIMES = 2;
const REQUEST_TIMEOUT_MS = 20000;
const GOOGLE_MAX_RESULTS = 10;
const REQUEST_GAP_MS = 150;

function normalizeString(value) {
  return String(value || "").trim().replace(/\s+/g, " ");
}

function normalizeKey(value) {
  return normalizeString(value).toLowerCase();
}

function normalizeDate(dateStr) {
  if (!dateStr) return null;

  const value = String(dateStr).trim();

  if (/^\d{4}$/.test(value)) return `${value}-01-01T00:00:00.000+00:00`;
  if (/^\d{4}-\d{2}$/.test(value)) return `${value}-01T00:00:00.000+00:00`;
  if (/^\d{4}-\d{2}-\d{2}$/.test(value)) return `${value}T00:00:00.000+00:00`;

  const d = new Date(value);
  if (Number.isNaN(d.getTime())) return null;

  return d.toISOString().replace("Z", "+00:00");
}

function ensureHttps(url) {
  const value = normalizeString(url);
  if (!value) return "";
  if (value.startsWith("http://")) {
    return "https://" + value.slice("http://".length);
  }
  return value;
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

function safeReadJsonArray(filePath) {
  if (!fs.existsSync(filePath)) return [];

  const text = fs.readFileSync(filePath, "utf8");
  const data = JSON.parse(text);

  if (!Array.isArray(data)) {
    throw new Error(`${path.basename(filePath)} 必须是数组 JSON`);
  }

  return data;
}

function buildSpecKey(title, authorName) {
  return `${normalizeKey(title)}@@${normalizeKey(authorName)}`;
}

async function fetchJson(url) {
  const res = await fetch(url, {
    signal: AbortSignal.timeout(REQUEST_TIMEOUT_MS)
  });

  const text = await res.text();
  let data = null;

  try {
    data = text ? JSON.parse(text) : null;
  } catch {
    data = text;
  }

  if (!res.ok) {
    throw new Error(
      `请求失败 ${res.status}: ${url}\n${typeof data === "string" ? data : JSON.stringify(data, null, 2)}`
    );
  }

  return data;
}

function scoreGoogleItem(item, targetTitle, targetAuthor) {
  const info = item.volumeInfo || {};
  const title = normalizeKey(info.title);
  const authors = (info.authors || []).map(normalizeKey);

  let score = 0;

  if (targetTitle) {
    const t = normalizeKey(targetTitle);
    if (title === t) score += 100;
    else if (title.includes(t)) score += 40;
  }

  if (targetAuthor) {
    const a = normalizeKey(targetAuthor);
    if (authors.some(x => x === a)) score += 100;
    else if (authors.some(x => x.includes(a) || a.includes(x))) score += 40;
  }

  return score;
}

async function fetchBookFromGoogle(spec) {
  const queryParts = [];

  if (normalizeString(spec.title)) {
    queryParts.push(`intitle:"${normalizeString(spec.title)}"`);
  }

  if (normalizeString(spec.authorName)) {
    queryParts.push(`inauthor:"${normalizeString(spec.authorName)}"`);
  }

  const q = queryParts.join(" ").trim();
  if (!q) {
    throw new Error("缺少 title 或 authorName");
  }

  const url = `https://www.googleapis.com/books/v1/volumes?q=${encodeURIComponent(q)}&maxResults=${GOOGLE_MAX_RESULTS}&printType=books`;
  const data = await fetchJson(url);
  const items = Array.isArray(data?.items) ? data.items : [];

  if (!items.length) {
    throw new Error(`Google Books 没找到: ${spec.title}`);
  }

  const bestWrapper = items
    .map(item => ({ item, score: scoreGoogleItem(item, spec.title, spec.authorName) }))
    .sort((a, b) => b.score - a.score)[0];

  if (!bestWrapper || !bestWrapper.item) {
    throw new Error(`没有匹配到合适图书: ${spec.title}`);
  }

  const best = bestWrapper.item;
  const info = best.volumeInfo || {};
  const sale = best.saleInfo || {};
  const pagesNumber = Number(info.pageCount || 0);

  return {
    googleId: best.id || "",
    authorName: normalizeString(spec.authorName || info.authors?.[0]),
    name: normalizeString(spec.title || info.title),
    categoryName: normalizeString(spec.categoryName || info.categories?.[0] || ""),
    price: sale.listPrice?.amount ?? 0,
    rate: Number(info.averageRating || 0),
    usersRateCount: Number(info.ratingsCount || 0),
    pagesNumber,
    readingDuration: pagesNumber ? pagesNumber * 2 : 0,
    publishDate: normalizeDate(info.publishedDate),
    description: normalizeString(info.description || ""),
    imageUrl: ensureHttps(info.imageLinks?.thumbnail || info.imageLinks?.smallThumbnail || "")
  };
}

function buildAuthorPlaceholder(authorName) {
  return {
    openLibraryKey: "",
    name: normalizeString(authorName),
    description: "",
    birthdate: null,
    deathdate: null,
    country: "",
    age: 0,
    gender: "OTHERS",
    imageUrl: ""
  };
}

function dedupeSpecs(specs) {
  const list = [];
  const map = new Map();

  for (const rawSpec of specs) {
    const spec = {
      title: normalizeString(rawSpec?.title),
      authorName: normalizeString(rawSpec?.authorName),
      categoryName: normalizeString(rawSpec?.categoryName)
    };

    if (!spec.title || !spec.authorName) continue;

    const key = buildSpecKey(spec.title, spec.authorName);
    if (map.has(key)) continue;

    map.set(key, spec);
    list.push(spec);
  }

  return list;
}

async function withRetry(taskFn, retryTimes, label) {
  let lastError = null;

  for (let attempt = 0; attempt <= retryTimes; attempt++) {
    try {
      return await taskFn();
    } catch (error) {
      lastError = error;
      const isLast = attempt === retryTimes;

      if (!isLast) {
        console.warn(`${label} 失败，第 ${attempt + 1} 次重试前等待...`);
        await sleep(1000 * (attempt + 1));
      }
    }
  }

  throw lastError;
}

async function runWithConcurrency(items, limit, worker) {
  const results = new Array(items.length);
  let nextIndex = 0;

  async function runner() {
    while (true) {
      const currentIndex = nextIndex;
      nextIndex += 1;

      if (currentIndex >= items.length) return;

      results[currentIndex] = await worker(items[currentIndex], currentIndex);
      await sleep(REQUEST_GAP_MS);
    }
  }

  const workers = Array.from({ length: Math.min(limit, items.length) }, () => runner());
  await Promise.all(workers);
  return results;
}

function hydrateAuthorsFromBooks(books) {
  const authorsMap = new Map();

  for (const book of books) {
    const authorKey = normalizeKey(book.authorName);
    if (!authorKey) continue;
    if (!authorsMap.has(authorKey)) {
      authorsMap.set(authorKey, buildAuthorPlaceholder(book.authorName));
    }
  }

  return authorsMap;
}

async function main() {
  const inputSpecs = dedupeSpecs(safeReadJsonArray(INPUT_FILE));
  if (inputSpecs.length === 0) {
    throw new Error("books.to.fetch.json 为空或格式不正确");
  }

  const existingBooks = safeReadJsonArray(OUTPUT_BOOKS_FILE);
  const existingFailed = safeReadJsonArray(OUTPUT_FAILED_FILE);

  const existingBookMap = new Map();
  for (const book of existingBooks) {
    existingBookMap.set(buildSpecKey(book.name, book.authorName), book);
  }

  const authorsMap = hydrateAuthorsFromBooks(existingBooks);
  const failedMap = new Map();
  for (const row of existingFailed) {
    failedMap.set(buildSpecKey(row.title, row.authorName), row);
  }

  const pendingSpecs = inputSpecs.filter(spec => !existingBookMap.has(buildSpecKey(spec.title, spec.authorName)));

  console.log(`输入总量: ${inputSpecs.length}`);
  console.log(`已成功存在: ${existingBooks.length}`);
  console.log(`本次待抓取: ${pendingSpecs.length}`);
  console.log(`并发数: ${CONCURRENCY}`);
  console.log(`重试次数: ${RETRY_TIMES}`);

  await runWithConcurrency(pendingSpecs, CONCURRENCY, async (spec, index) => {
    const progress = `[${index + 1}/${pendingSpecs.length}]`;
    const label = `${progress} ${spec.title} / ${spec.authorName}`;

    console.log(`开始抓取 ${label}`);

    try {
      const book = await withRetry(() => fetchBookFromGoogle(spec), RETRY_TIMES, label);
      existingBookMap.set(buildSpecKey(book.name, book.authorName), book);

      const authorKey = normalizeKey(book.authorName);
      if (authorKey && !authorsMap.has(authorKey)) {
        authorsMap.set(authorKey, buildAuthorPlaceholder(book.authorName));
      }

      failedMap.delete(buildSpecKey(spec.title, spec.authorName));
      console.log(`抓取成功 ${label}`);
    } catch (error) {
      failedMap.set(buildSpecKey(spec.title, spec.authorName), {
        title: spec.title,
        authorName: spec.authorName,
        categoryName: spec.categoryName,
        error: error.message
      });
      console.error(`抓取失败 ${label}`);
      console.error(error.message);
    }
  });

  const books = Array.from(existingBookMap.values()).sort((a, b) => {
    const c = a.categoryName.localeCompare(b.categoryName);
    if (c !== 0) return c;
    const n = a.name.localeCompare(b.name);
    if (n !== 0) return n;
    return a.authorName.localeCompare(b.authorName);
  });

  const authors = Array.from(authorsMap.values()).sort((a, b) => a.name.localeCompare(b.name));
  const failed = Array.from(failedMap.values()).sort((a, b) => {
    const c = a.categoryName.localeCompare(b.categoryName);
    if (c !== 0) return c;
    const n = a.title.localeCompare(b.title);
    if (n !== 0) return n;
    return a.authorName.localeCompare(b.authorName);
  });

  fs.writeFileSync(OUTPUT_BOOKS_FILE, JSON.stringify(books, null, 2), "utf8");
  fs.writeFileSync(OUTPUT_AUTHORS_FILE, JSON.stringify(authors, null, 2), "utf8");
  fs.writeFileSync(OUTPUT_FAILED_FILE, JSON.stringify(failed, null, 2), "utf8");

  console.log("\n已生成文件：");
  console.log(` - ${path.basename(OUTPUT_BOOKS_FILE)}`);
  console.log(` - ${path.basename(OUTPUT_AUTHORS_FILE)}`);
  console.log(` - ${path.basename(OUTPUT_FAILED_FILE)}`);
  console.log(`成功书籍数量: ${books.length}`);
  console.log(`成功作者数量: ${authors.length}`);
  console.log(`失败数量: ${failed.length}`);
}

main().catch(err => {
  console.error("批量抓取失败：");
  console.error(err.message);
  process.exit(1);
});
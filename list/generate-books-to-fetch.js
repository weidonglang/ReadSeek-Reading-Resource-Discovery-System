const fs = require("node:fs");
const path = require("node:path");

const OUTPUT_FILE = path.resolve("books.to.fetch.json");
const DEBUG_FILE = path.resolve("books.to.fetch.stats.json");

const TARGET_TOTAL = 3000;
const REQUEST_TIMEOUT_MS = 20000;
const REQUEST_GAP_MS = 200;
const RETRY_TIMES = 3;

// Google Books 分页参数：maxResults 最大允许 40
const PAGE_SIZE = 40;

// 你可以继续增删分类词。
// q 是拿去给 Google Books 做搜索的关键词；categoryName 是你自己项目里保存的分类名。
const QUERY_SPECS = [
  { q: "subject:fiction", categoryName: "Fiction", target: 250 },
  { q: "subject:science fiction", categoryName: "Science Fiction", target: 250 },
  { q: "subject:fantasy", categoryName: "Fantasy", target: 250 },
  { q: "subject:history", categoryName: "History", target: 220 },
  { q: "subject:psychology", categoryName: "Psychology", target: 180 },
  { q: "subject:computer science", categoryName: "Computer Science", target: 180 },
  { q: "subject:mathematics", categoryName: "Mathematics", target: 180 },
  { q: "subject:philosophy", categoryName: "Philosophy", target: 180 },
  { q: "subject:business", categoryName: "Business", target: 180 },
  { q: "subject:economics", categoryName: "Economics", target: 180 },
  { q: "subject:biography", categoryName: "Biography", target: 180 },
  { q: "subject:mystery", categoryName: "Mystery", target: 180 },
  { q: "subject:romance", categoryName: "Romance", target: 180 },
  { q: "subject:horror", categoryName: "Horror", target: 140 },
  { q: "subject:adventure", categoryName: "Adventure", target: 160 },
  { q: "subject:art", categoryName: "Art", target: 160 },
  { q: "subject:self-help", categoryName: "Self-Help", target: 140 }
];

function normalizeString(value) {
  return String(value || "").trim().replace(/\s+/g, " ");
}

function normalizeKey(value) {
  return normalizeString(value).toLowerCase();
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
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
      `请求失败 ${res.status}: ${url}\n${
        typeof data === "string" ? data : JSON.stringify(data, null, 2)
      }`
    );
  }

  return data;
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

function buildSeedSpec(title, authorName, categoryName) {
  return {
    title: normalizeString(title),
    authorName: normalizeString(authorName),
    categoryName: normalizeString(categoryName)
  };
}

function isValidSeed(spec) {
  return !!(normalizeString(spec.title) && normalizeString(spec.authorName));
}

function dedupePush(list, map, spec) {
  if (!isValidSeed(spec)) return false;

  const key = `${normalizeKey(spec.title)}@@${normalizeKey(spec.authorName)}`;
  if (map.has(key)) return false;

  map.set(key, spec);
  list.push(spec);
  return true;
}

async function collectFromGoogleQuery(querySpec, globalList, globalMap) {
  const localList = [];
  const localMap = new Map();

  let startIndex = 0;
  let totalItems = Infinity;

  while (
    localList.length < querySpec.target &&
    globalList.length < TARGET_TOTAL &&
    startIndex < totalItems
  ) {
    const needCount = querySpec.target - localList.length;
    const maxResults = Math.min(PAGE_SIZE, needCount);

    const url =
      `https://www.googleapis.com/books/v1/volumes` +
      `?q=${encodeURIComponent(querySpec.q)}` +
      `&printType=books` +
      `&orderBy=relevance` +
      `&langRestrict=en` +
      `&startIndex=${startIndex}` +
      `&maxResults=${maxResults}`;

    const data = await withRetry(
      () => fetchJson(url),
      RETRY_TIMES,
      `查询 ${querySpec.categoryName} startIndex=${startIndex}`
    );

    totalItems = Number(data?.totalItems || 0);
    const items = Array.isArray(data?.items) ? data.items : [];

    if (items.length === 0) break;

    let pageAdded = 0;

    for (const item of items) {
      if (
        localList.length >= querySpec.target ||
        globalList.length >= TARGET_TOTAL
      ) {
        break;
      }

      const info = item?.volumeInfo || {};
      const title = normalizeString(info.title);
      const authorName = normalizeString(info.authors?.[0]);

      const seed = buildSeedSpec(title, authorName, querySpec.categoryName);

      const localAdded = dedupePush(localList, localMap, seed);
      if (!localAdded) continue;

      const globalAdded = dedupePush(globalList, globalMap, seed);
      if (!globalAdded) {
        localList.pop();
        localMap.delete(`${normalizeKey(seed.title)}@@${normalizeKey(seed.authorName)}`);
        continue;
      }

      pageAdded += 1;
    }

    startIndex += items.length;

    if (items.length < maxResults) break;
    if (pageAdded === 0) break;

    await sleep(REQUEST_GAP_MS);
  }

  return localList;
}

async function main() {
  const globalList = [];
  const globalMap = new Map();
  const stats = [];

  console.log(`目标生成数量: ${TARGET_TOTAL}`);

  for (const querySpec of QUERY_SPECS) {
    if (globalList.length >= TARGET_TOTAL) break;

    console.log(`\n开始收集分类: ${querySpec.categoryName}，目标 ${querySpec.target}`);

    let addedItems = [];
    let errorMessage = "";

    try {
      addedItems = await collectFromGoogleQuery(querySpec, globalList, globalMap);
    } catch (error) {
      errorMessage = error.message;
      console.warn(`分类 ${querySpec.categoryName} 失败: ${errorMessage}`);
    }

    stats.push({
      q: querySpec.q,
      categoryName: querySpec.categoryName,
      target: querySpec.target,
      added: addedItems.length,
      error: errorMessage
    });

    console.log(
      `分类 ${querySpec.categoryName} 完成，新增 ${addedItems.length} 条，当前总数 ${globalList.length}`
    );
  }

  const finalList = globalList.slice(0, TARGET_TOTAL);

  finalList.sort((a, b) => {
    const c = a.categoryName.localeCompare(b.categoryName);
    if (c !== 0) return c;

    const t = a.title.localeCompare(b.title);
    if (t !== 0) return t;

    return a.authorName.localeCompare(b.authorName);
  });

  fs.writeFileSync(OUTPUT_FILE, JSON.stringify(finalList, null, 2), "utf8");
  fs.writeFileSync(
    DEBUG_FILE,
    JSON.stringify(
      {
        targetTotal: TARGET_TOTAL,
        actualTotal: finalList.length,
        generatedAt: new Date().toISOString(),
        stats
      },
      null,
      2
    ),
    "utf8"
  );

  console.log("\n已生成文件：");
  console.log(` - ${path.basename(OUTPUT_FILE)}`);
  console.log(` - ${path.basename(DEBUG_FILE)}`);
  console.log(`最终条数: ${finalList.length}`);
}

main().catch(err => {
  console.error("生成 books.to.fetch.json 失败：");
  console.error(err.message);
  process.exit(1);
});
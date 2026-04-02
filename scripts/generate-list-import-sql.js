const fs = require('fs');
const path = require('path');

const root = process.cwd();
const authorsPath = path.join(root, 'list', 'authors.raw.json');
const booksPath = path.join(root, 'list', 'books.raw.json');
const outputPath = path.join(root, 'scripts', 'generated', 'import_from_list_raw.sql');

const DEFAULT_AUTHOR_DATE = '1970-01-01';
const DEFAULT_COUNTRY = 'Unknown';
const DEFAULT_AUTHOR_IMAGE = '/book-service/book-covers/default-book-cover.svg';
const DEFAULT_BOOK_IMAGE = '/book-service/book-covers/default-book-cover.svg';
const DEFAULT_BOOK_DATE = '2000-01-01';
const DEFAULT_DESCRIPTION = '';
const DEFAULT_TOTAL_COPIES = 1;
const CATEGORY_ALIASES = {
  Adventure: 'Action and Adventure',
  Romance: 'Romantic'
};
const VALID_GENDERS = new Set(['MALE', 'FEMALE', 'OTHERS']);

function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, 'utf8'));
}

function normalizeText(value, fallback = '') {
  if (value === null || value === undefined) return fallback;
  return String(value)
    .normalize('NFKC')
    .replace(/[\u0000-\u0008\u000B\u000C\u000E-\u001F]/g, '')
    .replace(/\u00A0/g, ' ')
    .trim();
}

function sqlString(value) {
  if (value === null || value === undefined) return 'NULL';
  return `'${String(value).replace(/'/g, "''")}'`;
}

function sqlDate(value, fallback) {
  const normalized = normalizeText(value, fallback);
  if (!normalized) return 'NULL';
  const date = new Date(normalized);
  if (Number.isNaN(date.getTime())) {
    return `DATE ${sqlString(fallback)}`;
  }
  return `DATE ${sqlString(date.toISOString().slice(0, 10))}`;
}

function normalizeGender(value) {
  const normalized = normalizeText(value, 'OTHERS').toUpperCase();
  return VALID_GENDERS.has(normalized) ? normalized : 'OTHERS';
}

function normalizeCategoryName(value) {
  const normalized = normalizeText(value);
  if (!normalized) return '';
  return CATEGORY_ALIASES[normalized] || normalized;
}

function normalizeAuthor(author) {
  const name = normalizeText(author.name);
  if (!name) return null;
  return {
    name,
    description: normalizeText(author.description, DEFAULT_DESCRIPTION),
    birthdate: sqlDate(author.birthdate, DEFAULT_AUTHOR_DATE),
    deathdate: author.deathdate ? sqlDate(author.deathdate, DEFAULT_AUTHOR_DATE) : 'NULL',
    country: normalizeText(author.country, DEFAULT_COUNTRY) || DEFAULT_COUNTRY,
    age: Number.isFinite(Number(author.age)) && Number(author.age) >= 0 ? Number(author.age) : 0,
    gender: normalizeGender(author.gender),
    imageUrl: normalizeText(author.imageUrl, DEFAULT_AUTHOR_IMAGE) || DEFAULT_AUTHOR_IMAGE
  };
}

function normalizeBook(book) {
  const name = normalizeText(book.name);
  const authorName = normalizeText(book.authorName);
  const categoryName = normalizeCategoryName(book.categoryName);
  if (!name || !authorName || !categoryName) return null;

  const pagesNumber = Number.isFinite(Number(book.pagesNumber)) && Number(book.pagesNumber) > 0
    ? Number(book.pagesNumber)
    : 100;
  const readingDuration = Number.isFinite(Number(book.readingDuration)) && Number(book.readingDuration) > 0
    ? Number(book.readingDuration)
    : Math.max(120, pagesNumber * 2);

  const rate = Number.isFinite(Number(book.rate))
    ? Math.min(5, Math.max(0, Number(book.rate)))
    : 0;

  return {
    authorName,
    name,
    categoryName,
    price: Number.isFinite(Number(book.price)) && Number(book.price) >= 0 ? Number(book.price) : 0,
    rate,
    usersRateCount: Number.isFinite(Number(book.usersRateCount)) && Number(book.usersRateCount) >= 0
      ? Number(book.usersRateCount)
      : 0,
    pagesNumber,
    readingDuration,
    publishDate: sqlDate(book.publishDate, DEFAULT_BOOK_DATE),
    description: normalizeText(book.description, DEFAULT_DESCRIPTION),
    imageUrl: normalizeText(book.imageUrl, DEFAULT_BOOK_IMAGE) || DEFAULT_BOOK_IMAGE,
    totalCopies: DEFAULT_TOTAL_COPIES,
    availableCopies: DEFAULT_TOTAL_COPIES
  };
}

function authorInsertSql(author) {
  return [
    'INSERT INTO public.author',
    '(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)',
    `SELECT ${sqlString(author.name)}, ${sqlString(author.description)}, ${author.birthdate}, ${author.deathdate}, ${sqlString(author.country)}, ${author.age}, ${sqlString(author.gender)}, ${sqlString(author.imageUrl)}, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE`,
    `WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower(${sqlString(author.name)}) AND marked_as_deleted = FALSE);`,
    ''
  ].join('\n');
}

function categoryInsertSql(categoryName) {
  return [
    'INSERT INTO public.book_category',
    '(name, description, created_date, modified_date, created_by, modified_by, marked_as_deleted)',
    `VALUES (${sqlString(categoryName)}, '', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE)`,
    `ON CONFLICT (name) DO NOTHING;`,
    ''
  ].join('\n');
}

function bookInsertSql(book) {
  const authorIdExpr = `(SELECT id FROM public.author WHERE lower(name) = lower(${sqlString(book.authorName)}) AND marked_as_deleted = FALSE ORDER BY id LIMIT 1)`;
  const categoryIdExpr = `(SELECT id FROM public.book_category WHERE name = ${sqlString(book.categoryName)} AND marked_as_deleted = FALSE ORDER BY id LIMIT 1)`;
  return [
    'INSERT INTO public.book',
    '(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)',
    `SELECT ${authorIdExpr}, ${categoryIdExpr}, ${sqlString(book.name)}, ${book.price}, ${book.rate}, ${book.usersRateCount}, ${book.pagesNumber}, ${book.readingDuration}, ${book.publishDate}, ${sqlString(book.description)}, ${sqlString(book.imageUrl)}, ${book.totalCopies}, ${book.availableCopies}, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE`,
    `WHERE ${authorIdExpr} IS NOT NULL`,
    `  AND ${categoryIdExpr} IS NOT NULL`,
    `  AND NOT EXISTS (`,
    `    SELECT 1 FROM public.book b`,
    `    WHERE lower(b.name) = lower(${sqlString(book.name)})`,
    `      AND b.marked_as_deleted = FALSE`,
    `  );`,
    ''
  ].join('\n');
}

const rawAuthors = readJson(authorsPath);
const rawBooks = readJson(booksPath);

const authors = [];
const authorNames = new Set();
for (const rawAuthor of rawAuthors) {
  const author = normalizeAuthor(rawAuthor);
  if (!author) continue;
  const key = author.name.toLowerCase();
  if (authorNames.has(key)) continue;
  authorNames.add(key);
  authors.push(author);
}

const categories = Array.from(new Set(
  rawBooks
    .map(normalizeBook)
    .filter(Boolean)
    .map(book => book.categoryName)
)).sort((a, b) => a.localeCompare(b));

const books = [];
const bookKeys = new Set();
for (const rawBook of rawBooks) {
  const book = normalizeBook(rawBook);
  if (!book) continue;
  const key = book.name.toLowerCase();
  if (bookKeys.has(key)) continue;
  bookKeys.add(key);
  books.push(book);
}

const lines = [];
lines.push('-- Generated from list/authors.raw.json and list/books.raw.json');
lines.push('-- Incremental import: inserts missing authors, categories, and books without deleting existing data.');
lines.push('-- Usage:');
lines.push('--   node scripts/generate-list-import-sql.js');
lines.push('--   psql -h localhost -p 5043 -U postgres -d book_recommendation_system -f scripts/generated/import_from_list_raw.sql');
lines.push('BEGIN;');
lines.push('');

for (const author of authors) {
  lines.push(authorInsertSql(author));
}

for (const categoryName of categories) {
  lines.push(categoryInsertSql(categoryName));
}

for (const book of books) {
  lines.push(bookInsertSql(book));
}

lines.push('COMMIT;');
lines.push('');

fs.mkdirSync(path.dirname(outputPath), { recursive: true });
fs.writeFileSync(outputPath, lines.join('\n'), 'utf8');

console.log(`Generated ${outputPath}`);
console.log(`Authors prepared: ${authors.length}`);
console.log(`Categories prepared: ${categories.length}`);
console.log(`Books prepared: ${books.length}`);

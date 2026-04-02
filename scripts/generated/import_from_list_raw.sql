-- Generated from list/authors.raw.json and list/books.raw.json
-- Incremental import: inserts missing authors, categories, and books without deleting existing data.
-- Usage:
--   node scripts/generate-list-import-sql.js
--   psql -h localhost -p 5043 -U postgres -d book_recommendation_system -f scripts/generated/import_from_list_raw.sql
BEGIN;

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT '倪匡', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('倪匡') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Adam Smith', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Adam Smith') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Adrian Keith Goldsworthy', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Adrian Keith Goldsworthy') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Agatha Christie', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Agatha Christie') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Alain De Botton', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Alain De Botton') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Alasdair MacIntyre', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Alasdair MacIntyre') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Albert Camus', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Albert Camus') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Albert Howe Lybyer', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Albert Howe Lybyer') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Albert John Walford', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Albert John Walford') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Alejandro Cassini', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Alejandro Cassini') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Alexander McCall Smith', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Alexander McCall Smith') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Alfred Marshall', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Alfred Marshall') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Algernon Blackwood', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Algernon Blackwood') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Allan Gut', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Allan Gut') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Amartya Sen', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Amartya Sen') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Amos Harpaz', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Amos Harpaz') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Anatole France', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Anatole France') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Andreas M. Hinz', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Andreas M. Hinz') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Anthony G. Hopwood', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Anthony G. Hopwood') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Anthony Horowitz', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Anthony Horowitz') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Aristotle', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Aristotle') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Arthur Conan Doyle', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Arthur Conan Doyle') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Arthur Shavit', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Arthur Shavit') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Astrid Lindgren', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Astrid Lindgren') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Augustine', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Augustine') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Brad Inwood', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Brad Inwood') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Bram Stoker', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Bram Stoker') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Brian Jacques', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Brian Jacques') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Brian M. Stableford', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Brian M. Stableford') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Bruno Schulz', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Bruno Schulz') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Bryan Pfaffenberger', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Bryan Pfaffenberger') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Camille Paglia', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Camille Paglia') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Canon Ronald Brownrigg', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Canon Ronald Brownrigg') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Carl Schmitt', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Carl Schmitt') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Carnegie Library of Pittsburgh', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Carnegie Library of Pittsburgh') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Cassandra Clare', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Cassandra Clare') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Charles Darwin', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Charles Darwin') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Charles Dickens', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Charles Dickens') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Charles Duhigg', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Charles Duhigg') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Charles H. Talbert', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Charles H. Talbert') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Charles Kingsley', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Charles Kingsley') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Charles Knight', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Charles Knight') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Charlotte Brontë', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Charlotte Brontë') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Chiara Thumiger', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Chiara Thumiger') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Christian N. Madu', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Christian N. Madu') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Christopher Pike', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Christopher Pike') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Claus Pias', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Claus Pias') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Clive Barker', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Clive Barker') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Clive Staples Lewis', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Clive Staples Lewis') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Dalai Lama XIV Bstan-ʼdzin-rgya-mtsho', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Dalai Lama XIV Bstan-ʼdzin-rgya-mtsho') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Damodar N. Gujarati', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Damodar N. Gujarati') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Dan Brown', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Dan Brown') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Daniel Cohen', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Daniel Cohen') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Daniel Defoe', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Daniel Defoe') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Danielle Steel', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Danielle Steel') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'David Balson', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('David Balson') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'David H. Jonassen', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('David H. Jonassen') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'David Herbert Lawrence', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('David Herbert Lawrence') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'David Hume', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('David Hume') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'David Kroyanker', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('David Kroyanker') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'David Ricardo', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('David Ricardo') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'David Semple', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('David Semple') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Desmond Shum', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Desmond Shum') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Diogenes Laertius', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Diogenes Laertius') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Dirk J. Struik', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Dirk J. Struik') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Donald Ervin Knuth', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Donald Ervin Knuth') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'E. Mumford', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('E. Mumford') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Edmund K. Burke', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Edmund K. Burke') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Edward O. Wilson', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Edward O. Wilson') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Edwin A. Abbott', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Edwin A. Abbott') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Eliyahu M. Goldratt', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Eliyahu M. Goldratt') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Elizabeth Gilbert', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Elizabeth Gilbert') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Elizabeth Irene Price', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Elizabeth Irene Price') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Emily Bront?e', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Emily Bront?e') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Erich Kästner', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Erich Kästner') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Ernst Friedrich Schumacher', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Ernst Friedrich Schumacher') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Eugene Morlock Emme', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Eugene Morlock Emme') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Eva Baer', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Eva Baer') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Florian Cajori', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Florian Cajori') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Frances M. Epps', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Frances M. Epps') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Frances Upham', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Frances Upham') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Fred Vargas', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Fred Vargas') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Friedrich August Hayek', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Friedrich August Hayek') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Friedrich Nietzsche', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Friedrich Nietzsche') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Friedrich Wilhelm Nietzsche', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Friedrich Wilhelm Nietzsche') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Fyodor Dostoyevsky', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Fyodor Dostoyevsky') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'G. Sreeramulu', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('G. Sreeramulu') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Gaston Leroux', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Gaston Leroux') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Gene H. Golub', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Gene H. Golub') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Geoffrey A. Hosking', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Geoffrey A. Hosking') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Geoffrey Hunter', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Geoffrey Hunter') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Georg Wilhelm Friedrich Hegel', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Georg Wilhelm Friedrich Hegel') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'George Bernard Shaw', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('George Bernard Shaw') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Gogol Google Translate', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Gogol Google Translate') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Guanzhong Luo', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Guanzhong Luo') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Guy Debord', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Guy Debord') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Helena Lindholm Schulz', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Helena Lindholm Schulz') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Hendrikus Laan', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Hendrikus Laan') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Henry M. Stanley', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Henry M. Stanley') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Hergé', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Hergé') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Hermann Hesse', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Hermann Hesse') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Howard Phillips Lovecraft', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Howard Phillips Lovecraft') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Ida Minerva Tarbell', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Ida Minerva Tarbell') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Irving Singer', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Irving Singer') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Isabel Allende', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Isabel Allende') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'J. E. Lapin', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('J. E. Lapin') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'J. K. Rowling', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('J. K. Rowling') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'J. P. Verma', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('J. P. Verma') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'j.r.r. tolkien', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('j.r.r. tolkien') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Jack Kerouac', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Jack Kerouac') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Jack London', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Jack London') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Jacques Hebenstreit', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Jacques Hebenstreit') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'James Joyce', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('James Joyce') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'James Matthew Barrie', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('James Matthew Barrie') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'James R. Flynn', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('James R. Flynn') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Jane Austen', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Jane Austen') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Jane Cary Peck', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Jane Cary Peck') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Jane Loevinger', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Jane Loevinger') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Jane Portal', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Jane Portal') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Jean Baptiste Say', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Jean Baptiste Say') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Jean Baudrillard', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Jean Baudrillard') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Jean Giono', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Jean Giono') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Jean Lave', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Jean Lave') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Jean-Loup Baer', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Jean-Loup Baer') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Jennette McCurdy', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Jennette McCurdy') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Jessica Townsend', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Jessica Townsend') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Jing Chen', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Jing Chen') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Johann Joachim Winckelmann', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Johann Joachim Winckelmann') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Johanna Lindsey', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Johanna Lindsey') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Johannes Hirschmeier', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Johannes Hirschmeier') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'John Aikin', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('John Aikin') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'John Boyne', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('John Boyne') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'John Dewey', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('John Dewey') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'John Gottman', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('John Gottman') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'John Grisham', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('John Grisham') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'John R. McIntyre', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('John R. McIntyre') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'John Ronald Reuel Tolkien', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('John Ronald Reuel Tolkien') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'John Ruskin', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('John Ruskin') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Jojo Moyes', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Jojo Moyes') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Jorunn Jacobsen Buckley', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Jorunn Jacobsen Buckley') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Joseph A. Schumpeter', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Joseph A. Schumpeter') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Joseph L. Cavinato', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Joseph L. Cavinato') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Joseph Warren Dauben', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Joseph Warren Dauben') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Josephine Tey', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Josephine Tey') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Judith McNaught', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Judith McNaught') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Judy Kay', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Judy Kay') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Jules Verne', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Jules Verne') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Jürgen Habermas', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Jürgen Habermas') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Kakuzō Okakura', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Kakuzō Okakura') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Kalyanmoy Deb', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Kalyanmoy Deb') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Karl Beckson', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Karl Beckson') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Karl Marx', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Karl Marx') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Kate Fleet', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Kate Fleet') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Kate Morton', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Kate Morton') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Kathryn Allen Rabuzzi', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Kathryn Allen Rabuzzi') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Kenneth Grahame', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Kenneth Grahame') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Kirk J. Schneider', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Kirk J. Schneider') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Knud Haakonssen', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Knud Haakonssen') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Knut Hamsun', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Knut Hamsun') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Kumari Jayawardena', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Kumari Jayawardena') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'L. Mirsky', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('L. Mirsky') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Lafcadio Hearn', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Lafcadio Hearn') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Lee Child', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Lee Child') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Len Jenkin', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Len Jenkin') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Leon Harold Warshay', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Leon Harold Warshay') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Leonardo (da Vinci)', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Leonardo (da Vinci)') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Lisa Zunshine', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Lisa Zunshine') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Lucius Annaeus Seneca', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Lucius Annaeus Seneca') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Ludwig Wittgenstein', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Ludwig Wittgenstein') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Lyman Frank Baum', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Lyman Frank Baum') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'M.P. Feldman', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('M.P. Feldman') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Marat Terterov', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Marat Terterov') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Marcus du Sautoy', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Marcus du Sautoy') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Mark Haddon', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Mark Haddon') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Mark Pesce', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Mark Pesce') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Mark Saunders', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Mark Saunders') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Mark Twain', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Mark Twain') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Mary Lee Zawadski', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Mary Lee Zawadski') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Mary Shelley', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Mary Shelley') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Mary Wollstonecraft Shelley', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Mary Wollstonecraft Shelley') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Michael Connelly', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Michael Connelly') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Michael White', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Michael White') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Michel Foucault', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Michel Foucault') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Muḥammad ibn Aḥmad Bīrūnī', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Muḥammad ibn Aḥmad Bīrūnī') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Muhammad Umer Chapra', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Muhammad Umer Chapra') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Murray Milgate', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Murray Milgate') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Nancy Holder', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Nancy Holder') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Nandan Kamath', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Nandan Kamath') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Nora Roberts', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Nora Roberts') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Norbert Wiener', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Norbert Wiener') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Norman K. Denzin', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Norman K. Denzin') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Oliver E. Williamson', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Oliver E. Williamson') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Orhan Pamuk', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Orhan Pamuk') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Oscar Wilde', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Oscar Wilde') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'P.D. James', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('P.D. James') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Paul Carus', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Paul Carus') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Plato', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Plato') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Plutarch', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Plutarch') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Ptolemy', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Ptolemy') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'R. Keith Sawyer', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('R. Keith Sawyer') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Riane Eisler', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Riane Eisler') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Richard B. Stuart', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Richard B. Stuart') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Richard Clogg', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Richard Clogg') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Richard H. Thaler', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Richard H. Thaler') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Roald Dahl', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Roald Dahl') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Robert Louis Stevenson', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Robert Louis Stevenson') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Robert Ludlum', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Robert Ludlum') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Robert Nozick', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Robert Nozick') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Roberto S. Mariano', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Roberto S. Mariano') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Roman Frigg', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Roman Frigg') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Ronald Brownrigg', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Ronald Brownrigg') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Ronald Herbert Sack', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Ronald Herbert Sack') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Rory C. O''Connor', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Rory C. O''Connor') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Rosanne du Bois Brouwer', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Rosanne du Bois Brouwer') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Ross Burns', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Ross Burns') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Royal Institution of Great Britain', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Royal Institution of Great Britain') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Royal Society of Canada', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Royal Society of Canada') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Ruth Rendell', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Ruth Rendell') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Santa Montefiore', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Santa Montefiore') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Serge Lang', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Serge Lang') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Sigmund Freud', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Sigmund Freud') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Silke Knippschild', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Silke Knippschild') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Siyuan Liu', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Siyuan Liu') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Slavoj Žižek', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Slavoj Žižek') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Stanley I. Greenspan', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Stanley I. Greenspan') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Stephen D. Fairbanks', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Stephen D. Fairbanks') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Stephen King', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Stephen King') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Steve Alten', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Steve Alten') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Sue Grafton', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Sue Grafton') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Sue Mosher', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Sue Mosher') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Suhas Patankar', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Suhas Patankar') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Sumathi Ramaswamy', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Sumathi Ramaswamy') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Thane Gustafson', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Thane Gustafson') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Theodor Adorno', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Theodor Adorno') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Theodore Provder', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Theodore Provder') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Thomas Hardy', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Thomas Hardy') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Thomas Sherrer Ross Boase', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Thomas Sherrer Ross Boase') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Thorstein Veblen', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Thorstein Veblen') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Tim Bowler', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Tim Bowler') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Tsering Shakya', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Tsering Shakya') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'United States. Bureau of International Commerce', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('United States. Bureau of International Commerce') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Ursula K. Le Guin', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Ursula K. Le Guin') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Valentina Cuccio', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Valentina Cuccio') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Vasiliki Limberis', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Vasiliki Limberis') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Virginia Woolf', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Virginia Woolf') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Wallace D. Wattles', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Wallace D. Wattles') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Walter Isaacson', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Walter Isaacson') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'William Fulton', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('William Fulton') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'William G. Zikmund', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('William G. Zikmund') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'William Henry Giles Kingston', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('William Henry Giles Kingston') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'William James', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('William James') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'William Smith', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('William Smith') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Yann Martel', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Yann Martel') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Yiu-Wai Chu', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Yiu-Wai Chu') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Yukio Mishima', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Yukio Mishima') AND marked_as_deleted = FALSE);

INSERT INTO public.author
(name, description, birthdate, deathdate, country, age, gender, image_url, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT 'Zhongzhi Shi', '', DATE '1970-01-01', NULL, 'Unknown', 0, 'OTHERS', '/book-service/book-covers/default-book-cover.svg', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE NOT EXISTS (SELECT 1 FROM public.author WHERE lower(name) = lower('Zhongzhi Shi') AND marked_as_deleted = FALSE);

INSERT INTO public.book_category
(name, description, created_date, modified_date, created_by, modified_by, marked_as_deleted)
VALUES ('Action and Adventure', '', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE)
ON CONFLICT (name) DO NOTHING;

INSERT INTO public.book_category
(name, description, created_date, modified_date, created_by, modified_by, marked_as_deleted)
VALUES ('Art', '', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE)
ON CONFLICT (name) DO NOTHING;

INSERT INTO public.book_category
(name, description, created_date, modified_date, created_by, modified_by, marked_as_deleted)
VALUES ('Biography', '', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE)
ON CONFLICT (name) DO NOTHING;

INSERT INTO public.book_category
(name, description, created_date, modified_date, created_by, modified_by, marked_as_deleted)
VALUES ('Business', '', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE)
ON CONFLICT (name) DO NOTHING;

INSERT INTO public.book_category
(name, description, created_date, modified_date, created_by, modified_by, marked_as_deleted)
VALUES ('Computer Science', '', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE)
ON CONFLICT (name) DO NOTHING;

INSERT INTO public.book_category
(name, description, created_date, modified_date, created_by, modified_by, marked_as_deleted)
VALUES ('Economics', '', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE)
ON CONFLICT (name) DO NOTHING;

INSERT INTO public.book_category
(name, description, created_date, modified_date, created_by, modified_by, marked_as_deleted)
VALUES ('Fantasy', '', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE)
ON CONFLICT (name) DO NOTHING;

INSERT INTO public.book_category
(name, description, created_date, modified_date, created_by, modified_by, marked_as_deleted)
VALUES ('Fiction', '', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE)
ON CONFLICT (name) DO NOTHING;

INSERT INTO public.book_category
(name, description, created_date, modified_date, created_by, modified_by, marked_as_deleted)
VALUES ('History', '', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE)
ON CONFLICT (name) DO NOTHING;

INSERT INTO public.book_category
(name, description, created_date, modified_date, created_by, modified_by, marked_as_deleted)
VALUES ('Horror', '', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE)
ON CONFLICT (name) DO NOTHING;

INSERT INTO public.book_category
(name, description, created_date, modified_date, created_by, modified_by, marked_as_deleted)
VALUES ('Mathematics', '', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE)
ON CONFLICT (name) DO NOTHING;

INSERT INTO public.book_category
(name, description, created_date, modified_date, created_by, modified_by, marked_as_deleted)
VALUES ('Mystery', '', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE)
ON CONFLICT (name) DO NOTHING;

INSERT INTO public.book_category
(name, description, created_date, modified_date, created_by, modified_by, marked_as_deleted)
VALUES ('Philosophy', '', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE)
ON CONFLICT (name) DO NOTHING;

INSERT INTO public.book_category
(name, description, created_date, modified_date, created_by, modified_by, marked_as_deleted)
VALUES ('Psychology', '', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE)
ON CONFLICT (name) DO NOTHING;

INSERT INTO public.book_category
(name, description, created_date, modified_date, created_by, modified_by, marked_as_deleted)
VALUES ('Romantic', '', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE)
ON CONFLICT (name) DO NOTHING;

INSERT INTO public.book_category
(name, description, created_date, modified_date, created_by, modified_by, marked_as_deleted)
VALUES ('Science Fiction', '', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE)
ON CONFLICT (name) DO NOTHING;

INSERT INTO public.book_category
(name, description, created_date, modified_date, created_by, modified_by, marked_as_deleted)
VALUES ('Self-Help', '', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE)
ON CONFLICT (name) DO NOTHING;

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('倪匡') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Action and Adventure' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), '追空', 0, 0, 0, 221, 442, DATE '2004-01-01', '', '/book-service/book-covers/default-book-cover.svg', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('倪匡') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Action and Adventure' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('追空')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Anthony Horowitz') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Action and Adventure' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Ark Angel', 0, 0, 0, 100, 200, DATE '2007-04-05', 'Alex Rider is now an IMDb TV/Amazon Original Series! Alex Rider is an orphan turned teen superspy who''s saving the world one mission at a time—from #1 New York Times bestselling author! The sniper’s bullet nearly killed him. But Alex Rider managed to survive . . . just in time for more trouble to come his way. When kidnappers attempt to snatch a fellow patient from the exclusive hospital where Alex is recovering, he knows he has to stop him. But the boy he saves is no ordinary patient: He is the son of Nikolai Drevin, one of the richest men in the world. The eccentric billionaire has been targeted by Force Three, a group of eco-terrorists who claim his project Ark Angel—the first luxury hotel in outer space—is a danger to the environment. Soon Alex discovers that Force Three will stop at nothing to destroy Ark Angel, even if it means sending four hundred tons of molten glass and steel hurtling down to Earth and killing millions . . . unless Alex can stop them. From the author of Magpie Murders and Moriarty.', 'https://books.google.com/books/content?id=2JaMEAAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Anthony Horowitz') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Action and Adventure' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Ark Angel')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Roald Dahl') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Action and Adventure' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Fantastic Mr. Fox', 0, 0, 0, 90, 180, DATE '1995-01-01', '', 'https://books.google.com/books/content?id=4tuEuAAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Roald Dahl') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Action and Adventure' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Fantastic Mr. Fox')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('J. K. Rowling') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Action and Adventure' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Harry Potter and the Chamber of Secrets', 0, 5, 1, 260, 520, DATE '1999-01-01', 'Witchcraft, wizardry - fiction.', 'https://books.google.com/books/content?id=nmXTy4FPfcwC&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('J. K. Rowling') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Action and Adventure' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Harry Potter and the Chamber of Secrets')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Yann Martel') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Action and Adventure' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Life of Pi', 0, 5, 1, 100, 200, DATE '2011-01-01', 'After the sinking of a cargo ship, a solitary lifeboat remains bobbing on the wild blue Pacific. The only survivors from the wreck are a sixteen-year-old boy named Pi, a hyena, a wounded zebra, an orangutan, and a 450-pound Royal Bengal tiger.', 'https://books.google.com/books/content?id=G850QgAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Yann Martel') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Action and Adventure' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Life of Pi')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Tim Bowler') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Action and Adventure' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'River Boy', 0, 0, 0, 167, 334, DATE '2011-11-03', 'Grandpa is dying. He can barely move his hands any more but, stubborn as ever, refuses to stay in hospital. He''s determined to finish his last painting, ''River Boy'', before he goes. At first Jess can''t understand his refusal to let go, but then she too becomes involved in the mysterious painting. And when she meets the river boy himself, she finds she is suddenly caught up in a challenge of her own that she must complete - before it''s too late . . .', 'https://books.google.com/books/content?id=MrnuAwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Tim Bowler') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Action and Adventure' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('River Boy')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Mark Twain') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Action and Adventure' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Adventures of Tom Sawyer', 0, 5, 1, 247, 494, DATE '2007-03-08', 'In this enduring and internationally popular novel, Mark Twain combines social satire and dime-novel sensation with a rhapsody on boyhood and on America''s pre-industrial past. Tom Sawyer, resilient, enterprising, and vainglorious, has long been a defining figure in the American cultural imagination. - ;''Tom was a glittering hero once more - the pet of the old, and the envy of the young...There were some that believed he would be President yet, if he escaped hanging.'' In this enduring and internationally popular novel, Mark ogaincombines social satire and dime-novel sensation with a rhapsody on boyhood and on America''s pre-industrial past. Tom Sawyer is resilient, enterprising, and vainglorious. In a series of adventures along the banks of the Mississippi, he usually manages to come out on top. From petty triumphs over his friends and over his long-suffering Aunt Polly, to his intervention in a murder trial, Tom engages readers of all ages. He has long been a defining figure in the American cultural imagination. Alongside the charm and the excitement, Twain raises serious questions about community, race, and the past. Above all, the book invites discussion of the way in which childhood is invoked to counter the uncomfortable truths of the adult world. -', 'https://books.google.com/books/content?id=8AXw9GY3DJgC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Mark Twain') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Action and Adventure' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Adventures of Tom Sawyer')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('John Boyne') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Action and Adventure' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Boy in the Striped Pyjamas', 0, 0, 0, 215, 430, DATE '2006-01-01', 'The story of The Boy in the Striped Pyjamas is very difficult to describe. Usually we give some clues about the book on the cover, but in this case we think that would spoil the reading of the book. We think it is important that you start to read without knowing what it is about.If you do start to read this book, you will go on a journey with a nine-year-old boy called Bruno. (Though this isn''t a book for nine-year-olds.) And sooner or later you will arrive with Bruno at a fence. We hope you never have to cross such a fence.', 'https://books.google.com/books/content?id=F6dGAAAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('John Boyne') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Action and Adventure' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Boy in the Striped Pyjamas')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('William Henry Giles Kingston') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Action and Adventure' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Boy Who Sailed with Blake', 0, 0, 0, 142, 284, DATE '2023-10-04', 'In ''The Boy who sailed with Blake'' by William Henry Giles Kingston, readers are taken on a riveting adventure set during the time of the English Civil War. Through vivid storytelling and detailed descriptions, the book captures the maritime world of the 17th century, making it a captivating read for history enthusiasts and fans of adventure literature. Kingston''s writing style is engaging, blending historical facts with a fictional account that immerses readers in the world of naval battles and ship voyages of the past. The book''s portrayal of young protagonist and his journey with the famous Admiral Blake provides a unique perspective on the historical events of the time, making it both educational and entertaining for readers.', 'https://books.google.com/books/content?id=uC_cEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('William Henry Giles Kingston') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Action and Adventure' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Boy Who Sailed with Blake')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Brian Jacques') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Action and Adventure' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Long Patrol', 0, 4, 20, 380, 760, DATE '1998-01-01', 'Tammo, a daring young hare hungry for adventure, is sent with Russa Nodrey, the wandering red squirrel, to join the Long Patrol and defend Salamandastron against the Rapscallion horde.', 'https://books.google.com/books/content?id=_U7TS4cHEoMC&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Brian Jacques') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Action and Adventure' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Long Patrol')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Hergé') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Action and Adventure' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Tintin in America', 0, 0, 0, 100, 200, DATE '1979-11-30', 'The classic graphic novel. Tintin comes to the U.S.A. to clean up the mean streets of Chicago but ends up in the wild west! Will Tintin make it back home?', '/book-service/book-covers/default-book-cover.svg', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Hergé') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Action and Adventure' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Tintin in America')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Robert Louis Stevenson') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Action and Adventure' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Treasure Island', 0, 0, 0, 332, 664, DATE '1906-01-01', 'While going through the possessions of a deceased guest who owed them money, the mistress of the inn and her son find treasure map that leads to a pirate fortune as well as great danger.', 'https://books.google.com/books/content?id=U2g1AAAAMAAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Robert Louis Stevenson') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Action and Adventure' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Treasure Island')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Jack London') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Action and Adventure' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'White Fang', 0, 3.5, 5, 348, 696, DATE '1906-01-01', '', 'https://books.google.com/books/content?id=2M7SIhEj9eYC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Jack London') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Action and Adventure' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('White Fang')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Guanzhong Luo') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), '三國志演義 : Romance of the three kingdoms', 0, 0, 0, 1242, 2484, DATE '2000-01-01', '三國志演義 : Romance of the three kingdoms Guanzhong Luo', 'https://books.google.com/books/content?id=7YrxEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Guanzhong Luo') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('三國志演義 : Romance of the three kingdoms')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Jane Portal') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Art Under Control in North Korea', 0, 0, 0, 196, 392, DATE '2005-08-15', '"Art Under Control in North Korea is the first publication in the West to explore the role of art in one of the world''s most isolated nations. This timely publication places North Korean art in its historical, political and social contexts, discusses the state system of producing, employing, promoting and honouring artists, and examines the range of art produced, from painting and calligraphy to architecture and applied art. Jane Portal also compares the control exerted over artists by North Korean leaders to that of other absolute dictatorships, and looks at the way in which archaeology has been employed for political ends to justify the present leadership and its lineage."--BOOK JACKET.', 'https://books.google.com/books/content?id=zWH05CbG02kC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Jane Portal') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Art Under Control in North Korea')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Gogol Google Translate') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Dead Souls', 0, 0, 0, 266, 532, DATE '2018-05-31', 'This is the famed Gogol''s unfinished novel as translated by google translate, which is to say that it''s total gibberish, which, in its turn, is to say that you don''t really have to read it (I didn''t although I should one day because I brought it into being after all, and it might be fun) but you certainly want to have it. Think of it as a coffee table book to be casually picked up and as casually put back where it belongs.', 'https://books.google.com/books/content?id=6H9eDwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Gogol Google Translate') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Dead Souls')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Vasiliki Limberis') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Divine Heiress', 0, 0, 0, 212, 424, DATE '2002-03-11', 'Divine Heiress explores the vital role of the Virgin Mary in the cultural and religious life of Constantinople in late antiquity. It shows how she was transformed from a humble Jewish maiden into a divine figure and supernatural protector of Constantinople. Vasiliki Limberis examines the cult of Mary in the context of the religious culture of the Mediterranean world and the imperial Christianity of the Roman Empire. The author looks at all the evidence for the cult but pays particular attention to the early hymns to the virgin. These hymns preserved the strong indigenous goddess traditions of Demeter/Persephone, Isis, Hecate and Athena. By studying them the author places the cult of Mary in its historical and cultural context.', 'https://books.google.com/books/content?id=nbSHAgAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Vasiliki Limberis') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Divine Heiress')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Thomas Sherrer Ross Boase') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Giorgio Vasari', 0, 0, 0, 392, 784, DATE '2023-08-15', 'A striking account of Vasari’s career, friendships, and contribution to the art of the Italian Renaissance Vasari’s Lives of the Most Excellent Architects, Painters, and Sculptors, first published in 1550, fixed for three hundred years general European views about the art of the Renaissance, and its influence still lingers today. While much has been written about Vasari’s writings, comparatively few full-length studies have dealt with the man himself. In this book, T.S.R. Boase offers a compelling account of Vasari’s life and career. At the same time, Boase explores Vasari’s ideas about the art and artists he described in the two editions of his Lives, placing these reflections in their contemporary context and later developments in art history and criticism. The result is an important appraisal of Vasari’s achievement, which despite its imperfections is without parallel in the history of Western art.', 'https://books.google.com/books/content?id=gRm3EAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Thomas Sherrer Ross Boase') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Giorgio Vasari')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('David Kroyanker') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Jerusalem Architecture', 0, 0, 0, 220, 440, DATE '1994-01-01', 'One of Israel''s leading city planners provides a pictorial and textual survey of the Holy City''s architecture. it explores the old City''s history and carries the reader through the ages via its architectural Opulance. the city is filled with one-of-a-kind properties which exclude it from definition in terms of traditional urban expression.', 'https://books.google.com/books/content?id=GRBQAAAAMAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('David Kroyanker') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Jerusalem Architecture')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Leonardo (da Vinci)') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Leonardo Da Vinci', 0, 0, 0, 656, 1312, DATE '1883-01-01', '', 'https://books.google.com/books/content?id=dixPAAAAYAAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Leonardo (da Vinci)') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Leonardo Da Vinci')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Yiu-Wai Chu') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Lost in Transition', 0, 0, 0, 231, 462, DATE '2013-05-13', 'In this timely and insightful book, Yiu-Wai Chu takes stock of Hong Kong''s culture since its transition to a Special Administrative Region of the People''s Republic of China in 1997. Hong Kong had long functioned as the capitalist and democratic stepping stone to China for much of the world. Its highly original popular culture was well known in Chinese communities, and its renowned film industry enjoyed worldwide audiences and far-reaching artistic influence. Chu argues that Hong Kong''s culture was "lost in transition" when it tried to affirm its international visibility and retain the status quo after 1997. In an era when China welcomed outsiders and became the world''s most rapidly developing economy, Hong Kong''s special position as a capitalist outpost was no longer a privilege. By drawing on various cultural discourses, such as film, popular music, and politics of everyday life, Chu provides an informative and critical analysis of the impact of China''s ascendency on the notion of "One Country, Two Cultures." Hong Kong can no longer function as a bridge between China and the world, writes Chu, and must now define itself from global, local, and national perspectives.', 'https://books.google.com/books/content?id=mCOOHHDvV_wC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Yiu-Wai Chu') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Lost in Transition')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('George Bernard Shaw') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Man and Superman', 0, 0, 0, 390, 780, DATE '2023-06-03', '"Man and Superman" by George Bernard Shaw is a complex play that intertwines comedy with philosophical discourse, exploring themes of human nature, societal norms, and the dynamics of sexual attraction. The play is structured around the character of Don Juan, reimagined in a modern context, who embodies the philosophical rebel challenging societal conventions. Shaw uses the character to delve into the nature of human instincts, the societal roles of men and women, and the philosophical underpinnings of love and marriage. The play is notable for its "Epistle Dedicatory," where Shaw addresses Arthur Bingham Walkley, discussing the evolution of the Don Juan archetype and its relevance in contemporary society. Shaw critiques the superficiality of societal norms and the constraints they impose on individual freedom and expression. The play''s narrative is interspersed with a dream sequence that serves as a philosophical dialogue, further exploring the themes of existentialism and the human condition. Shaw''s work is a reflection on the complexities of human relationships and the societal structures that shape them, offering a satirical yet profound commentary on the pursuit of personal and philosophical truth.', 'https://books.google.com/books/content?id=hGPPEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('George Bernard Shaw') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Man and Superman')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Eva Baer') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Metalwork in Medieval Islamic Art', 0, 0, 0, 400, 800, DATE '1984-06-30', '', 'https://books.google.com/books/content?id=74kmV14e90cC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Eva Baer') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Metalwork in Medieval Islamic Art')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Silke Knippschild') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Seduction and Power', 0, 0, 0, 497, 994, DATE '2025-10-07', 'From the author of the multi-million copy bestseller The 48 Laws of Power and The Laws of Human Nature, a mesmerizing handbook on seduction: the most subtle and effective form of power. This is the only authorized hardcover edition in the US. When raised to the level of art, seduction, an indirect and subtle form of power, has toppled empires, won elections and enslaved great minds. Immerse yourself in the twenty-four maneuvers and strategies of the seductive process, the ritual by which a seducer gains mastery over his target. Understand how to “Poeticize Your Presence,” “Keep them in Suspense – What Comes Next” and “Master the Art of the Bold Move”. Every bit as essential as The 48 Laws of Power, The Art of Seduction is an indispensable primer of persuasion that reveals one of history''s greatest weapons and the ultimate form of power.', 'https://books.google.com/books/content?id=FMtzEQAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Silke Knippschild') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Seduction and Power')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Camille Paglia') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Sex, Art and American Culture', 0, 0, 0, 356, 712, DATE '1993-01-01', 'A collection of essays which have been published in papers such as "New Republic" and the academic journal "Arion". They discuss subjects such as rape, sex, beauty, Madonna, censorship, pornography, prostitution, media, gender and educational reform.', 'https://books.google.com/books/content?id=S4_gLHOiwscC&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Camille Paglia') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Sex, Art and American Culture')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Anatole France') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Thais', 0, 0, 0, 216, 432, DATE '2020-09-28', 'ÊIn those days there were many hermits living in the desert. On both banks of the Nile numerous huts, built by these solitary dwellers, of branches held together by clay, were scattered at a little distance from each other, so that the inhabitants could live alone, and yet help one another in case of need. Churches, each surmounted by a cross, stood here and there amongst the huts, and the monks flocked to them at each festival to celebrate the services or to partake of the Communion. There were also, here and there on the banks of the river, monasteries, where the cenobites lived in separate cells, and only met together that they might the better enjoy their solitude. Both hermits and cenobites led abstemious lives, taking no food till after sunset, and eating nothing but bread with a little salt and hyssop. Some retired into the desert, and led a still more strange life in some cave or tomb. All lived in temperance and chastity; they wore a hair shirt and a hood, slept on the bare ground after long watching, prayed, sang psalms, and, in short, spent their days in works of penitence. As an atonement for original sin, they refused their body not only all pleasures and satisfactions, but even that care and attention which in this age are deemed indispensable. They believed that the diseases of our members purify our souls, and the flesh could put on no adornment more glorious than wounds and ulcers. Thus, they thought they fulfilled the words of the prophet, "The desert shall rejoice and blossom as the rose." Amongst the inhabitants of the holy Thebaid, there were some who passed their days in asceticism and contemplation; others gained their livelihood by plaiting palm fibre, or by working at harvest-time for the neighbouring farmers. The Gentiles wrongly suspected some of them of living by brigandage, and allying themselves to the nomadic Arabs who robbed the caravans. But, as a matter of fact, the monks despised riches, and the odour of their sanctity rose to heaven. Angels in the likeness of young men, came, staff in hand, as travellers, to visit the hermitages; whilst demonsÑhaving assumed the form of Ethiopians or of animalsÑwandered round the habitations of the hermits in order to lead them into temptation. When the monks went in the morning to fill their pitcher at the spring, they saw the footprints of Satyrs and Aigipans in the sand. The Thebaid was, really and spiritually, a battlefield, where, at all times, and more especially at night, there were terrible conflicts between heaven and hell.', 'https://books.google.com/books/content?id=pnkne4w4btYC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Anatole France') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Thais')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Oscar Wilde') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Decay of Lying', 0, 0, 0, 39, 78, DATE '2022-04-18', 'Could it be that people who never lie are devoid of creativity? If that’s true, then all creative art must be founded in lies. ‘The Decay of Lying’ is a beguiling essay on the nature of art, in all its forms. Set in the library of a country house in Nottinghamshire, and written as a dialogue between Cyril and Vivian, ‘The Decay of Lying’ sets out to prove just how creative we can all be, as long as we defy societal conventions. Referencing everyone from the Ancient Greeks to Shakespeare, this is Wilde at his most thoughtful and mischievous. For anyone interested in art or witty debate. Oscar Wilde (1854 – 1900) was an Irish novelist, poet, playwright, and wit. He was an advocate of the Aesthetic movement, which extolled the virtues of art for the sake of art. During his career, Wilde wrote nine plays, including ‘The Importance of Being Earnest,’ ‘Lady Windermere’s Fan,’ and ‘A Woman of No Importance,’ many of which are still performed today. His only novel, ‘The Picture of Dorian Gray’ was adapted for the silver screen, in the film, ‘Dorian Gray,’ starring Ben Barnes and Colin Firth. In addition, Wilde wrote forty-three poems, and seven essays. His life was the subject of a film, starring Stephen Fry.', 'https://books.google.com/books/content?id=L_tnEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Oscar Wilde') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Decay of Lying')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Johann Joachim Winckelmann') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The History of Ancient Art', 0, 0, 0, 616, 1232, DATE '1872-01-01', '', 'https://books.google.com/books/content?id=VekwAQAAMAAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Johann Joachim Winckelmann') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The History of Ancient Art')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Kakuzō Okakura') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Ideals of the East', 0, 0, 0, 256, 512, DATE '1920-01-01', '', 'https://books.google.com/books/content?id=frifAAAAMAAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Kakuzō Okakura') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Ideals of the East')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Jean Giono') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Man who Planted Trees', 0, 5, 1, 74, 148, DATE '2007-07-23', '"[This book is the story] of Elzeard Bouffier, a man of great simplicity and determination. He travels to Provence, in southeastern France and there alone with his sheep and dog, he builds a stone house and daily plants one hundred acorns."--', 'https://books.google.com/books/content?id=A3lq-ll42rIC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Jean Giono') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Man who Planted Trees')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Guy Debord') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Society of the Spectacle', 0, 0, 0, 153, 306, DATE '2022-05-29', 'In "The Society of the Spectacle," Guy Debord presents a critical analysis of contemporary society, where social life is increasingly mediated by images and representations. Written in a provocative and aphoristic style, Debord''s text is an incisive examination of how spectacle—defined as the commodified representations of life—shapes human experience, social relations, and consciousness. Contextually rooted in Marxist theory, the book articulates the ways in which capitalism subsumes authentic social relations into a superficial spectacle, affecting both perception and reality. Its vivid discussions and theoretical depth render it a foundational text in the realms of cultural criticism, media studies, and revolutionary theory. Debord, a founding member of the Situationist International, was deeply influenced by the socio-political upheavals of post-war France, particularly May 1968, which informed his view of alienation in modern life. His experiences as a filmmaker and theorist led him to investigate the intersections of art, politics, and daily existence, culminating in this seminal work that critiques the banality of consumer culture. Debord''s erudition and radical insights are products of his time, yet resonate with the contemporary landscape of digital media and cultural commodification. Highly recommended for scholars, activists, and anyone interested in understanding the pervasive influence of media in shaping modern identity, "The Society of the Spectacle" challenges readers to question their engagement with the spectacle and to redefine the parameters of authentic social interaction in an age dominated by images. In this enriched edition, we have carefully created added value for your reading experience: - A succinct Introduction situates the work''s timeless appeal and themes. - The Synopsis outlines the central plot, highlighting key developments without spoiling critical twists. - A detailed Historical Context immerses you in the era''s events and influences that shaped the writing. - An Author Biography reveals milestones in the author''s life, illuminating the personal insights behind the text. - A thorough Analysis dissects symbols, motifs, and character arcs to unearth underlying meanings. - Reflection questions prompt you to engage personally with the work''s messages, connecting them to modern life. - Hand‐picked Memorable Quotes shine a spotlight on moments of literary brilliance. - Interactive footnotes clarify unusual references, historical allusions, and archaic phrases for an effortless, more informed read.', 'https://books.google.com/books/content?id=ZQBzEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Guy Debord') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Art' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Society of the Spectacle')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('William Smith') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'A Classical Dictionary of Greek and Roman Biography, Mythology and Geography', 0, 0, 0, 948, 1896, DATE '1889-01-01', '', 'https://books.google.com/books/content?id=Srp1GnpRywAC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('William Smith') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('A Classical Dictionary of Greek and Roman Biography, Mythology and Geography')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Ida Minerva Tarbell') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'A Short Life of Napoleon Bonaparte', 0, 0, 0, 272, 544, DATE '1895-01-01', '', 'https://books.google.com/books/content?id=3MwaAAAAYAAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Ida Minerva Tarbell') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('A Short Life of Napoleon Bonaparte')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Charles Knight') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Biography', 0, 0, 0, 534, 1068, DATE '2020-12-02', 'This book has been considered by academicians and scholars of great significance and value to literature. This forms a part of the knowledge base for future generations. So that the book is never forgotten we have represented this book in a print format as the same form as it was originally first published. Hence any marks or annotations seen are left intentionally to preserve its true nature.', 'https://books.google.com/books/content?id=rjkTzgEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Charles Knight') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Biography')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Adrian Keith Goldsworthy') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Caesar', 0, 0, 0, 100, 200, DATE '2007-01-01', 'The story of one of the most brilliant, flamboyant and historically important men who ever lived.', 'https://books.google.com/books/content?id=q29cPgAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Adrian Keith Goldsworthy') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Caesar')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('William Smith') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Dictionary of Greek and Roman Biography and Mythology: Earinus-Nyx', 0, 0, 0, 1238, 2476, DATE '1846-01-01', '', 'https://books.google.com/books/content?id=870_AQAAIAAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('William Smith') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Dictionary of Greek and Roman Biography and Mythology: Earinus-Nyx')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Elizabeth Gilbert') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Eat, Pray, Love', 0, 3.5, 2, 385, 770, DATE '2007-03-05', 'The Number One international bestseller, Eat, Pray Love is a journey around the world, a quest for spiritual enlightenment and a story for anyone who has battled with divorce, depression and heartbreak.', 'https://books.google.com/books/content?id=QdCNeNx6LJUC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Elizabeth Gilbert') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Eat, Pray, Love')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Walter Isaacson') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Einstein', 0, 0, 0, 704, 1408, DATE '2017-04-11', 'From Isaacson, the bestselling author of "Benjamin Franklin," comes the first full biography of Albert Einstein since all his papers have become available--a fully realized portrait of a premier icon of his era.', 'https://books.google.com/books/content?id=d2WZDgAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Walter Isaacson') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Einstein')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Dalai Lama XIV Bstan-ʼdzin-rgya-mtsho') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Freedom in Exile', 0, 0, 0, 328, 656, DATE '1990-01-01', 'The autobiography of the Dalai Lama who won the 1989 Nobel Peace Prize.', 'https://books.google.com/books/content?id=aeEKAAAAYAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Dalai Lama XIV Bstan-ʼdzin-rgya-mtsho') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Freedom in Exile')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('John Aikin') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'General Biography', 0, 0, 0, 720, 1440, DATE '2019-04-04', 'This work has been selected by scholars as being culturally important, and is part of the knowledge base of civilization as we know it. This work was reproduced from the original artifact, and remains as true to the original work as possible. Therefore, you will see the original copyright references, library stamps (as most of these works have been housed in our most important libraries around the world), and other notations in the work. This work is in the public domain in the United States of America, and possibly other nations. Within the United States, you may freely copy and distribute this work, as no entity (individual or corporate) has a copyright on the body of the work. As a reproduction of a historical artifact, this work may contain missing or blurred pages, poor pictures, errant marks, etc. Scholars believe, and we concur, that this work is important enough to be preserved, reproduced, and made generally available to the public. We appreciate your support of the preservation process, and thank you for being an important part of keeping this knowledge alive and relevant.', 'https://books.google.com/books/content?id=Uo4vzQEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('John Aikin') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('General Biography')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Jennette McCurdy') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'I''m Glad My Mom Died', 0, 0, 0, 320, 640, DATE '2025-11-18', '"A heartbreaking and hilarious memoir by iCarly and Sam & Cat star Jennette McCurdy about her struggles as a former child actor--including eating disorders, addiction, and a complicated relationship with her overbearing mother--and how she retook control of her life"--]cProvided by publisher.', 'https://books.google.com/books/content?id=OL-QEQAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Jennette McCurdy') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('I''m Glad My Mom Died')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Diogenes Laertius') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Lives of the Eminent Philosophers', 0, 0, 0, 701, 1402, DATE '2018-01-01', 'Lives of the Eminent Philosophers of Diogenes Laertius is a crucial source for much of what we know about the origins of philosophy in ancient Greece. Accompanied by dozens of artworks and newly commissioned essays that shed light on Diogenes'' context and influence, this new, complete translation provides a revealing glimpse into the philosophers of Plato''s Academy, Aristotle''s Lyceum, and Epicurus'' Garden.', 'https://books.google.com/books/content?id=HLNSDwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Diogenes Laertius') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Lives of the Eminent Philosophers')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Plutarch') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Plutarch''s Lives', 0, 0, 0, 410, 820, DATE '1794-01-01', '', 'https://books.google.com/books/content?id=fSUJAAAAQAAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Plutarch') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Plutarch''s Lives')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Plutarch') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Plutarch''s Lives Translated from the Original Greek', 0, 0, 0, 490, 980, DATE '1801-01-01', '', 'https://books.google.com/books/content?id=IDIZAAAAYAAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Plutarch') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Plutarch''s Lives Translated from the Original Greek')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Plutarch') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Plutarch''s Lives, tr. by J. and W. Langhorne', 0, 0, 0, 550, 1100, DATE '1813-01-01', '', 'https://books.google.com/books/content?id=83y1P8lq7WYC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Plutarch') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Plutarch''s Lives, tr. by J. and W. Langhorne')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Desmond Shum') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Red Roulette', 0, 0, 0, 336, 672, DATE '2022-09-06', 'After the Communist Revolution, Desmond Shum''s grandfather was marked as belonging to a "black category" that included former landlords and rich peasants--meaning the Shums would be stigmatized and impoverished. As Desmond was growing up, he vowed his life would be different. Through hard work and sheer tenacity Shum earned an American college degree and returned to China to establish himself in business. There, he met his future wife, the highly intelligent and equally ambitious Whitney Duan who was determined to make her mark within China''s male-dominated society. Whitney and Desmond formed an effective team and, aided by relationships they formed with top members of the red aristocracy, vaulted into China''s billionaire class. Soon they were developing the massive air cargo facility at Beijing International Airport, and they followed that feat with the creation of one of Beijing''s premier hotels. They were dazzlingly successful, traveling in private jets, funding multi-million-dollar buildings and endowments, and purchasing expensive homes, vehicles, and art. But in 2017, their fates diverged irrevocably when Desmond, while residing overseas with his son, learned that his now ex-wife Whitney had vanished along with three coworkers. This is both Desmond''s story and Whitney''s, because she cannot tell it herself.', 'https://books.google.com/books/content?id=w3mAEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Desmond Shum') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Red Roulette')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Plutarch') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Lives of the Noble Grecians and Romaines,', 0, 0, 0, 1214, 2428, DATE '1579-01-01', '', 'https://books.google.com/books/content?id=JREQ5Sok-p8C&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Plutarch') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Lives of the Noble Grecians and Romaines,')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Plutarch') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Lives of the Noble Grecians and Romanes', 0, 0, 0, 100, 200, DATE '1928-01-01', '', '/book-service/book-covers/default-book-cover.svg', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Plutarch') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Lives of the Noble Grecians and Romanes')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Charles H. Talbert') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'What is a Gospel?', 0, 0, 0, 168, 336, DATE '1978-01-01', '', 'https://books.google.com/books/content?id=pu7YAAAAMAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Charles H. Talbert') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('What is a Gospel?')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Canon Ronald Brownrigg') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Who''s Who in the New Testament', 0, 0, 0, 362, 724, DATE '2003-09-02', 'Who''s Who in The New Testament is the most complete and detailed reference book of its kind. Paying close attention to the places linked with the major events of Jesus''s life, it provides: * over 300 extensive entries covering every major character * detailed biographical information on each character, including exactly where to find them in the Bible * the complete historical, geographical and archaeological context of each entry * an extremely accessible and easy to use A-Z layout * extensive geographical entries focusing on the growth of the Christian Church and the key locations in the New Testament * comprehensive interpretative analysis of the varying versions of the Gospels and the characters of the authors.', 'https://books.google.com/books/content?id=JXqBAgAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Canon Ronald Brownrigg') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Biography' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Who''s Who in the New Testament')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Anthony G. Hopwood') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Accounting for Sustainability', 0, 0, 0, 100, 200, DATE '1988-01-01', '', '/book-service/book-covers/default-book-cover.svg', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Anthony G. Hopwood') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Accounting for Sustainability')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('John R. McIntyre') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Business and Management Education in Transitioning and Developing Countries', 0, 0, 0, 464, 928, DATE '2014-12-18', 'Business education is a critical ingredient in establishing a viable middle class of managers in transitioning and developing economies. Compiled in association with the Center for International Business Education and Research, this comprehensive examination of business and management education, pedagogical models, and curricula innovations in institutions around the world is the first such work to emphasize emerging markets.', 'https://books.google.com/books/content?id=WVbfBQAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('John R. McIntyre') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Business and Management Education in Transitioning and Developing Countries')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('William G. Zikmund') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Business Research Methods', 0, 0, 0, 776, 1552, DATE '1994-01-01', '', '/book-service/book-covers/default-book-cover.svg', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('William G. Zikmund') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Business Research Methods')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('E. Mumford') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Dangerous Decisions', 0, 0, 0, 233, 466, DATE '2013-06-05', 'In a world where technology is continually advancing, and problems are becoming more and more complex, established practices for decision making and problem solving are no longer effective. In this new book, however, Enid Mumford draws on her wealth of experience in management, business schools, and working with the police and other professional problem solvers to show us how to tackle complex problems efficiently. With drugs and cyber-crime as her main examples Professor Mumford shows how these topical, yet apparently permanent problems, could be approached. She does this by looking at how the criminals themselves have overcome legal obstacles, and other problems to make the drug trafficking industry the second largest in the world today, and the relative newcomer, electronic fraud, a multi-billion dollar problem already. These crimes, which in themselves lead to more crime from petty theft to support a drug habit, to international money laundering, are incredibly complex, and yet the book shows us that there is not only a way forward with these issues, but a way to approach all complex problems with efficiency and competency, wherever they occur in our lives.', 'https://books.google.com/books/content?id=9IUdswEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('E. Mumford') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Dangerous Decisions')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Marat Terterov') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Doing Business with Lithuania', 0, 0, 0, 366, 732, DATE '2005-01-01', 'Originally published in the pre-EU-accession period, this E-Book edition of Doing Business with Lithuania has been updated to take account of the post-accession changes to the legal and fiscal environment. It remains a definitive appraisal of the economic system and investment climate, including an examination of the legal structure and business regulation, information on the financial sector and unique best practice on all aspects of trading with and investing in Lithuania. The guide also provides an overview of key sectors of trade and investment.', 'https://books.google.com/books/content?id=0KWJf6mVorEC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Marat Terterov') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Doing Business with Lithuania')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Christian N. Madu') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Environmental Planning and Management', 0, 0, 0, 255, 510, DATE '2007-01-01', 'This book focuses on environmental planning and management. Environmental problems are not purely scientific; some of the major problems deal with poor management and the inability to involve people in environmental decision making process. The approach taken in this book is to review environmental problems as they are affected by poor planning and management. Understanding of management issues involved will help to get top management to buy into environmental management. The tendency is for top management to view environmental management efforts as expensive and wasteful to an organization. However, when top management is exposed to the high cost of doing nothing and the lack of competitiveness as a result of poor environmental quality, it is more likely to buy into the idea of environmental quality and work towards achieving sustainable goals.', 'https://books.google.com/books/content?id=5a1gDQAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Christian N. Madu') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Environmental Planning and Management')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('United States. Bureau of International Commerce') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Iran', 0, 0, 0, 312, 624, DATE '1977-01-01', '', 'https://books.google.com/books/content?id=uQtrj-wdGcAC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('United States. Bureau of International Commerce') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Iran')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Oliver E. Williamson') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Markets and Hierarchies, Analysis and Antitrust Implications', 0, 0, 0, 312, 624, DATE '1975-01-01', '', 'https://books.google.com/books/content?id=I1i3AAAAIAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Oliver E. Williamson') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Markets and Hierarchies, Analysis and Antitrust Implications')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Sue Mosher') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Microsoft Outlook Programming', 0, 4, 2, 644, 1288, DATE '2002-10-10', '-- A one-minute-manager approach to issues-- Explanation of how following each principle can save money or time-- Step-by-step instructions on how to accomplish objectives This book shows people how to overcome the social crisis that has resulted from the wide-spread use of information technology by responsibly managing security threats, protecting individual privacy, reducing hazardous waste, and minimizing other negative effects on IT staff and computer users, as well as ordinary citizens around the world.', 'https://books.google.com/books/content?id=8M60Hy6B6LgC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Sue Mosher') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Microsoft Outlook Programming')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Mark Saunders') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Research Methods for Business Students', 0, 5, 1, 520, 1040, DATE '2003-09-01', '', 'https://books.google.com/books/content?id=oXYWwI21IoEC&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Mark Saunders') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Research Methods for Business Students')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Edmund K. Burke') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Search Methodologies', 0, 4, 1, 618, 1236, DATE '2006-03-20', 'This book is a tutorial survey of the methodologies that are at the confluence of several fields: Computer Science, Mathematics and Operations Research. It provides a carefully structured and integrated treatment of the major technologies in optimization and search methodology. The chapter authors are drawn from across Computer Science and Operations Research and include some of the world’s leading authorities in their field. It can be used as a textbook or a reference book to learn and apply these methodologies to a wide range of today’s problems.', 'https://books.google.com/books/content?id=X4BcOZEa4HsC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Edmund K. Burke') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Search Methodologies')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Yukio Mishima') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Silk and Insight', 0, 0, 0, 240, 480, DATE '2015-04-08', 'This is a tale based on the strike which took place in the mid-1950s at Omi Kenshi, a silk manufacturer not far from Tokyo. The events described reflect the management / labour tensions of the period and is a piece of social commentary on the transformation of Japanese business.', 'https://books.google.com/books/content?id=HWbxBwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Yukio Mishima') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Silk and Insight')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Joseph L. Cavinato') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Supply Chain and Transportation Dictionary', 0, 0, 0, 412, 824, DATE '2000-10-31', 'Now in its Fourth Edition, the Supply Chain and Transportation Dictionary maintains its position as the most comprehensive dictionary in the field. A one-of-a-kind reference, the dictionary remains unmatched in the breadth and scope of its coverage and is the primary reference for professionals working in the areas of supply chain management, transportation, distribution, logistics, material, and purchasing. The Fourth Edition features over 5,000 entries and is noted for its clear, precise, and accurate definitions.', 'https://books.google.com/books/content?id=QV9IntAExwIC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Joseph L. Cavinato') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Supply Chain and Transportation Dictionary')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('M.P. Feldman') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Economics of Science and Technology', 0, 0, 0, 132, 264, DATE '2012-12-06', 'Science and technology have long been regarded as important determinants of economic growth. Edwin Mansfield (1971, pp. 1- 2), a pioneer in the economics of technological change, noted: Technological change is an important, if not the most important, factor responsible for economic growth . . . without question, [it] is one of the most important determinants of the shape and evolution of the American economy. Science and technology are even more important in the "new economy," with its greater emphasis on the role of intellectual property and knowledge transfer. Therefore, it is unfortunate that most individuals rarely have the opportunity to explore the economic implications of science and technology. As a result, the antecedents and consequences of technological change are poorly understood by many in the general public. This lack of understanding is reflected in a recent survey conducted by the National Science Board (2000), summarized in Science & Engineering Indicators. '' As shown in Table 1. 1, the findings of the survey indicated that many Americans, despite a high level of interests in such matters, are not as well-informed about technological issues as they are about other policy issues. As shown in the table, individuals self assess, based on a scale from 1 to 100, their interest in science and technology policy issues as being relatively high, yet they self assess their knowledge or informedness about these issues relatively lower.', 'https://books.google.com/books/content?id=wca9BwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('M.P. Feldman') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Economics of Science and Technology')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Eliyahu M. Goldratt') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Goal', 0, 4, 5, 100, 200, DATE '2004-01-01', 'Mr. Rogo, a plant manager, must improve his factory''s efficiency or face its closing in just three months. Despite the fictional setting, Goldratt''s novel has become a classic business and management text.', 'https://books.google.com/books/content?id=Tw1iQgAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Eliyahu M. Goldratt') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Goal')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Johannes Hirschmeier') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Origins of Entrepreneurship in Meiji Japan', 0, 0, 0, 364, 728, DATE '2013-10-01', '', 'https://books.google.com/books/content?id=keCYngEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Johannes Hirschmeier') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Origins of Entrepreneurship in Meiji Japan')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Jing Chen') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Physical Foundation of Economics', 0, 0, 0, 147, 294, DATE '2005-01-01', 'All human activities, including mental activities, are governed by physical laws and are essentially thermodynamic processes. However, current economic theories are not established on these foundations. This pioneering book seeks to develop an analytical theory of economics on the foundation of thermodynamic laws. A unified understanding of economic and social phenomena is presented, an understanding that is much simpler than what mainstream economic theory has to offer. Its aim is to revolutionize thinking in economics and transform social sciences into an integral part of the physical and biological sciences.', 'https://books.google.com/books/content?id=-8BoDQAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Jing Chen') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Physical Foundation of Economics')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Riane Eisler') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Real Wealth of Nations', 0, 0, 0, 600, 1200, DATE '2017-05-23', 'From the author of the bestselling classic The Chalice and the Blade, The Real Wealth of Nations proposes a dramatic new economic model that could help resolve many of the most critical problems we face today, and offers concrete steps for putting this model into practice.Adam Smith''s The Wealth of Nations provided the first, most influential and lasting explanation of the workings of modern economics. But with his focus on ''''''''the market'''''''' as the best mechanism for producing and distributing the necessities of life, Smith''s concepts only told part of the story, leading to flawed economic models that devalue activities that fall outside of the market''s parameters of buying and selling. The real wealth of nations, Riane Eisler argues, is not merely financial, but includes the contributions of people and our natural environment. Here, Eisler goes beyond the market to reexamine economics from a larger perspective-and shows that we must give visibility and value to the socially andeconomically essential work of caring for people and the planet if we are to meet the enormous challenges we are facing. Most importantly, she provides practical proposals for new economic inventions-new measures, policies, rules, and practices-to bring about a caring economics that fulfills human needs.''''''''Eisler delivers another impressive work that''s remarkably well referenced, well argued, insightful, and hopeful', '/book-service/book-covers/default-book-cover.svg', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Riane Eisler') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Real Wealth of Nations')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Thorstein Veblen') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Theory of Business Enterprise', 0, 0, 0, 420, 840, DATE '1904-01-01', '', 'https://books.google.com/books/content?id=Pp2Ns7flMcQC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Thorstein Veblen') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Business' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Theory of Business Enterprise')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Roberto S. Mariano') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Computer Science' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Advances in Statistical Analysis and Statistical Computing', 0, 0, 0, 100, 200, DATE '1986-01-01', '', '/book-service/book-covers/default-book-cover.svg', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Roberto S. Mariano') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Computer Science' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Advances in Statistical Analysis and Statistical Computing')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Judy Kay') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Computer Science' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'C Programming in a UNIX Environment', 0, 0, 0, 356, 712, DATE '1988-01-01', '"This books is for anyone who already knows another programming language, and wants to be able to use C well. It is ideal for students of computer science who have taken an introductory programming course and need to progess rapidly to C before taking a course on operating systems or systems programming. It is also suitable for professionals, providing a comprehensive tutorial on C as well as a lasting reference book. Emphasis throughout is on developing a programming style which ensures safe code, that is both readable and maintainable. At the same time, the reader is encouraged to make full use of the standard libraries available in the UNIX environment and to acquire the UNIX ''tools'' philosophy." -- BOOK JACKET.', 'https://books.google.com/books/content?id=mPApAQAAMAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Judy Kay') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Computer Science' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('C Programming in a UNIX Environment')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Theodore Provder') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Computer Science' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Computer Applications in Applied Polymer Science II', 0, 0, 0, 592, 1184, DATE '1989-01-01', 'Addresses the impact of computer science on automation, modeling, simulation, and optimization of polymer science as a result of the availability of more powerful, lower-cost computers and modeling software. Five sections illustrate a wide variety of modeling applications, including laboratory and information automation; mathematical modeling, simulation, and optimization; cross-linking reactions and cure process modeling; polymerization kinetics and process modeling; and polymerization process control.', 'https://books.google.com/books/content?id=67iaAAAAIAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Theodore Provder') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Computer Science' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Computer Applications in Applied Polymer Science II')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Bryan Pfaffenberger') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Computer Science' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Computers in Your Future 2003', 0, 0, 0, 100, 200, DATE '1995-01-01', '', '/book-service/book-covers/default-book-cover.svg', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Bryan Pfaffenberger') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Computer Science' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Computers in Your Future 2003')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Jacques Hebenstreit') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Computer Science' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Education and Informatics Worldwide', 0, 0, 0, 266, 532, DATE '1992-01-01', '', 'https://books.google.com/books/content?id=-hKdAAAAMAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Jacques Hebenstreit') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Computer Science' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Education and Informatics Worldwide')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Zhongzhi Shi') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Computer Science' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Intelligence Science', 0, 0, 0, 682, 1364, DATE '2012-01-01', 'Intelligence Science is an interdisciplinary subject dedicated to joint research on basic theory and technology of intelligence by brain science, cognitive science, artificial intelligence and others. Brain science explores the essence of brain research on the principle and model of natural intelligence at the molecular, cell and behavior level. Cognitive science studies human mental activity, such as perception, learning, memory, thinking, consciousness etc. In order to implement machine intelligence, artificial intelligence attempts simulation, extension and expansion of human intelligence using artificial methodology and technology. Research scientists from the above three disciplines work together to explore new concepts, new theories, and methodologies. This book will introduce the concept and methodology of intelligence science systematically. The whole book is divided into 18 chapters altogether. It can be regarded as a textbook in courses of intelligence science, cognitive science, cognitive informatics etc. for senior and graduate students. It has important reference value for researchers engaged in fields such as intelligence science, brain science, cognitive science, neural science, artificial intelligence, psychology and so on.', 'https://books.google.com/books/content?id=Sm8ICyv5N3QC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Zhongzhi Shi') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Computer Science' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Intelligence Science')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('David Balson') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Computer Science' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'International Computer-based Conference on Biotechnology', 0, 0, 0, 112, 224, DATE '1985-01-01', 'An international computer conference on the bioconversion of lignocellulosics for fuel, fodder, and food took place from May to December 1983. It was initiated to evaluate the appropriateness of using computer conferencing to facilitate scientific discussions and to explore the application on the subject matter to development purposes.', 'https://books.google.com/books/content?id=a2WLAAAAIAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('David Balson') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Computer Science' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('International Computer-based Conference on Biotechnology')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Nandan Kamath') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Computer Science' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Law Relating to Computers, Internet, & E-commerce', 0, 0, 0, 876, 1752, DATE '2000-01-01', '', 'https://books.google.com/books/content?id=fRU9AQAAIAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Nandan Kamath') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Computer Science' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Law Relating to Computers, Internet, & E-commerce')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('David H. Jonassen') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Computer Science' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Modeling with Technology', 0, 0, 0, 244, 488, DATE '2006-01-01', 'Well-known for addressing the use of computers to foster critical-thinking and problem solving, this text was written to teach current and future teachers how to better engage learners more mindfully and meaningfully in the process of learning. Available now in it''s Third Edition, it focuses on how to use technology to support meaningful learning through model building, providing powerful strategies for engaging, supporting, and assessing coonceptual change in learners.', 'https://books.google.com/books/content?id=cw9KAAAAYAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('David H. Jonassen') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Computer Science' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Modeling with Technology')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('J. E. Lapin') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Computer Science' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Portable C and UNIX System Programming', 0, 0, 0, 274, 548, DATE '1987-01-01', 'This practical guide contains a detailed set of C standards and UNIX system comparisons for the construction of highly portable software. Professionals will learn the underlying causes of portability problems as well as the techniques for creating portable UNIX system software. It shortens the software development and test cycle and enables the user to reduce the cost of long-term support.', 'https://books.google.com/books/content?id=X0UiAQAAIAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('J. E. Lapin') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Computer Science' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Portable C and UNIX System Programming')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Jean-Loup Baer') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Computer Science' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Proceedings of the 1977 International Conference on Parallel Processing', 0, 0, 0, 264, 528, DATE '1977-01-01', '', 'https://books.google.com/books/content?id=bns_AQAAIAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Jean-Loup Baer') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Computer Science' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Proceedings of the 1977 International Conference on Parallel Processing')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Donald Ervin Knuth') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Computer Science' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Art of Computer Programming: Semi-numerical algorithms', 0, 0, 0, 648, 1296, DATE '1968-01-01', '', 'https://books.google.com/books/content?id=CIZQAAAAMAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Donald Ervin Knuth') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Computer Science' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Art of Computer Programming: Semi-numerical algorithms')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Mark Pesce') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Computer Science' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Playful World', 0, 0, 0, 312, 624, DATE '2000-01-01', 'As you read these words, the architects of the new virtual reality are inventing a world you never imagined: call it the playful world. It''s a world of interactive Web-based toys that instantly collapse the gulf between wish and existence, space and time, animate and inanimate. It''s a world where the entire fabric of the material world becomes manipulable, programmable, mutable. Situated at the crossroads of high technology and popular culture, the playful world is taking shape at the speed of electronic creativity. Are you ready for it? Your kids are. In this spellbinding new book, Mark Pesce, one of the pioneers in the ongoing technological revolution, explores how a new kind of knowing and a new way of creating are transforming the culture of our time. It started, bizarrely enough, with Furbys, the first toys that had the "will" to grow and interact intelligently with their environment. As Pesce argues, Furbys, for all their cloying cuteness, were a vital sign of a new human endeavor--the ability to copy part of our own intelligence into the physical world. But engineers of the playful world have already gone much further into considerably stranger virtual realms. Pesce takes us inside the world''s cutting-edge research facilities where the distinction between bits and atoms is rapidly dissolving. We meet the creators of LEGO Mindstorms, a snap-together plastic device that intelligently controls motors and processes data from sensors. We watch technological geniuses like Marvin Minsky and Eric Drexler turn the theoretical breakthroughs of Nobel laureate Richard Feynman into "nanites"-- tiny ultra-high-speed computers that replicate intelligent life. We observe the launch of the amazing and much-anticipated Sony Playstation 2, a platform that will allow us to bring synthetic worlds into the home and create a gateway to the living planet. Web-based toys are only the beginning--the first glimmer of a new reality that is transforming our entire culture with incredible speed and power. After all, thanks to the computer revolution and the Internet, all of us already command powers that just a generation ago would have been described as magical. Magic is about to take on a whole new dimension. In this dazzling book, Mark Pesce offers a mind-bending preview of the incredible future that awaits us all in The Playful World.', 'https://books.google.com/books/content?id=EboTAQAAIAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Mark Pesce') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Computer Science' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Playful World')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Daniel Cohen') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Computer Science' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Simon & Schuster Question & Answer Book, Computers', 0, 0, 0, 100, 200, DATE '1986-09-07', 'Includes questions and answers about United States geography, climate, history, places of interest, people, culture, and other topics.', '/book-service/book-covers/default-book-cover.svg', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Daniel Cohen') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Computer Science' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Simon & Schuster Question & Answer Book, Computers')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Claus Pias') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Computer Science' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Zukünfte des Computers', 0, 0, 0, 304, 608, DATE '2005-01-01', '', '/book-service/book-covers/default-book-cover.svg', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Claus Pias') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Computer Science' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Zukünfte des Computers')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('John Ruskin') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), '"Unto this Last"', 0, 0, 0, 88, 176, DATE '1870-12-31', '', 'https://books.google.com/books/content?id=n2guuQo7JSUC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('John Ruskin') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('"Unto this Last"')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Karl Marx') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'A Contribution to the Critique of Political Economy', 0, 0, 0, 322, 644, DATE '1904-01-01', '', 'https://books.google.com/books/content?id=YUFmdGoHfQEC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Karl Marx') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('A Contribution to the Critique of Political Economy')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Jean Baptiste Say') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'A Treatise on Political Economy', 0, 0, 0, 502, 1004, DATE '1863-01-01', '', 'https://books.google.com/books/content?id=i-w9AQAAMAAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Jean Baptiste Say') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('A Treatise on Political Economy')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Murray Milgate') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'After Adam Smith', 0, 0, 0, 319, 638, DATE '2011-09-26', 'How writers after Adam Smith helped shape our thinking about economics and politics Few issues are more central to our present predicaments than the relationship between economics and politics. In the century after Adam Smith''s Wealth of Nations the British economy was transformed. After Adam Smith looks at how politics and political economy were articulated and altered. It considers how grand ideas about the connections between individual liberty, free markets, and social and economic justice sometimes attributed to Smith are as much the product of gradual modifications and changes wrought by later writers. Thomas Robert Malthus, David Ricardo, James Mill, John Stuart Mill, and other liberals, radicals, and reformers had a hand in conceptual transformations that culminated in the advent of neoclassical economics. The population problem, the declining importance of agriculture, the consequences of industrialization, the structural characteristics of civil society, the role of the state in economic affairs, and the possible limits to progress were questions that underwent significant readjustments as the thinkers who confronted them in different times and circumstances reworked the framework of ideas advanced by Smith—transforming the dialogue between politics and political economy. By the end of the nineteenth century an industrialized and globalized market economy had firmly established itself. By exploring how questions Smith had originally grappled with were recast as the economy and the principles of political economy altered during the nineteenth century, this book demonstrates that we are as much the heirs of later images of Smith as we are of Smith himself. Many writers helped shape different ways of thinking about economics and politics after Adam Smith. By ignoring their interventions we risk misreading our past—and also misusing it—when thinking about the choices at the interface of economics and politics that confront us today.', 'https://books.google.com/books/content?id=tVrhkQPtOPQC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Murray Milgate') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('After Adam Smith')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Adam Smith') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'An Inquiry Into the Nature and Causes of the Wealth of Nations', 0, 0, 0, 749, 1498, DATE '1930-01-01', 'An inquiry into the nature and causes of the wealth of nations; with a life of the author, an introductory discourse, notes, and supplemental dissertations.', 'https://books.google.com/books/content?id=ResOAwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Adam Smith') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('An Inquiry Into the Nature and Causes of the Wealth of Nations')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Damodar N. Gujarati') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Essentials of Econometrics', 0, 0, 0, 633, 1266, DATE '2021-08-06', 'Logically organized and accessible, this updated Fifth Edition of Gujarati′s classic text provides students with an overview of the basics of econometric theory from ordinal logistic regression to time series.', 'https://books.google.com/books/content?id=cG0rEAAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Damodar N. Gujarati') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Essentials of Econometrics')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Joseph A. Schumpeter') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'History of Economic Analysis', 0, 3, 1, 1310, 2620, DATE '2006-03-07', 'At the time of his death in 1950, Joseph Schumpeter was working on his monumental History of Economic Analysis. Unprecedented in scope, the book was to provide a complete history of economic theory from Ancient Greece to the end of the second world war. A major contribution to the history of ideas as well as to economics, History of Economic Analysis rapidly gained a reputation as a unique and classic work. As well being an economist, Schumpeter was a gifted mathematician, historian, philosopher and psychologist and this is reflected in the multi-disciplinary nature of his great endeavour. Topics addressed include the techniques of economic analysis, contemporaneous developments in other sciences and the sociology of economics. This inclusiveness extends to the periods and individuals who figure in the book. As well as dealing with all of the major economists from Adam Smith to Maynard Keynes, the book considers the economic writings of Plato and Aristotle, of the Medieval Scholastics and of the major European economists. Throughout, Schumpeter perceived economics as a human science and this is reflected in a volume which is lucid and insightful throughout.', 'https://books.google.com/books/content?id=pl4DABZfGREC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Joseph A. Schumpeter') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('History of Economic Analysis')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Amartya Sen') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Inequality Reexamined', 0, 0, 0, 222, 444, DATE '1992-01-01', 'This book develops some of the most important themes of Sen''s works over the last decade. He argues in a rich and subtle approach that we should be concerned with people''s capabilities rather than their resources or welfare.', 'https://books.google.com/books/content?id=LOLnCwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Amartya Sen') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Inequality Reexamined')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Muhammad Umer Chapra') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Islam and the Economic Challenge', 0, 0, 0, 91, 182, DATE '1992-01-01', 'This book combines Qur''anic wisdom and modern economics to provide a clear, integrated picture of what Islamic economics has to offer to realize the kind of well-being Islam envisages. M. Umer Chapra is ranked amongst the Top 50 Global Leaders in Islamic economics (ISLAMICA 500, 2015) and has been awarded with two prestigious awards for his contributions to the field: Islamic Development Bank Award for Islamic Economics (1989) and the King Faisal International Prize for Islamic Studies (1989).', 'https://books.google.com/books/content?id=H_s9CgAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Muhammad Umer Chapra') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Islam and the Economic Challenge')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Slavoj Žižek') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Living in the End Times', 0, 0, 0, 522, 1044, DATE '2011-04-18', 'Economics.', 'https://books.google.com/books/content?id=MIz6BPT23Q4C&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Slavoj Žižek') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Living in the End Times')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Alfred Marshall') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Principles of economics', 0, 0, 0, 742, 1484, DATE '2009-01-01', 'British economist ALFRED MARSHALL (1842-1924) was one of the most prominent thinkers of his age on the philosophy of finance, and this, considered his greatest work, was for years the standard text on the subject. First published in 1890, it serves as an excellent primer on such topics as: [ basic economic laws [ the purpose of economic studies [ fundamental concepts including wealth, production, consumption, labor, income, capital, and others [ understanding consumer demand [ an introduction to market studies [ and much more. This replica of the 1920 eighth edition is completely unabridged, and features the vital Mathematical Appendix, including all of Marshall''s equations and diagrams.', 'https://books.google.com/books/content?id=IyZJXc_v-TAC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Alfred Marshall') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Principles of economics')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Ernst Friedrich Schumacher') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Small is Beautiful', 0, 0, 0, 296, 592, DATE '1973-01-01', '', 'https://books.google.com/books/content?id=Ti25AAAAIAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Ernst Friedrich Schumacher') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Small is Beautiful')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Knud Haakonssen') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Cambridge Companion to Adam Smith', 0, 0, 0, 100, 200, DATE '2005-01-01', '', '/book-service/book-covers/default-book-cover.svg', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Knud Haakonssen') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Cambridge Companion to Adam Smith')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Karl Marx') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Poverty of Philosophy', 0, 0, 0, 230, 460, DATE '2008-01-01', 'Written in the winter of 1846-7 as a response to Proudhon''s Système des Contradictions Economique ou Philosophie de la Misère, this is essential background for appreciating Marx''s later work, including Capital and his Communist Manifesto. Here, Marx begins to explore such concepts as constituted or synthetic value, the division of labor and machinery, competition and monopoly, strikes and the combination of workmen, and free trade, all of which would later come to play important roles in his social and political philosophy. Anyone wishing to understand Marx''s approach to capitalism as an oppressor of the proletariat and as a movement destined to collapse must consider this required reading. Prussian philosopher KARL MARX (1818-1883) was a social scientist, historian, and political revolutionary. He is indisputably the most influential socialist thinker to emerge in the 19th century. Although scholars largely ignored him in his own lifetime, his social, economic, and political ideas gained rapid acceptance in the socialist movement after his death.', 'https://books.google.com/books/content?id=p7JcSq-vR8oC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Karl Marx') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Poverty of Philosophy')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('David Ricardo') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Principles of Political Economy and Taxation', 0, 0, 0, 336, 672, DATE '2002-01-01', 'This landmark treatise of 1817 formulated the guiding principles behind the market economy. Author Ricardo, with Adam Smith, founded the classical system of political economy, a school of thought that dominated economic policies throughout the 19th century and figured prominently in the theories of John Stuart Mill and Karl Marx.', 'https://books.google.com/books/content?id=qOTMVsADQqEC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('David Ricardo') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Principles of Political Economy and Taxation')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Friedrich August Hayek') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Road to Serfdom', 0, 0, 0, 100, 200, DATE '2007-03-30', 'An unimpeachable classic work in political philosophy, intellectual and cultural history, and economics, The Road to Serfdom has inspired and infuriated politicians, scholars, and general readers for half a century. Originally published in 1944—when Eleanor Roosevelt supported the efforts of Stalin, and Albert Einstein subscribed lock, stock, and barrel to the socialist program—The Road to Serfdom was seen as heretical for its passionate warning against the dangers of state control over the means of production. For F. A. Hayek, the collectivist idea of empowering government with increasing economic control would lead not to a utopia but to the horrors of Nazi Germany and Fascist Italy. First published by the University of Chicago Press on September 18, 1944, The Road to Serfdom garnered immediate, widespread attention. The first printing of 2,000 copies was exhausted instantly, and within six months more than 30,000 books were sold. In April 1945, Reader’s Digest published a condensed version of the book, and soon thereafter the Book-of-the-Month Club distributed this edition to more than 600,000 readers. A perennial best seller, the book has sold 400,000 copies in the United States alone and has been translated into more than twenty languages, along the way becoming one of the most important and influential books of the century. With this new edition, The Road to Serfdom takes its place in the series The Collected Works of F. A. Hayek. The volume includes a foreword by series editor and leading Hayek scholar Bruce Caldwell explaining the book''s origins and publishing history and assessing common misinterpretations of Hayek''s thought. Caldwell has also standardized and corrected Hayek''s references and added helpful new explanatory notes. Supplemented with an appendix of related materials ranging from prepublication reports on the initial manuscript to forewords to earlier editions by John Chamberlain, Milton Friedman, and Hayek himself, this new edition of The Road to Serfdom will be the definitive version of Friedrich Hayek''s enduring masterwork.', '/book-service/book-covers/default-book-cover.svg', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Friedrich August Hayek') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Road to Serfdom')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Richard H. Thaler') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Winner''s Curse', 0, 0, 0, 248, 496, DATE '1992-01-01', 'The rationale of economics has come to dominate political and institutional life in recent years. However, many economic assumptions have received only scant study. This book examines the many anomalies that abound in even simple economic transactions.', 'https://books.google.com/books/content?id=5AsPAQAAMAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Richard H. Thaler') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Winner''s Curse')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Karl Marx') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Value, price & profit', 0, 0, 0, 62, 124, DATE '1908-01-01', '', 'https://books.google.com/books/content?id=eVsaaaBgg0oC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Karl Marx') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Economics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Value, price & profit')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Ursula K. Le Guin') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'A Wizard of Earthsea', 0, 1, 1, 189, 378, DATE '2015-04-27', '''Drink this magic up. Drown in it. Dream it'' David Mitchell Ged, the greatest sorcerer in all Earthsea, was called Sparrowhawk in his reckless youth. Hungry for power and knowledge, Sparrowhawk tampered with long-held secrets and loosed a terrible shadow upon the world. This is the tale of his testing, how he mastered the mighty words of power, tamed an ancient dragon, and crossed death''s threshold to restore the balance. ''The Earthsea trilogy . . . is a memorable exploration of the relationship between life and death. . . Ged, its hero, must face his shadow self before it devours him. Only then will he become whole. In the process, he must contend with the wisdom of dragons: ambiguous and not our wisdom, but wisdom nonetheless'' Magaret Atwood', 'https://books.google.com/books/content?id=XOjkBwAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Ursula K. Le Guin') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('A Wizard of Earthsea')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Ursula K. Le Guin') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Gifts', 0, 3, 1, 274, 548, DATE '2004-01-01', 'Orrec is the son of the Brantor of Caspromant; Gry the daughter of the Brantors of Barre and Rodd. They have grown up together in neighbouring domains, running half-wild across the Uplands. The people of the domains are like their land: harsh and fierce and prideful; ever at war with each other, raiding cattle, capturing serfs, enlarging their holdings. It is only the gifts that keep a fragile peace. The gifts are powers, running from father to son and from mother to daughter. The Barre gift is calling animals. The women of Cordemant have the power of blinding, or making deaf, or taking away speech. The Rodds can send a spellknife into a man''s heart, or cut his throat, or maim as they please, if he''s in sight. The Callems can move heavy things by word and gesture - even buildings, even hills. And Brantor Ogge of Drummant has the gift of slow wasting. The Caspro gift is the worst and best of all: it is the gift of undoing: an insect, an animal, a place . . . Orrec and Gry are the heirs to Caspro and Barre. Gry''s gift runs true, but unlike her mother, she will not use it to call animals for the hunt. Orrec too is a problem, for his gift of undoing is wild: he cannot control it - and that is the most dangerous gift of all . . . GIFTS is Ursula Le Guin at her best: an exciting, moving story beautifully told.', 'https://books.google.com/books/content?id=S1CcHAAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Ursula K. Le Guin') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Gifts')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('J. K. Rowling') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Harry Potter y la piedra filosofal', 0, 4, 3, 264, 528, DATE '2001-01-01', 'Rescatado del descuido de su tia y tio, un huerfano con un gran destino matricula en la escuela Hogwarts para Magos y Brujas.', 'https://books.google.com/books/content?id=4RENAQAAMAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('J. K. Rowling') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Harry Potter y la piedra filosofal')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('James Matthew Barrie') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Peter and Wendy', 0, 4.5, 13, 330, 660, DATE '1911-01-01', 'The adventures of Peter Pan, the boy who would not grow up.', 'https://books.google.com/books/content?id=9YEOAAAAIAAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('James Matthew Barrie') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Peter and Wendy')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('James Matthew Barrie') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Peter Pan', 0, 4, 10, 228, 456, DATE '2002-01-29', 'The timeless classic about lost boys and found dreams, clerverly introduced by Newbery Honor author Jack Gantos. Second to the right and straight on til morning - that''s the way to Neverland, an island filled with adventure and hidden danger. It''s home to beautiful mermaids and fairies...as well as dastardly pirates ruled by the evil Captain Hook. It''s a place for lost boys, hungry crocodiles, and, most of all, people who don''t want to grow up. The Darling children don''t know anything about Neverland - until a magical boy named Peter Pan shows up and leads the way.', 'https://books.google.com/books/content?id=jMkBN8SNLsMC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('James Matthew Barrie') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Peter Pan')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Clive Staples Lewis') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Prince Caspian', 0, 0, 0, 242, 484, DATE '2008-01-01', 'The Chronicles of Narnia return to the silver screen in May 2008 with the eagerly awaited Prince Caspian', 'https://books.google.com/books/content?id=-f827ZLYjKwC&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Clive Staples Lewis') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Prince Caspian')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Ursula K. Le Guin') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Tales from Earthsea', 0, 0, 0, 417, 834, DATE '2012-01-01', 'An exciting re-launch of the classic Earthsea Cycle, by fantasy literature legend Ursula K. Le Guin, winner of a Newbery Honor, the National Book Award, Pushcart Prize, and six Nebula Awards.', 'https://books.google.com/books/content?id=ueRzTEnB96wC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Ursula K. Le Guin') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Tales from Earthsea')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Astrid Lindgren') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Brothers Lionheart', 0, 0, 0, 100, 200, DATE '2004-01-01', 'Two brothers share many adventures after their death when they are reunited in Nangiyala, the land from which sagas come.', 'https://books.google.com/books/content?id=z2QJAAAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Astrid Lindgren') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Brothers Lionheart')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('John Ronald Reuel Tolkien') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Fellowship of the Ring', 0, 0, 0, 423, 846, DATE '1971-01-01', '', '/book-service/book-covers/default-book-cover.svg', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('John Ronald Reuel Tolkien') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Fellowship of the Ring')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('John Ronald Reuel Tolkien') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Hobbit, Or, There and Back Again', 0, 4.5, 5, 300, 600, DATE '1937-01-01', 'Bilbo Baggins, a respectable, well-to-do hobbit, lives comfortably in his hobbit-hole until the day the wandering wizard Gandalf chooses him to take part in an adventure from which he may never return.', 'https://books.google.com/books/content?id=A4mXQwAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('John Ronald Reuel Tolkien') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Hobbit, Or, There and Back Again')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Clive Staples Lewis') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Lion, the Witch and the Wardrobe', 0, 0, 0, 100, 200, DATE '2009-01-01', 'Four English schoolchildren find their way through the back of a wardrobe into the magic land of Narnia and assist Aslan, the golden lion, to triumph over the White Witch, who has cursed the land with eternal winter.', 'https://books.google.com/books/content?id=HXKLwgEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Clive Staples Lewis') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Lion, the Witch and the Wardrobe')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('j.r.r. tolkien') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Lord of the Rings', 0, 4.5, 61, 1267, 2534, DATE '2012-02-15', 'Immerse yourself in Middle-earth with J.R.R. Tolkien’s classic masterpieces behind the films... This special 50th anniversary edition includes three volumes of The Lord of the Rings (The Fellowship of the Ring, The Two Towers, and The Return of the King), along with an extensive new index—a must-own tome for old and new Tolkien readers alike. One Ring to rule them all, One Ring to find them, One Ring to bring them all and in the darkness bind them. In ancient times the Rings of Power were crafted by the Elven-smiths, and Sauron, the Dark Lord, forged the One Ring, filling it with his own power so that he could rule all others. But the One Ring was taken from him, and though he sought it throughout Middle-earth, it remained lost to him. After many ages it fell by chance into the hands of the hobbit Bilbo Baggins. From Sauron''s fastness in the Dark Tower of Mordor, his power spread far and wide. Sauron gathered all the Great Rings to him, but always he searched for the One Ring that would complete his dominion. When Bilbo reached his eleventy-first birthday he disappeared, bequeathing to his young cousin Frodo the Ruling Ring and a perilous quest: to journey across Middle-earth, deep into the shadow of the Dark Lord, and destroy the Ring by casting it into the Cracks of Doom. The Lord of the Rings tells of the great quest undertaken by Frodo and the Fellowship of the Ring: Gandalf the Wizard; the hobbits Merry, Pippin, and Sam; Gimli the Dwarf; Legolas the Elf; Boromir of Gondor; and a tall, mysterious stranger called Strider. J.R.R. Tolkien (1892-1973), beloved throughout the world as the creator of The Hobbit, The Lord of the Rings, and The Silmarillion, was a professor of Anglo-Saxon at Oxford, a fellow of Pembroke College, and a fellow of Merton College until his retirement in 1959. His chief interest was the linguistic aspects of the early English written tradition, but while he studied classic works of the past, he was creating a set of his own.', 'https://books.google.com/books/content?id=yl4dILkcqm4C&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('j.r.r. tolkien') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Lord of the Rings')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Slavoj Žižek') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Plague of Fantasies', 0, 0, 0, 400, 800, DATE '2020-05-05', 'Modern audiovisual media have spawned a ''plague of fantasies'', electronically inspired phantasms that cloud the ability to reason and prevent a true understanding of a world increasingly dominated by abstractions-whether those of digital technology or the speculative market. Into this arena, enters Zizek: equipped with an agile wit and the skills of a prodigious scholar, he confidently ranges among a dazzling array of cultural references-explicating Robert Schumann as deftly as he does John Carpenter-to demonstrate how the modern condition blinds us to the ideological basis of our lives.', 'https://books.google.com/books/content?id=F1ycEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Slavoj Žižek') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Plague of Fantasies')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Clive Staples Lewis') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Silver Chair', 0, 0, 0, 100, 200, DATE '1987-01-01', 'Two English children undergo hair-raising adventures as they go on a search and rescue mission for the missing Prince Rilian, who is held captive in the underground kingdom of the Emerald Witch.', 'https://books.google.com/books/content?id=2rW70AEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Clive Staples Lewis') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Silver Chair')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Charles Kingsley') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Water Babies', 0, 0, 0, 163, 326, DATE '2013-04-16', 'DIVA young, ill-treated chimney sweep enters a magical waterworld where he meets creatures that teach him the difference between right and wrong. 32 illustrations. /div', 'https://books.google.com/books/content?id=kLTCAgAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Charles Kingsley') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Water Babies')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Kenneth Grahame') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Wind in the Willows', 0, 0, 0, 32, 64, DATE '2017-11-07', 'The escapades of four animal friends who live along a river in the English countryside--Toad, Mole, Rat, and Badger.', 'https://books.google.com/books/content?id=FUE9DwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Kenneth Grahame') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Wind in the Willows')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Lyman Frank Baum') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Wonderful Wizard of Oz', 0, 0, 0, 226, 452, DATE '1999-01-01', 'The Wonderful Wizard of Oz remains one of the world''s most beloved and widely read books. Throughout a century of remarkable change, the popularity of L. Frank Baum''s classic tale has endured and grown, embraced by generation after generation of children and the young at heart. To honour the centennial of its publication in 1900, the University Press of Kansas is presenting this special anniversary edition that combines Baum''s original text with the contributions of two renowned artists: book illustrator Michael McCurdy and writer Ray Bradbury. The book embraces and celebrates the oft-kidded connection between Baum''s wondrous story and the state of Kansas.', 'https://books.google.com/books/content?id=yT9aAAAAMAAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Lyman Frank Baum') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fantasy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Wonderful Wizard of Oz')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('James Joyce') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'A Portrait of the Artist as a Young Man', 0, 3.5, 3, 276, 552, DATE '1992-01-01', '"James Joyce''s A Portrait of the Artist as a Young Man (1916) is one of the twentieth century''s great coming-of-age novels. This Norton Critical Edition is based on Hans Walter Gabler''s acclaimed text and is accompanied by his introduction and textual notes. John Paul Riquelme provides explanatory notes to deepen the reader''s appreciation for Joyce''s masterpiece." ""Backgrounds and Contexts" is topically organized: "Political Nationalism: Irish History, 1798-1916," "The Irish Literary and Cultural Revival," "Religion," and "Aesthetic Backgrounds." Fourteen illustrations accompany the documents." ""Criticism" begins with John Paul Riquelme''s overview of A Portrait of the Artist as a Young Man''s structure. Twelve diverse interpretations of his work follow, by Kenneth Burke, Umberto Eco, Hugh Kenner, Helene Cixous, John Paul Riquelme, Karen Lawrence, Maud Ellmann, Bonnie Kime Scott, Joseph Valente, Marian Eide, Pericles Lewis, adn Jonathan Mulrooney. A Selected Bibliography is also included."--BOOK JACKET.', 'https://books.google.com/books/content?id=C_rPXanc_HAC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('James Joyce') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('A Portrait of the Artist as a Young Man')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Henry M. Stanley') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'How I Found Livingstone', 0, 0, 0, 814, 1628, DATE '2023-03-07', 'Reprint of the original, first published in 1872. The publishing house Anatiposi publishes historical books as reprints. Due to their age, these books may have missing pages or inferior quality. Our aim is to preserve these books and make them available to the public so that they do not get lost.', 'https://books.google.com/books/content?id=C32yEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Henry M. Stanley') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('How I Found Livingstone')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Jules Verne') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Journey to the Center of the Earth', 0, 0, 0, 402, 804, DATE '2019-06-15', 'Journey to the Interior of the Earth is a classic science fiction novel by Jules Verne. The story involves German professor Otto Lidenbrock who believes there are volcanic tubes going toward the centre of the Earth. He, his nephew Axel, and their guide Hans descend into the Icelandic volcano Snæfellsjökull, encountering many adventures, including prehistoric animals and natural hazards, before eventually coming to the surface again in southern Italy, at the Stromboli volcano. The story begins in the Lidenbrock house in Hamburg, Germany, with Professor Lidenbrock rushing home to peruse his latest purchase, an original runic manuscript of an Icelandic saga written by Snorri Sturluson ("Heimskringla"; the chronicle of the Norwegian kings who ruled over Iceland). While looking through the book, Lidenbrock and his nephew Axel find a coded note written in runic script. (This is a first indication of Verne''s love for cryptology. Coded, cryptic or incomplete messages as a plot device will continue to appear in many of his works and in each case Verne goes a long way to explain not only the code used but also the mechanisms used to retrieve the original text.) Lidenbrock and Axel transliterate the runic characters into Latin letters, revealing a message written in a seemingly bizarre code. Lidenbrock attempts a decipherment, deducing the message to be a kind of transposition cipher; but his results are as meaningless as the original. Professor Lidenbrock decides to lock everyone in the house and force himself and the others (Axel, and the maid, Martha) to go without food until he cracks the code. Axel discovers the answer when fanning himself with the deciphered text: Lidenbrock''s decipherment was correct, and only needs to be read backwards to reveal sentences written in rough Latin. Axel decides to keep the secret hidden from Professor Lidenbrock, afraid of what the Professor might do with the knowledge, but after two days without food he cannot stand the hunger and reveals the secret to his uncle. Lidenbrock translates the note, which is revealed to be a medieval note written by the (fictional) Icelandic alchemist Arne Saknussemm, who claims to have discovered a passage to the center of the Earth via Snæfell in Iceland.', 'https://books.google.com/books/content?id=Y7mzAwAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Jules Verne') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Journey to the Center of the Earth')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Lafcadio Hearn') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Kokoro', 0, 0, 0, 221, 442, DATE '2016-03-17', 'A Story with Heart. “We owe more to our illusions than to our knowledge” - Natusme, Kokoro A collection of 15 essays that examine the inner spiritual life of Japan through the people that make Japan the unique place it is. This Xist Classics edition has been professionally formatted for e-readers with a linked table of contents. This eBook also contains a bonus book club leadership guide and discussion questions. We hope you’ll share this book with your friends, neighbors and colleagues and can’t wait to hear what you have to say about it. Xist Publishing is a digital-first publisher. Xist Publishing creates books for the touchscreen generation and is dedicated to helping everyone develop a lifetime love of reading, no matter what form it takes', 'https://books.google.com/books/content?id=JPfzCwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Lafcadio Hearn') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Kokoro')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Virginia Woolf') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Mrs. Dalloway', 0, 0, 0, 199, 398, DATE '2021-01-01', 'Mrs. Dalloway is Virginia Woolf’s best known novel. This landmark novel is a masterpiece. While the book seems to take place in a single day in the life of the eponymous Mrs. Dalloway, it is much more. Mrs. Dalloway is preparing for a dinner party to be held that evening. As she goes about her day, her mind wanders to the people who will be attending her party and her relationship with them. Her husband, Richard Dalloway; Peter Walsh, a man she might have married instead; Sally Seton, a woman with whom she shared a forbidden kiss; Septimus Warren Smith, a man slowly sinking into madness. The narrative focus shifts back and forth from Mrs. Dalloway to the characters who will be attending her dinner party in a groundbreaking stream of consciousness. The dinner party, like the novel, is a success.', 'https://books.google.com/books/content?id=gIqcEQAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Virginia Woolf') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Mrs. Dalloway')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Knut Hamsun') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Mysteries', 0, 0, 0, 100, 200, DATE '2001-01-01', 'The first complete English translation of the Nobel Prize-winner’s literary masterpiece A Penguin Classic Mysteries is the story of Johan Nilsen Nagel, a mysterious stranger who suddenly turns up in a small Norwegian town one summer—and just as suddenly disappears. Nagel is a complete outsider, a sort of modern Christ treated in a spirit of near parody. He condemns the politics and thought of the age, brings comfort to the “insulted and injured,” and gains the love of two women suggestive of the biblical Mary and Martha. But there is a sinister side of him: in his vest he carries a vial of prussic acid... The novel creates a powerful sense of Nagel''s stream of thought, as he increasingly withdraws into the torture chamber of his own subconscious psyche. For more than seventy years, Penguin has been the leading publisher of classic literature in the English-speaking world. With more than 1,800 titles, Penguin Classics represents a global bookshelf of the best works throughout history and across genres and disciplines. Readers trust the series to provide authoritative texts enhanced by introductions and notes by distinguished scholars and contemporary authors, as well as up-to-date translations by award-winning translators.', 'https://books.google.com/books/content?id=HYmMEAAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Knut Hamsun') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Mysteries')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Charles Dickens') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Oliver Twist', 0, 4, 1, 534, 1068, DATE '2015-01-01', 'Raised in a workhouse for orphans, Oliver Twist runs away to London, where he discovers the city''s seedy underbelly. While making friends and enemies in high and low places, Oliver tries to avoid a life of destitution and crime.', 'https://books.google.com/books/content?id=CjJTBgAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Charles Dickens') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Oliver Twist')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Jack Kerouac') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'On The Road', 0, 0, 0, 337, 674, DATE '2000-01-01', 'Fictionalized narrative of travels by Kerouac and his friend Neal Cassady under pseudonyms of Sal Paradise and Dean Moriarty.', 'https://books.google.com/books/content?id=DXrPTHXZ4FwC&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Jack Kerouac') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('On The Road')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Hermann Hesse') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Peter Camenzind', 0, 0, 0, 133, 266, DATE '2013-12-11', 'Dieser in unmittelbarer Nachfolge von Gottfried Kellers Der grüne Heinrich stehende »Erziehungsroman« hat mit seinen erfrischenden, allem Pathetischen abholden Naturschilderungen bis heute nichts an Charme und Farbe verloren.', 'https://books.google.com/books/content?id=B8g7CgAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Hermann Hesse') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Peter Camenzind')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Daniel Defoe') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Robinson Crusoe', 0, 0, 0, 241, 482, DATE '2012-04-10', 'The only survivor of a shipwreck endures 28 years of solitude on a Caribbean island and masters both his strange new world and himself. Brilliant, evocative details of Crusoe''s struggles and exploits.', 'https://books.google.com/books/content?id=WT_CAgAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Daniel Defoe') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Robinson Crusoe')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Jane Austen') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Sense and Sensibility - Illustrated Edition', 0, 0, 0, 418, 836, DATE '2021-05-04', 'Sense and Sensibility is a novel by Jane Austen, published in 1811. It was published anonymously; By A Lady appears on the title page where the author''s name might have been. It tells the story of the Dashwood sisters, Elinor and Marianne as they come of age.', 'https://books.google.com/books/content?id=rrprzgEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Jane Austen') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Sense and Sensibility - Illustrated Edition')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Thomas Hardy') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Tess of the D''Urbervilles', 0, 5, 2, 572, 1144, DATE '2003-01-01', 'Tess of the D''Urbervilles is probably Thomas Hardy''s most famous novel. Set in the West of England, in a beautifully described rural landscape, it tells the tragic story of Tess Durbeyfield, an innocent village girl who is seduced by a wealthy rake, Alec D''Urberville. Because she does not love him, she does not even attempt to make him marry her, but returns to her home village pregnant and disgraced in the eyes of the local community. The baby dies in infancy, and after regaining her emotional strength, Tess goes to work as a milkmaid in a different valley. Here she meets the true love of her life, Angel Clare, but even though he loves her too, they are unable to escape from the consequences of her past. One of the great Classics of Nineteenth Century literature, Tess of the D''Urbervilles recounts an unforgettably powerful tragedy.', 'https://books.google.com/books/content?id=UehmCj5rekMC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Thomas Hardy') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Tess of the D''Urbervilles')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Clive Staples Lewis') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'That Hideous Strength', 0, 0, 0, 492, 984, DATE '1960-01-01', '', 'https://books.google.com/books/content?id=MEcqAQAAIAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Clive Staples Lewis') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('That Hideous Strength')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Arthur Conan Doyle') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Final Problem', 0, 0, 0, 39, 78, DATE '2025-03-08', 'In "The Final Problem", Sherlock Holmes finds himself locked in a dangerous battle of wits against Professor Moriarty, the mastermind behind London''s criminal underworld. Aware of the growing threat, Holmes and Watson flee to Switzerland in an attempt to evade Moriarty''s reach. As the pursuit intensifies, Holmes devises a plan to end Moriarty''s influence once and for all, leading to a fateful confrontation at the Reichenbach Falls.', 'https://books.google.com/books/content?id=XUtNEQAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Arthur Conan Doyle') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Final Problem')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Oscar Wilde') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Picture of Dorian Gray', 0, 0, 0, 354, 708, DATE '1998-06-01', 'Introduction by Jeffrey Eugenides • Nominated as one of America’s best-loved novels by PBS’s The Great American Read Written in his distinctively dazzling manner, Oscar Wilde’s story of a fashionable young man who sells his soul for eternal youth and beauty is the author’s most popular work. The tale of Dorian Gray’s moral disintegration caused a scandal when it first appeared in 1890, but though Wilde was attacked for the novel’s corrupting influence, he responded that there is, in fact, “a terrible moral in Dorian Gray.” Just a few years later, the book and the aesthetic/moral dilemma it presented became issues in the trials occasioned by Wilde’s homosexual liaisons, which resulted in his imprisonment. Of Dorian Gray’s relationship to autobiography, Wilde noted in a letter, “Basil Hallward is what I think I am: Lord Henry what the world thinks me: Dorian what I would like to be—in other ages, perhaps.”', 'https://books.google.com/books/content?id=CudBasI0BA0C&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Oscar Wilde') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Picture of Dorian Gray')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Albert Camus') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Plague', 0, 0, 0, 296, 592, DATE '1948-01-01', 'Chaos prevails when the bubonic plague strikes the Algerian coastal city of Oran.', 'https://books.google.com/books/content?id=65lcAAAAMAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Albert Camus') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Plague')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Bruno Schulz') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Street of Crocodiles', 0, 0, 0, 166, 332, DATE '1977-01-01', '"The Street of Crocodiles in the Polish city of Drogobych is a street of memories and dreams where recollections of Bruno Schulz''s uncommon boyhood and of the eerie side of his merchant family''s life are evoked in a startling blend of the real and the fantastic"--Back cover.', 'https://books.google.com/books/content?id=ZnpjAAAAMAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Bruno Schulz') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Street of Crocodiles')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Lee Child') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Visitor', 0, 0, 0, 380, 760, DATE '2000-01-01', 'Sergeant Amy Callan and Lieutenant Caroline Cook had a lot in common. Both high flying army women, both victims of sexual harassment, they left the army under dubious circumstances. Both are now dead their bodies discovered unmarked and unscarred in their own homes. Jack Reacher, former US military policeman, loner and drifter knew them both. Follows Tripwire.', 'https://books.google.com/books/content?id=_B_QQQAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Lee Child') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Visitor')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Jessica Townsend') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Wundersmith', 0, 0, 0, 511, 1022, DATE '2018-01-01', 'Return to the magical world of Nevermoor, where Morrigan Crow''s adventures continue. Morrigan may have defeated her deadly curse, passed the dangerous trials and joined the mystical Wundrous Society, but her journey into Nevermoor and all its secrets has only just begun.', 'https://books.google.com/books/content?id=PiezzQEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Jessica Townsend') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Wundersmith')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Richard Clogg') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'A Concise History of Greece', 0, 0, 0, 369, 738, DATE '2021-03-25', 'The fourth edition of Richard Clogg''s classic account of Greek history from independence in 1830 to the present day.', 'https://books.google.com/books/content?id=KQIbEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Richard Clogg') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('A Concise History of Greece')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Muḥammad ibn Aḥmad Bīrūnī') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Alberuni''s India', 0, 0, 0, 448, 896, DATE '1910-01-01', 'First Published in 2000. Routledge is an imprint of Taylor & Francis, an informa company.', 'https://books.google.com/books/content?id=WUzYgY9ni84C&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Muḥammad ibn Aḥmad Bīrūnī') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Alberuni''s India')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Ross Burns') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Damascus', 0, 0, 0, 386, 772, DATE '2005-01-01', 'This is the first book in English to relate the history of Damascus, bringing out the crucial role the city has played at many points in the region''s past. Damascus traces the history of this colourful, significant and complex city through its physical development, from the city''s emergence in around 7000 BC through the changing cavalcade of Aramaean, Persian, Greek, Roman, Byzantine, Arab, Mongol and French rulers right up to the end of Turkish control in 1918. In Damascus, every layer of the history has built precisely on top of its predecessors for at least three millennia, leaving a detailed archaeological record of one of the oldest continuously inhabited cities in the world. The book looks particularly at the interplay between the western and eastern influences that have provided Damascus with such a rich past, and how this perfectly encapsulates the forces that have played over the Middle East as a whole from the earliest recorded times to the present. Lavishly illustrated, Damascus: A History is a compelling and unique exploration of a fascinating city.', 'https://books.google.com/books/content?id=xTs77Ft6FXQC&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Ross Burns') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Damascus')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Sigmund Freud') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Delusion and Dream: An Interpretation in the Light of Psychoanalysis of Gradiva', 0, 0, 0, 212, 424, DATE '2020-09-28', 'In a circle of men who take it for granted that the basic riddle of the dream has been solved by the efforts of the present writer''s curiosity was aroused one day concerning those dreams which have never been dreamed, those created by authors, and attributed to fictitious characters in their productions. The proposal to submit this kind of dream to investigation might appear idle and strange; but from one view-point it could be considered justifiable. It is, to be sure, not at all generally believed that the dreamer dreams something senseful and significant. Science and the majority of educated people smile when one offers them the task of interpreting dreams. Only people still clinging to superstition, who give continuity, thereby, to the convictions of the ancients, will not refrain from interpreting dreams, and the writer of Traumdeutung has dared, against the protests of orthodox science, to take sides with the ancients and superstitious. He is, of course, far from accepting in dreams a prevision of the future, for the disclosure of which man has, from time immemorial, striven vainly. He could not, however, completely reject the connections of dreams with the future, for, after completing some arduous analysis, the dreams seemed to him to represent the fulfilment of a wish of the dreamer; and who could dispute that wishes are preponderantly concerned with the future? I have just said that the dream is a fulfilled wish. Whoever is not afraid to toil through a difficult book, whoever does not demand that a complicated problem be insincerely and untruthfully presented to him as easy and simple, to save his own effort, may seek in the above-mentioned Traumdeutung ample proof of this statement, and may, until then, cast aside the objection that will surely be expressed against the equivalence of dreams and wish-fulfilment.', 'https://books.google.com/books/content?id=_UugBQAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Sigmund Freud') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Delusion and Dream: An Interpretation in the Light of Psychoanalysis of Gradiva')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Ronald Herbert Sack') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Images of Nebuchadnezzar', 0, 0, 0, 100, 200, DATE '2004-01-01', '', '/book-service/book-covers/default-book-cover.svg', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Ronald Herbert Sack') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Images of Nebuchadnezzar')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Jane Austen') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Jane Austen''s Letters', 0, 0, 0, 695, 1390, DATE '2011-10-20', 'The fourth edition of Jane Austen''s Letters incorporates the findings of new scholarship to enrich our understanding of Austen and give us the fullest view yet of her life and family. The biographical and topographical indexes have been updated, a new subject index has been created, and the contents of the notes added to the general index.', 'https://books.google.com/books/content?id=3gDP8kq561wC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Jane Austen') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Jane Austen''s Letters')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Aristotle') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'METEOROLOGY', 0, 0, 0, 134, 268, DATE '2015-01-01', 'Meteorology is an essential part of the Corpus Aristotelicum and belongs to the section of Physics. The treatise is divided into four books and covers subjects like the four elements, the atmosphere, geology, hydrography and more.', 'https://books.google.com/books/content?id=Yr4vDwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Aristotle') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('METEOROLOGY')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Karl Beckson') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Oscar Wilde', 0, 0, 0, 212, 424, DATE '2011-10-10', 'O Melhor de Oscar Wilde – Karl Beckson “Posso resistir a tudo, menos às tentações” e outras 1.000 frases inesquecíveis... Este livro reúne as melhores frases de Wilde. Naturalmente aforísticas, elas abrangem uma vasta gama de temas e pessoas. Para quase todos os assuntos há um comentário afiado, do prazer (“Prazer é o que recebemos dos outros. Obrigação o que esperamos dos outros. E gênio o que negarmos aos outros”) ao momento da morte (“Estou morrendo como vivi: acima de minhas condições”), passando pela ficção (“Qualquer um pode escrever um romance volumoso. Basta ser completarmente ignorante quanto à vida e à literatura.”).', 'https://books.google.com/books/content?id=D_abF-W2ZbQC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Karl Beckson') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Oscar Wilde')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Geoffrey A. Hosking') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Russia and the Russians', 0, 5, 2, 776, 1552, DATE '2001-01-01', 'Chronicles the history of the Russian Empire from the Mongol Invasion, through the Bolshevik Revolution, to the aftereffects of the Cold War.', 'https://books.google.com/books/content?id=oh-5AAmboMUC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Geoffrey A. Hosking') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Russia and the Russians')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Jean Baudrillard') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Screened Out', 0, 0, 0, 206, 412, DATE '2014-01-07', '''Watching the president''s Christmas message produces this necropolar, white-mass sensation. Seeing the video broadcast of the Christmas service in the cathedral itself, with these pathetic screens and the young worshippers slumped around them here and there, you tell yourself that God and religion deserved better. Deserved to die, yes, but not this. However, watching the presidential figure and his sonorous inanity, you tell yourself that here at least you got what you deserved. Chirac is useless - that goes without saying - but so are we all ... Uselessness of this kind has no origin: it exists immediately, reciprocally; like a shared secret, you savour it implicitly - with its warm bitterness - particularly in these cold snaps, as the very essence of the social bond. Sanctioned by that other interactive uselessness - the uselessness of the screen.'' World-renowned for his lively and often iconoclastic reading of contemporary culture and thought, Jean Baudrillard here turns his hand to topical political debates and issues. In this stimulating collection of journalistic essays Baudrillard addresses subjects ranging from those already established as his trademark (virtual reality, Disney, television) to more unusual topics such as the Western intervention in Bosnia, children''s rights, Holocaust revisionism, AIDS, the Rushdie fatwa, Formula One racing, mad cow disease, genetic cloning, and the uselessness of Chirac. These are coruscating and intriguing articles, not least because they show that Baudrillard is - pace his critics - still susceptible and alert to influences from social movements and the world beyond the hyperreal.', 'https://books.google.com/books/content?id=xmvnDwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Jean Baudrillard') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Screened Out')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Kate Fleet') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Cambridge History of Turkey', 0, 0, 0, 100, 200, DATE '2009-03-12', 'This volume examines the rise of Turkish power in Anatolia from the arrival of the first Turks at the end of the eleventh century to the fall of Constantinople in 1453. Taking the period as a whole, the volume covers the political, economic, social, intellectual and cultural history of the region as the Byzantine empire crumbled and Anatolia passed into Turkish control to become the heartland of the Ottoman empire. In this way, the authors emphasise the continuities of the era rather than its dislocations, situating Anatolia within its geographic context at the crossroads of Central Asia, the Middle East and the Mediterranean. The world which emerges is one of military encounter, but also of cultural cohabitation, intellectual and diplomatic exchange, and political finesse. This is a state-of-the-art work of reference on an understudied period in Turkish history by some of the leading scholars in the field.', 'https://books.google.com/books/content?id=lz1m0QEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Kate Fleet') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Cambridge History of Turkey')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Tsering Shakya') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Dragon in the Land of Snows', 0, 0, 0, 636, 1272, DATE '1999-01-01', 'Based entirely on unpublished primary sources this remarkable book -the first authoritative history of modern Tibet - is also the first to provide detailed accounts of: * The covert political manoeuverings in Tibet and the role of the Tibetan Chinese and British governments; * The Dalai Lama''s escape in 1959; * The CIA''s involvement and the establishment of a secret military base in the Nepalese Himalayas; * The British government lying to the UN and Douglas Hurd''s role in that process; * The power struggles during th Cultural Revolution and the mass uprising against the Chinese that has remained secret until now.', 'https://books.google.com/books/content?id=W-dxAAAAMAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Tsering Shakya') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Dragon in the Land of Snows')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Sumathi Ramaswamy') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Goddess and the Nation', 0, 0, 0, 402, 804, DATE '2010-04-09', 'A history of the role that images of Mother India played in helping a vast, heterogeneous population to imagine the Indian nation and associate themselves with it.', 'https://books.google.com/books/content?id=OWfcoMnHU8gC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Sumathi Ramaswamy') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Goddess and the Nation')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Albert Howe Lybyer') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Government of the Ottoman Empire in the Time of Suleiman the Magnificent', 0, 0, 0, 368, 736, DATE '1913-01-01', 'Excerpt from The Government of the Ottoman Empire, in the Time of Suleiman the Magnificent, Vol. 18 The government OF the mogul empire IN india General Comparison of Ottoman and Indian Conditions The Personnel of the Mogul Government Relation of Government to Religious Propagation. About the Publisher Forgotten Books publishes hundreds of thousands of rare and classic books. Find more at www.forgottenbooks.com This book is a reproduction of an important historical work. Forgotten Books uses state-of-the-art technology to digitally reconstruct the work, preserving the original format whilst repairing imperfections present in the aged copy. In rare cases, an imperfection in the original, such as a blemish or missing page, may be replicated in our edition. We do, however, repair the vast majority of imperfections successfully; any imperfections that remain are intentionally left to preserve the state of such historical works.', 'https://books.google.com/books/content?id=zbsnAAAAYAAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Albert Howe Lybyer') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Government of the Ottoman Empire in the Time of Suleiman the Magnificent')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Jorunn Jacobsen Buckley') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Mandaeans', 0, 0, 0, 217, 434, DATE '2002-01-01', 'The Mandaeans were a gnostic sect that arose in the Middle East around the same time as Christianity. This text examines the lives and religion of contemporary Mandaeans and provides an introduction to the religion, showing how its ancient texts inform the living religion, and vice versa.', 'https://books.google.com/books/content?id=2SjoCwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Jorunn Jacobsen Buckley') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Mandaeans')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Helena Lindholm Schulz') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Palestinian Diaspora', 0, 0, 0, 294, 588, DATE '2005-07-27', 'Schulz examines the ways in which Palestinian identity has been formed in the diaspora through constant longing for a homeland lost. In so doing, the author advances the debate on the relationship between diaspora and the creation of national identity.', 'https://books.google.com/books/content?id=NMaAAgAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Helena Lindholm Schulz') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Palestinian Diaspora')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Kumari Jayawardena') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The White Woman''s Other Burden', 0, 0, 0, 324, 648, DATE '2014-04-23', 'In The White Woman''s Other Burden, Kumari Jayawardena re-evaluates the Western women who lived and worked in South Asia during the period of British rule. She tells the stories of many well-known women, including Katherine Mayo, Helena Blavatsky, Annie Besant, Madeleine Slade, and Mirra Richard and highlights the stories of dozens of women whose names have been forgotten today. In the course of this telling, Jayawardena raises the issues of race, class, and gender which are part of current debates among feminists throughout the world.', 'https://books.google.com/books/content?id=_DNpAwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Kumari Jayawardena') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The White Woman''s Other Burden')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Siyuan Liu') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Transforming Tradition', 0, 0, 0, 473, 946, DATE '2021-07-21', 'Explores the history and lingering effects of governmental reform of Chinese theater, post-1949', 'https://books.google.com/books/content?id=mXAyEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Siyuan Liu') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Transforming Tradition')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Thane Gustafson') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Wheel of Fortune', 0, 0, 0, 673, 1346, DATE '2012-11-06', 'One of the world’s largest exporters of oil faces mounting problems that could send shock waves through every major economy. Gustafson provides an authoritative account of the Russian oil industry from the last years of communism to its uncertain future. The stakes extend beyond global energy security to include the threat of a destabilized Russia.', 'https://books.google.com/books/content?id=0M-jxFR0cpcC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Thane Gustafson') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'History' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Wheel of Fortune')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Stephen King') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Christine', 0, 0, 0, 736, 1472, DATE '2016-05-31', 'Stephen King''s tale of a possessed 1958 Plymouth Fury. Arnie buys an old Plymouth that has mystical powers to possess and destroy. She purrs like a kitten ... but watch out when she roars.', 'https://books.google.com/books/content?id=Has5DAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Stephen King') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Christine')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Stephen King') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Danse Macabre', 0, 0, 0, 512, 1024, DATE '2011-03-01', 'Before he gave us the “one of a kind classic” (The Wall Street Journal) memoir On Writing, Stephen King wrote a nonfiction masterpiece in Danse Macabre, “one of the best books on American popular culture” (Philadelphia Inquirer). From the author of dozens of #1 New York Times bestsellers and the creator of many unforgettable movies comes a vivid, intelligent, and nostalgic journey through three decades of horror as experienced through the eyes of the most popular writer in the genre. In 1981, years before he sat down to tackle On Writing, Stephen King decided to address the topic of what makes horror horrifying and what makes terror terrifying. Here, in ten brilliantly written chapters, King delivers one colorful observation after another about the great stories, books, and films that comprise the horror genre—from Frankenstein and Dracula to The Exorcist, The Twilight Zone, and Earth vs. The Flying Saucers. With the insight and good humor his fans appreciated in On Writing, Danse Macabre is an enjoyably entertaining tour through Stephen King’s beloved world of horror.', 'https://books.google.com/books/content?id=Rs1WbPRa3LoC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Stephen King') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Danse Macabre')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Robert Louis Stevenson') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Dr. Jekyll and Mr. Hyde & Other Stories', 0, 0, 0, 192, 384, DATE '2024-08-27', 'This spine-tingling volume collects some of Robert Louis Stevenson’s stories first published in the late 19th century for a new generation of young readers—featuring a freshly reimagined cover! Dr. Henry Jekyll is a respectable man, sociable and well-liked, so his friends Mr. Utterson and Mr. Enfield are concerned when Dr. Jekyll appears linked to Edward Hyde. Mr. Hyde’s outbursts of violence have their small community on edge; he may be small in stature, but no one can deny he’s terribly dangerous, self-indulgent, and even evil. As Dr. Jekyll’s behavior grows more erratic and Mr. Utterson circles in ever closer to the elusive Mr. Hyde, the shocking truth of the relationship between the good doctor and the unholy terror comes to light—a chain of events set off by a repressed man giving himself over wholly to the worst of his vices and shame. Also included are “The Body Snatcher,” a story about medical students haunted by what they’ve done to obtain cadavers, and “The Bottle Imp,” a tale of a man who buys a cursed bottle who learns about the consequences of wishes.', 'https://books.google.com/books/content?id=QNTyEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Robert Louis Stevenson') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Dr. Jekyll and Mr. Hyde & Other Stories')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Bram Stoker') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Dracula', 0, 0, 0, 529, 1058, DATE '2017-01-29', 'Jonathan Harker has business in Transylvania with the mysterious Count Dracula. Harker travels by train and carriage to get to Dracula''s remote castle. Once there, Harker, finds, to his horror, that he is a prisoner and that Dracula has a dark, evil secret. Wandering the castle alone at night, Harker is nearly killed by three vampyric sisters. Dracula saves him from the sisters in order that Harker might finish the last of the legal necessities for his move to London. Once that work is done Dracula abandons Harker to the three bloodthirsty sisters and leaves for England. Harker barely escapes from the castle with his life. To his horror he discovers that back in London, Dracula is stalking Harker''s fiancee Mina Murray and her friend Lucy. Harker struggles to get home, where he and everyone he loves will be locked in a fight for their very souls.', 'https://books.google.com/books/content?id=noycEQAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Bram Stoker') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Dracula')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Stephen King') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Four Past Midnight', 0, 0, 0, 1024, 2048, DATE '2017-04-25', 'Four novellas about horror in the late night hours.', 'https://books.google.com/books/content?id=TpOxDgAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Stephen King') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Four Past Midnight')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Mary Shelley') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Frankenstein', 0, 3.5, 16, 353, 706, DATE '2004-05-01', '"Includes detailed explanatory notes, an overview of key themes, and more"--Cover.', 'https://books.google.com/books/content?id=UL6Cwv2Z1iQC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Mary Shelley') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Frankenstein')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Nancy Holder') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'On Fire', 0, 4.5, 22, 246, 492, DATE '2012-07-17', 'DREAMS CAN COME TRUE. JUST NOT THE GOOD ONES. In Beacon Hills, a mountain lion is blamed for a spate of vicious attacks; Scott McCall wishes the cause was that simple. Unfortunately, hiding his werewolf identity, especially from Allison Argent, while fighting his need to shift, is only one problem. Keeping his mysterious, murderous Alpha off his back (literally), avoiding hunters, deciphering strange dreams about flames and impending doom . . . is really eating into lacrosse practice and hang-out time. So when Jackson Whittemore doesn’t show for his date with Lydia, Scott hopes that helping Allison track down their buddy will be simpler. Derek—whose hunger for vengeance blinds him to the dangers that lie in wait—and Stiles are also looking, but the worried teens’ search is leading right to the preserve from Scott’s nightmare. They aren’t the only ones in the woods, and their little trip starts looking less like a rescue mission and more like an elaborate trap—one that will force them to make the choice between killing and being killed. . . .', 'https://books.google.com/books/content?id=unSMEJnoQIYC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Nancy Holder') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('On Fire')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Cassandra Clare') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Tales from the Shadowhunter Academy', 0, 0, 0, 704, 1408, DATE '2017-08-01', 'Collects short stories chronicling Simon''s journey from amnesia to Ascension, as he works to regain his lost life while attending the Shadowhunter Academy.', 'https://books.google.com/books/content?id=EKMkEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Cassandra Clare') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Tales from the Shadowhunter Academy')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Howard Phillips Lovecraft') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Dream-quest of Unknown Kadath', 0, 0, 0, 74, 148, DATE '2019-06-03', 'Randolph Carter dreams three times of a majestic sunset city, but each time he is abruptly snatched away before he can see it up close. When he prays to the gods of dream to reveal the whereabouts of the phantasmal city, they do not answer, and his dreams of the city stop altogether. Undaunted, Carter resolves to go to Kadath, where the gods live, to beseech them in person. However, no one has ever been to Kadath and none even knows how to get there. In dream, Randolph Carter descends "the seventy steps to the cavern of flame" and speaks of his plan to the priests Nasht and Kaman-Thah, whose temple borders the Dreamlands. The priests warn Carter of the great danger of his quest and suggest that the gods withdrew his vision of the city on purpose.', 'https://books.google.com/books/content?id=mUuyzgEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Howard Phillips Lovecraft') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Dream-quest of Unknown Kadath')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Algernon Blackwood') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Empty House', 0, 0, 0, 336, 672, DATE '1917-01-01', '', 'https://books.google.com/books/content?id=5yE3dj6sr3MC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Algernon Blackwood') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Empty House')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Stephen King') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Green Mile', 0, 5, 2, 512, 1024, DATE '2017-06-27', 'Contains all six installments of the serialized horror novel about death row prisoner John Coffey and his fellow inmates and guards in the Green Mile wing of Cold Mountain Penitentiary.', 'https://books.google.com/books/content?id=v-IoDwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Stephen King') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Green Mile')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Christopher Pike') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Howling Ghost', 0, 0, 0, 128, 256, DATE '2014-08-05', 'Cindy''s brother is taken away by a ghost. Sally, Adam, and Watch promise to bring him back.', 'https://books.google.com/books/content?id=hlMdBAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Christopher Pike') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Howling Ghost')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Steve Alten') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Loch', 0, 5, 4, 564, 1128, DATE '2010-08-03', 'Marine biologist Zachary Wallace once suffered a near-drowning experience in legendary Loch Ness, and now, long-forgotten memories of that experience have begun haunting him. The truth surrounding these memories lies with Zachary''s estranged father, Angus Wallace, a wily Highlander on trial for murder. Together the two plunge into a world where the legend of Loch Ness shows its true face. At the Publisher''s request, this title is being sold without Digital Rights Management Software (DRM) applied.', 'https://books.google.com/books/content?id=Ks0jl2uD9ygC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Steve Alten') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Loch')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Gaston Leroux') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Phantom of the Opera', 0, 0, 0, 116, 232, DATE '2010-09-01', 'Under the Paris Opera House lives a disfigured musical genius who uses music to win the love of a beautiful opera singer.', 'https://books.google.com/books/content?id=Q1ImLhJJjJsC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Gaston Leroux') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Phantom of the Opera')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Christopher Pike') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Secret Path', 0, 0, 0, 128, 256, DATE '2014-08-05', 'Disregarding a warning that the town of Springfield is called "Spooksville" for a good reason, newcomer Adam accompanies his friends to a secret path at the graveyard that is said to lead to other, more terrifying worlds.', 'https://books.google.com/books/content?id=8lIdBAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Christopher Pike') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Secret Path')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Stephen King') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Shining', 0, 0, 0, 593, 1186, DATE '2025-07-29', '#1 NEW YORK TIMES BESTSELLER • ONE OF TIME''S 100 BEST MYSTERY AND THRILLER BOOKS OF ALL TIME • In this masterpiece of modern American horror that inspired Stanley Kubrick’s classic film, Jack Torrance takes a job as the caretaker of the remote Overlook Hotel. As the brutal winter sets in, the hotel’s dark secrets begin to unravel. “An undisputed master of suspense and terror.” —The Washington Post Jack Torrance’s new job at the Overlook Hotel is the perfect chance for a fresh start. As the off-season caretaker at the atmospheric old hotel, he’ll have plenty of time to spend reconnecting with his family and working on his writing. But as the harsh winter weather sets in, the idyllic location feels ever more remote . . . and more sinister. And the only one to notice the strange and terrible forces gathering around the Overlook is Danny Torrance, a uniquely gifted five-year-old.', 'https://books.google.com/books/content?id=QABREQAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Stephen King') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Shining')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Clive Barker') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Thief of Always', 0, 0, 0, 210, 420, DATE '2025-07-01', '“Menacing demons, wondrous miracles, sinister magic, and vivid characters make Thief a compulsive, lightning-paced tales that almost begs to be read aloud.”—Miami Herald One of horror master and international bestselling author Clive Barker’s classic early novels—the tale of a haunted house with many a dark secret, now available as a Harper Perennial Olive Edition. Be careful what you wish for, it might just come true . . . Mr. Hood''s Holiday House has stood for a thousand years, welcoming children into its embrace. It is a place of miracles where every whim may be satisfied. There is a price to be paid, of course, but young Harvey Swick, bored with his life and beguiled by Mr. Hood''s wonders, does not consider the consequences. It is only when the house shows its darker face—when Harvey discovers the pitiful creatures that dwell in its shadows—that he comes to doubt Mr. Hood''s generosity. But the house and its mysterious architect will not release Harvey without a battle. Mr. Hood has plans for his young guest, a boy whose soul burns brighter than any he has encountered in ten centuries. . . . A great read for spooky-season nights A perfect addition to any Halloween reading list', 'https://books.google.com/books/content?id=uJ5IEQAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Clive Barker') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Thief of Always')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Stephen King') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Tommyknockers', 0, 5, 1, 880, 1760, DATE '2016-02-16', 'Roberta Anderson, while searching for firewood in the forest, stumbles upon a buried ship and with the help of her onetime lover, Jim Gardener, excavates an artifact that changes the townspeople of Haven.', 'https://books.google.com/books/content?id=yWiMCwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Stephen King') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Tommyknockers')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Stephen King') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Thinner', 0, 0, 0, 352, 704, DATE '2016-03-08', '"The ''extraordinary'' (Booklist) novel of one man''s quest to find the source of his nightmare and to reverse it before he becomes...nothing at all. This #1 national bestseller from Stephen King, writing as Richard Bachman, "pulsates with evil...it will have you on the edge of your seat" (Publishers Weekly)"--', 'https://books.google.com/books/content?id=tCSpCwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Stephen King') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Horror' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Thinner')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Florian Cajori') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'A History of Mathematics', 0, 0, 0, 448, 896, DATE '1895-01-01', 'Many of the earliest books, particularly those dating back to the 1900s and before, are now extremely scarce and increasingly expensive. We are republishing these classic works in affordable, high quality, modern editions, using the original text and artwork.', 'https://books.google.com/books/content?id=Y1hIAQAAMAAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Florian Cajori') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('A History of Mathematics')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('L. Mirsky') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'An Introduction to Linear Algebra', 0, 0, 0, 466, 932, DATE '2012-12-03', 'Rigorous, self-contained coverage of determinants, vectors, matrices and linear equations, quadratic forms, more. Elementary, easily readable account with numerous examples and problems at the end of each chapter.', 'https://books.google.com/books/content?id=TteOFYtbIVQC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('L. Mirsky') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('An Introduction to Linear Algebra')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Edwin A. Abbott') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Flatland', 0, 0, 0, 90, 180, DATE '2018-12-17', 'A mathematical satire and a mathematical essay on the existence of a fourth spatial dimension', 'https://books.google.com/books/content?id=V5nfvwEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Edwin A. Abbott') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Flatland')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Serge Lang') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Fundamentals of Differential Geometry', 0, 0, 0, 553, 1106, DATE '2012-12-06', 'The present book aims to give a fairly comprehensive account of the fundamentals of differential manifolds and differential geometry. The size of the book influenced where to stop, and there would be enough material for a second volume (this is not a threat). At the most basic level, the book gives an introduction to the basic concepts which are used in differential topology, differential geometry, and differential equations. In differential topology, one studies for instance homotopy classes of maps and the possibility of finding suitable differen tiable maps in them (immersions, embeddings, isomorphisms, etc. ). One may also use differentiable structures on topological manifolds to deter mine the topological structure of the manifold (for example, it la Smale [Sm 67]). In differential geometry, one puts an additional structure on the differentiable manifold (a vector field, a spray, a 2-form, a Riemannian metric, ad lib. ) and studies properties connected especially with these objects. Formally, one may say that one studies properties invariant under the group of differentiable automorphisms which preserve the additional structure. In differential equations, one studies vector fields and their in tegral curves, singular points, stable and unstable manifolds, etc. A certain number of concepts are essential for all three, and are so basic and elementary that it is worthwhile to collect them together so that more advanced expositions can be given without having to start from the very beginnings.', 'https://books.google.com/books/content?id=Ku3jBwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Serge Lang') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Fundamentals of Differential Geometry')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Joseph Warren Dauben') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Georg Cantor', 0, 0, 0, 419, 838, DATE '1990-10-10', 'One of the greatest revolutions in mathematics occurred when Georg Cantor (1845-1918) promulgated his theory of transfinite sets. This revolution is the subject of Joseph Dauben''s important studythe most thorough yet writtenof the philosopher and mathematician who was once called a "corrupter of youth" for an innovation that is now a vital component of elementary school curricula. Set theory has been widely adopted in mathematics and philosophy, but the controversy surrounding it at the turn of the century remains of great interest. Cantor''s own faith in his theory was partly theological. His religious beliefs led him to expect paradoxes in any concept of the infinite, and he always retained his belief in the utter veracity of transfinite set theory. Later in his life, he was troubled by recurring attacks of severe depression. Dauben shows that these played an integral part in his understanding and defense of set theory.', 'https://books.google.com/books/content?id=leI9DwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Joseph Warren Dauben') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Georg Cantor')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Dirk J. Struik') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Lectures on Classical Differential Geometry', 0, 1, 1, 254, 508, DATE '2012-04-26', 'Elementary, yet authoritative and scholarly, this book offers an excellent brief introduction to the classical theory of differential geometry. It is aimed at advanced undergraduate and graduate students who will find it not only highly readable but replete with illustrations carefully selected to help stimulate the student''s visual understanding of geometry. The text features an abundance of problems, most of which are simple enough for class use, and often convey an interesting geometrical fact. A selection of more difficult problems has been included to challenge the ambitious student. Written by a noted mathematician and historian of mathematics, this volume presents the fundamental conceptions of the theory of curves and surfaces and applies them to a number of examples. Dr. Struik has enhanced the treatment with copious historical, biographical, and bibliographical references that place the theory in context and encourage the student to consult original sources and discover additional important ideas there. For this second edition, Professor Struik made some corrections and added an appendix with a sketch of the application of Cartan''s method of Pfaffians to curve and surface theory. The result was to further increase the merit of this stimulating, thought-provoking text — ideal for classroom use, but also perfectly suited for self-study. In this attractive, inexpensive paperback edition, it belongs in the library of any mathematician or student of mathematics interested in differential geometry.', 'https://books.google.com/books/content?id=JVC8AQAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Dirk J. Struik') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Lectures on Classical Differential Geometry')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Gene H. Golub') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Matrix Computations', 0, 0, 0, 781, 1562, DATE '2013-02-15', 'A comprehensive treatment of numerical linear algebra from the standpoint of both theory and practice. The fourth edition of Gene H. Golub and Charles F. Van Loan''s classic is an essential reference for computational scientists and engineers in addition to researchers in the numerical linear algebra community. Anyone whose work requires the solution to a matrix problem and an appreciation of its mathematical properties will find this book to be an indispensible tool. This revision is a cover-to-cover expansion and renovation of the third edition. It now includes an introduction to tensor computations and brand new sections on • fast transforms • parallel LU • discrete Poisson solvers • pseudospectra • structured linear equation problems • structured eigenvalue problems • large-scale SVD methods • polynomial eigenvalue problems Matrix Computations is packed with challenging problems, insightful derivations, and pointers to the literature—everything needed to become a matrix-savvy developer of numerical methods and software. The second most cited math book of 2012 according to MathSciNet, the book has placed in the top 10 for since 2005.', 'https://books.google.com/books/content?id=5U-l8U3P-VUC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Gene H. Golub') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Matrix Computations')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Geoffrey Hunter') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Metalogic', 0, 1, 1, 306, 612, DATE '1973-06-26', 'This work makes available to readers without specialized training in mathematics complete proofs of the fundamental metatheorems of standard (i.e., basically truth-functional) first order logic. Included is a complete proof, accessible to non-mathematicians, of the undecidability of first order logic, the most important fact about logic to emerge from the work of the last half-century. Hunter explains concepts of mathematics and set theory along the way for the benefit of non-mathematicians. He also provides ample exercises with comprehensive answers.', 'https://books.google.com/books/content?id=oHpMtskGcv0C&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Geoffrey Hunter') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Metalogic')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Kalyanmoy Deb') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Multi-Objective Optimization using Evolutionary Algorithms', 0, 5, 3, 540, 1080, DATE '2001-07-05', 'Evolutionary algorithms are relatively new, but very powerful techniques used to find solutions to many real-world search and optimization problems. Many of these problems have multiple objectives, which leads to the need to obtain a set of optimal solutions, known as effective solutions. It has been found that using evolutionary algorithms is a highly effective way of finding multiple effective solutions in a single simulation run. Comprehensive coverage of this growing area of research Carefully introduces each algorithm with examples and in-depth discussion Includes many applications to real-world problems, including engineering design and scheduling Includes discussion of advanced topics and future research Can be used as a course text or for self-study Accessible to those with limited knowledge of classical multi-objective optimization and evolutionary algorithms The integrated presentation of theory, algorithms and examples will benefit those working and researching in the areas of optimization, optimal design and evolutionary computing. This text provides an excellent introduction to the use of evolutionary algorithms in multi-objective optimization, allowing use as a graduate course text or for self-study.', 'https://books.google.com/books/content?id=OSTn4GSy2uQC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Kalyanmoy Deb') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Multi-Objective Optimization using Evolutionary Algorithms')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Suhas Patankar') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Numerical Heat Transfer and Fluid Flow', 0, 5, 11, 218, 436, DATE '1980-01-01', 'This book focuses on heat and mass transfer, fluid flow, chemical reaction, and other related processes that occur in engineering equipment, the natural environment, and living organisms. Using simple algebra and elementary calculus, the author develops numerical methods for predicting these processes mainly based on physical considerations. Through this approach, readers will develop a deeper understanding of the underlying physical aspects of heat transfer and fluid flow as well as improve their ability to analyze and interpret computed results.', 'https://books.google.com/books/content?id=5JMYZMX3OVcC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Suhas Patankar') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Numerical Heat Transfer and Fluid Flow')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Allan Gut') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Probability: A Graduate Course', 0, 0, 0, 619, 1238, DATE '2012-10-17', 'Like its predecessor, this book starts from the premise that, rather than being a purely mathematical discipline, probability theory is an intimate companion of statistics. The book starts with the basic tools, and goes on to cover a number of subjects in detail, including chapters on inequalities, characteristic functions and convergence. This is followed by a thorough treatment of the three main subjects in probability theory: the law of large numbers, the central limit theorem, and the law of the iterated logarithm. After a discussion of generalizations and extensions, the book concludes with an extensive chapter on martingales. The new edition is comprehensively updated, including some new material as well as around a dozen new references.', 'https://books.google.com/books/content?id=XDFA-n_M5hMC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Allan Gut') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Probability: A Graduate Course')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('J. P. Verma') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Repeated Measures Design for Empirical Researchers', 0, 0, 0, 288, 576, DATE '2015-08-21', 'Introduces the applications of repeated measures design processes with the popular IBM® SPSS® software Repeated Measures Design for Empirical Researchers presents comprehensive coverage of the formation of research questions and the analysis of repeated measures using IBM SPSS and also includes the solutions necessary for understanding situations where the designs can be used. In addition to explaining the computation involved in each design, the book presents a unique discussion on how to conceptualize research problems as well as identify appropriate repeated measures designs for research purposes. Featuring practical examples from a multitude of domains including psychology, the social sciences, management, and sports science, the book helps readers better understand the associated theories and methodologies of repeated measures design processes. The book covers various fundamental concepts involved in the design of experiments, basic statistical designs, computational details, differentiating independent and repeated measures designs, and testing assumptions. Along with an introduction to IBM SPSS software, Repeated Measures Design for Empirical Researchers includes: A discussion of the popular repeated measures designs frequently used by researchers, such as one-way repeated measures ANOVA, two-way repeated measures design, two-way mixed design, and mixed design with two-way MANOVA Coverage of sample size determination for the successful implementation of designing and analyzing a repeated measures study A step-by-step guide to analyzing the data obtained with real-world examples throughout to illustrate the underlying advantages and assumptions A companion website with supplementary IBM SPSS data sets and programming solutions as well as additional case studies Repeated Measures Design for Empirical Researchers is a useful textbook for graduate- and PhD-level students majoring in biostatistics, the social sciences, psychology, medicine, management, sports, physical education, and health. The book is also an excellent reference for professionals interested in experimental designs and statistical sciences as well as statistical consultants and practitioners from other fields including biological, medical, agricultural, and horticultural sciences. J. P. Verma, PhD, is Professor of Statistics and Director of the Center for Advanced Studies at Lakshmibai National Institute of Physical Education, India. Professor Verma is an active researcher in sports modeling and data analysis and has conducted many workshops on research methodology, research designs, multivariate analysis, statistical modeling, and data analysis for students of management, physical education, social science, and economics. He is the author of Statistics for Exercise Science and Health with Microsoft® Office Excel®, also published by Wiley.', 'https://books.google.com/books/content?id=f4BsCgAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('J. P. Verma') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Repeated Measures Design for Empirical Researchers')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('William Fulton') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Representation Theory', 0, 0, 0, 616, 1232, DATE '1991-10-22', 'Introducing finite-dimensional representations of Lie groups and Lie algebras, this example-oriented book works from representation theory of finite groups, through Lie groups and Lie algrbras to the finite dimensional representations of the classical groups.', 'https://books.google.com/books/content?id=qGFzi20nMcYC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('William Fulton') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Representation Theory')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Amos Harpaz') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Stellar Evolution', 0, 0, 0, 272, 544, DATE '1993-06-15', 'This book addresses the fascinating subject of astrophysics from its theoretical basis to predominant research conducted in the field today. An accomplished researcher in the field and a well-known expositor, the author strikes a balance that allows the serious reader to appreciate the current issues without previous knowledge of the subject.Astron', 'https://books.google.com/books/content?id=A2G1DwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Amos Harpaz') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Stellar Evolution')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Marcus du Sautoy') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Music of the Primes', 0, 0, 0, 350, 700, DATE '2004-04-27', 'Examines German mathematician Bernhard Riemann''s hypothesis on imaginary numbers, sine waves, and prime numbers and attempts to unravel the mystery surrounding it.', 'https://books.google.com/books/content?id=x1Jlf9e3EgsC&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Marcus du Sautoy') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Music of the Primes')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Norman K. Denzin') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The SAGE Handbook of Qualitative Research', 0, 0, 0, 100, 200, DATE '2017-01-01', '', 'https://books.google.com/books/content?id=73MJMQAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Norman K. Denzin') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The SAGE Handbook of Qualitative Research')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Andreas M. Hinz') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Tower of Hanoi – Myths and Maths', 0, 0, 0, 340, 680, DATE '2013-01-31', 'This is the first comprehensive monograph on the mathematical theory of the solitaire game “The Tower of Hanoi” which was invented in the 19th century by the French number theorist Édouard Lucas. The book comprises a survey of the historical development from the game’s predecessors up to recent research in mathematics and applications in computer science and psychology. Apart from long-standing myths it contains a thorough, largely self-contained presentation of the essential mathematical facts with complete proofs, including also unpublished material. The main objects of research today are the so-called Hanoi graphs and the related Sierpiński graphs. Acknowledging the great popularity of the topic in computer science, algorithms and their correctness proofs form an essential part of the book. In view of the most important practical applications of the Tower of Hanoi and its variants, namely in physics, network theory, and cognitive (neuro)psychology, other related structures and puzzles like, e.g., the “Tower of London”, are addressed. Numerous captivating integer sequences arise along the way, but also many open questions impose themselves. Central among these is the famed Frame-Stewart conjecture. Despite many attempts to decide it and large-scale numerical experiments supporting its truth, it remains unsettled after more than 70 years and thus demonstrates the timeliness of the topic. Enriched with elaborate illustrations, connections to other puzzles and challenges for the reader in the form of (solved) exercises as well as problems for further exploration, this book is enjoyable reading for students, educators, game enthusiasts and researchers alike.', 'https://books.google.com/books/content?id=FbJDAAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Andreas M. Hinz') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Tower of Hanoi – Myths and Maths')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Arthur Shavit') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Thermodynamics', 0, 0, 0, 654, 1308, DATE '2008-12-09', 'There are many thermodynamics texts on the market, yet most provide a presentation that is at a level too high for those new to the field. This second edition of Thermodynamics continues to provide an accessible introduction to thermodynamics, which maintains an appropriate rigor to prepare newcomers for subsequent, more advanced topics. The book p', 'https://books.google.com/books/content?id=MqiNEQAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Arthur Shavit') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Thermodynamics')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Ptolemy') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'TOOMER:PTOLEMY''S ALMAGEST, (DUCKWORTH)', 0, 0, 0, 714, 1428, DATE '2020-05-05', 'Ptolemy''s Almagest is one of the most influential scientific works in history. A masterpiece of technical exposition, it was the basic textbook of astronomy for more than a thousand years, and still is the main source for our knowledge of ancient astronomy. This translation, based on the standard Greek text of Heiberg, makes the work accessible to English readers in an intelligible and reliable form. It contains numerous corrections derived from medieval Arabic translations and extensive footnotes that take account of the great progress in understanding the work made in this century, due to the discovery of Babylonian records and other researches. It is designed to stand by itself as an interpretation of the original, but it will also be useful as an aid to reading the Greek text.', 'https://books.google.com/books/content?id=hOfaDwAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Ptolemy') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mathematics' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('TOOMER:PTOLEMY''S ALMAGEST, (DUCKWORTH)')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Sue Grafton') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), '"A" is for Alibi', 0, 0, 0, 110, 220, DATE '2005-01-01', '', 'https://books.google.com/books/content?id=3CZ8PgAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Sue Grafton') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('"A" is for Alibi')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Agatha Christie') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Cards on the Table', 0, 0, 0, 228, 456, DATE '1990-01-01', 'A BBC Radio full-cast dramatization starring John Moffatt as Hercule Poirot, with Stephanie Cole and Donald Sinden. Hercule Poirot, along with three other luminaries from the world of crime detection, is invited to dinner by the renowned London socialite Dr. Shaitana. Also on the guest list are four members of what Shaitana calls his Black Museum--a collection of murderers who have each succeeded in "getting away with it." After midnight, when the guests prepare to leave, they make a terrible discovery. Their host is dead in his armchair, stabbed in the chest. The four sleuths are thus faced with one murder and a quartet of likely suspects. Working both together and independently, they investigate the past of the Black Museum''s finest in order to determine the most likely killer. Poirot finds that many distractions are thrown in his way, as he attempts to read the meaning of the cards which each suspect has placed on the table.', 'https://books.google.com/books/content?id=31N6sAL5kaUC&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Agatha Christie') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Cards on the Table')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Fyodor Dostoyevsky') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Crime and Punishment', 0, 0, 0, 446, 892, DATE '2025-01-17', 'Crime and Punishment is a novel by Fyodor Dostoevsky, first published in 1866. Set in St. Petersburg, Russia, it follows the troubled former student Rodion Raskolnikov. Raskolnikov struggles with poverty, alienation, and a philosophical crisis, grappling with themes of morality, guilt, and redemption. The story begins with Raskolnikov''s decision to murder a pawnbroker, Alyona Ivanovna, whom he views as greedy and worthless. He believes that eliminating her will allow him to improve his own life and help others. However, after the murder, he is consumed by guilt and paranoia, leading to a mental breakdown. As Raskolnikov''s mental state deteriorates, he becomes increasingly isolated from his family, including his devoted sister Dounia. Their relationship highlights themes of familial love and sacrifice. Another key character is Sonia Semyonovna Marmeladov, a young woman forced into prostitution to support her family. Sonia represents compassion and selflessness, contrasting sharply with Raskolnikov''s nihilism. Their relationship becomes central to Raskolnikov''s quest for redemption. Dostoevsky delves into the psychological aspects of crime and punishment, illustrating Raskolnikov''s internal conflict through dreams and conversations. The police inspector, Porfiry Petrovich, adds tension to the narrative as he investigates the murder, engaging Raskolnikov in philosophical discussions about justice and morality. Raskolnikov''s mental anguish intensifies as he feels increasingly judged and paranoid. Despite contemplating suicide, the love of Sonia and his family offers him hope for redemption. The novel also addresses the social and economic conditions of 19th-century Russia, highlighting the stark divide between the wealthy and the impoverished. The climax occurs when Raskolnikov confesses to the murders, realizing he cannot escape the consequences of his actions. His confession marks a turning point, leading to his imprisonment in Siberia, where he confronts his guilt and seeks a deeper understanding of himself. Sonia''s unwavering support plays a crucial role in his transformation as he grapples with suffering and the possibility of forgiveness. The novel concludes with Raskolnikov''s journey toward redemption, emphasizing the importance of compassion and human connection. Crime and Punishment is a profound exploration of the human psyche and moral dilemmas, inviting readers to reflect on their beliefs about justice and the nature of punishment. Through Raskolnikov''s struggles, Dostoevsky examines the complexities of human nature, revealing that true understanding often comes from embracing one''s humanity. The vivid portrayal of St. Petersburg reflects the moral decay of society, enhancing the themes of alienation and despair. Crime and Punishment remains a timeless classic that challenges readers to consider the consequences of their actions and the transformative power of love and compassion. Dostoevsky''s masterful storytelling ensures that the novel resonates with audiences across generations, making it a cornerstone of literary and philosophical discourse.', 'https://books.google.com/books/content?id=GpQ_EQAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Fyodor Dostoyevsky') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Crime and Punishment')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Erich Kästner') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Emil and the Detectives', 0, 0, 0, 218, 436, DATE '1995-01-01', 'Emil, Gustav, and a group of young detectives outwit criminals and the police when they comb the city in their quest to recover Emil''s stolen money.', 'https://books.google.com/books/content?id=jeCoPwAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Erich Kästner') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Emil and the Detectives')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Ruth Rendell') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'From Doon with Death', 0, 3, 3, 210, 420, DATE '1988-01-01', 'When Margaret Parsons disappears, Inspector Burden tries to reassure her frantic husband that she will be back by morning. Privately, though, he is certain Margaret has run off with another man. But then the missing woman''s body is found, strangled and abandoned in a nearby wood. And when Mr. Parsons lets the police into his home, a startling discovery leads everyone to question just who Margaret Parsons really was . . .', 'https://books.google.com/books/content?id=T8W7Tq8mMBAC&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Ruth Rendell') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('From Doon with Death')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Orhan Pamuk') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'My Name is Red', 0, 0, 0, 468, 936, DATE '2001-01-01', '', 'https://books.google.com/books/content?id=fElQlIT6k50C&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Orhan Pamuk') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('My Name is Red')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Agatha Christie') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'QBD Murder on the Orient Express', 0, 0, 0, 100, 200, DATE '2015-06-08', '', '/book-service/book-covers/default-book-cover.svg', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Agatha Christie') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('QBD Murder on the Orient Express')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Fred Vargas') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Seeking Whom He May Devour', 0, 0, 0, 278, 556, DATE '2004-01-01', 'In this frightening and surprising novel, the eccentric, wayward genius of commissaire Adamsberg is pitted against the deep-rooted mysteries of one Alpine village''s history and a very present problem : wolves.', 'https://books.google.com/books/content?id=_bIdAQAAIAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Fred Vargas') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Seeking Whom He May Devour')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('P.D. James') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Black Tower', 0, 0, 0, 352, 704, DATE '2001-10-02', 'Adam Dalgliesh responds to an invitation to visit an old family friend, the chaplain at a private home for the disabled in Dorset. On arrival he discovers that his host has died suddenly.', 'https://books.google.com/books/content?id=a4eRA77h4WEC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('P.D. James') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Black Tower')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Mark Haddon') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Curious Incident of the Dog in the Night-time', 0, 0, 0, 271, 542, DATE '2004-01-01', 'Narrated by a 15-year-old autistic savant obsessed with Sherlock Holmes, this dazzling novel weaves together an old-fashioned mystery, a contemporary coming-of-age story, and a fascinating excursion into a mind incapable of processing emotions.', '/book-service/book-covers/default-book-cover.svg', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Mark Haddon') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Curious Incident of the Dog in the Night-time')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Dan Brown') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Da Vinci Code', 0, 5, 2, 484, 968, DATE '2004-01-01', 'Harvard professor Robert Langdon receives an urgent late-night phone call while on business in Paris: the elderly curator of the Louvre, Jacques Sauni''re, has been brutally murdered inside the museum. Alongside the body, police have found a series of baffling codes. As Langdon and a gifted French cryptologist, Sophie Neveu, begin to sort through the bizarre riddles, they are stunned to find a trail that leads to the works of Leonardo Da Vinci - and suggests the answer to a mystery that stretches deep into the vault of history. Langdon suspects the late curator was involved in the Priory of Sion - a centuries old secret society - and has sacrificed his life to protect the Priory''s most sacred trust: the location of a vastly important religious relic hidden for centuries. But it now appears that Opus Dei, a clandestine sect that has long plotted to seize the Prirory''s secret, has now made its move. Unless Langdon and Neveu can decipher the labyrinthine code and quickly assemble the pieces of the puzzle, the Priory''s secret - and a stunning historical truth - will be lost forever. Breaking the mould of traditional suspense novels, The DA VINCI CODE is simultaneously lightning-paced, intelligent and intricately layered with remarkable research and detail. And in this exclusive edition Dan Brown allows the reader behind the scenes of the novel which now incorporates over 150 photographs and illustrations throughout the text showing the rich historical tapestry from which he drew his inspiration. The visual sources which provide both the backdrop and the stimulus for the novel''s action are revealed for the first time and uniquely complement the reading experience.', 'https://books.google.com/books/content?id=A-AS46wG0p8C&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Dan Brown') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Da Vinci Code')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Josephine Tey') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Daughter of Time', 0, 0, 0, 164, 328, DATE '2019-11-11', 'Alan Grant, Scotland Yard Inspector is feeling bored while confined to bed in hospital with a broken leg. Marta Hallard, an actress friend of his, suggests that he should amuse himself by researching a historical mystery. She brings him some pictures of historical characters, aware of Grant''s interest in human faces. He becomes intrigued by a portrait of King Richard III. He prides himself on being able to read a person''s character from his appearance, and King Richard seems to him a gentle, kind and wise man. Why is everyone so sure that he was a cruel murderer? With the help of other friends and acquaintances, Grant investigates Richard''s life and the case of the Princes in the Tower, testing out his theories on the doctors and nurses who attend to him. Grant spends weeks pondering historical information and documents with the help of Brent Carradine, a likable young American researcher working in the British Museum. Using his detective''s logic, he tries to come to the conclusion whether the claim of Richard being a murderer is a fabrication of Tudor propaganda, or was he really a monstrous hunchback. The Daughter of Time was voted greatest mystery novel of all time by the Crime Writers'' Association in 1990.', 'https://books.google.com/books/content?id=2rPoDwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Josephine Tey') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Daughter of Time')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Agatha Christie') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Golden Ball and Other Stories', 0, 0, 0, 250, 500, DATE '1971-01-01', 'It was an offer the St. Vincent family could not refuse--a splendid mansion, complete with servants, with nothing asked for in return! But young Rupert St. Vincent suspected a sinister trap...', 'https://books.google.com/books/content?id=a_v41_2p7vUC&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Agatha Christie') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Golden Ball and Other Stories')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Kate Morton') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The House at Riverton', 0, 3, 1, 496, 992, DATE '2009-03-03', 'Ninety-eight-year-old Grace Bradley is visited by a young director who takes her back to Riverton House where she reveals the secret behind the death of a young poet in the summer of 1924.', 'https://books.google.com/books/content?id=9iXsIAND7KQC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Kate Morton') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The House at Riverton')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Len Jenkin') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Invisible Man', 0, 0, 0, 78, 156, DATE '2000-01-01', '', 'https://books.google.com/books/content?id=SCHqme8AluYC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Len Jenkin') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Invisible Man')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Michael Connelly') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Narrows', 0, 0, 0, 100, 200, DATE '2010-01-01', 'FBI agent Rachel Walling gets the call that tells her the Poet has surfaced. She has never forgotten the serial killer who wove lines of poetry in his hideous crimes. Former LAPD detective Harry Bosch gets a call too, from the widow of an old friend. Her husband''s death seems natural, but his ties to the hunt for the Poet make Bosch dig deep. Arriving at a derelict spot in the California desert Bosch joins forces with Rachel. Police procedural.', '/book-service/book-covers/default-book-cover.svg', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Michael Connelly') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Narrows')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Alexander McCall Smith') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The No. 1 Ladies'' Detective Agency', 0, 0, 0, 100, 200, DATE '2008-01-01', 'Features two stand-alone BBC Radio 4 full-cast dramas.', 'https://books.google.com/books/content?id=0ziqzwEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Alexander McCall Smith') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The No. 1 Ladies'' Detective Agency')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Robert Ludlum') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Road to Gandolfo', 0, 0, 0, 338, 676, DATE '2014-12-30', 'War hero and infamous ladies’ man General MacKenzie Hawkins is a living legend. His life story has even been sold to Hollywood. But now he stands accused of defacing a historic monument in China’s Forbidden City. Under house arrest in Peking with a case against him pending in Washington, this looks like the end of Mac’s illustrious career. But he has a plan of his own: kidnap the Pope. What’s the ransom? Just one American dollar—for every Catholic in the world. Add to the mix a slew of shady “investors,” Mac’s four persuasive, well-endowed ex-wives, and a young lawyer and fellow soldier who wants nothing more than to return to private life, and readers have in their hands one relentlessly irreverent page-turner. Praise for Robert Ludlum “Don’t ever begin a [Robert] Ludlum novel if you have to go to work the next day.”—Chicago Sun-Times “Ludlum stuffs more surprises into his novels than any other six-pack of thriller writers combined.”—The New York Times', 'https://books.google.com/books/content?id=_YaODQAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Robert Ludlum') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Road to Gandolfo')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('John Grisham') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Runaway Jury', 0, 0, 0, 422, 844, DATE '1996-01-01', '#1 NEW YORK TIMES BESTSELLER They are at the center of a multimillion-dollar legal hurricane: twelve men and women who have been investigated, watched, manipulated, and harassed by high-priced lawyers and consultants who will stop at nothing to secure a verdict. Now the jury must make a decision in the most explosive civil trial of the century, a precedent-setting lawsuit against a giant tobacco company. But only a handful of people know the truth: that this jury has a leader, and the verdict belongs to him. He is known only as Juror #2. But he has a name, a past, and he has planned his every move with the help of a beautiful woman on the outside. Now, while a corporate empire hangs in the balance, while a grieving family waits, and while lawyers are plunged into a battle for their careers, the truth about Juror #2 is about to explode in a cross fire of greed and corruption--and with justice fighting for its life.', 'https://books.google.com/books/content?id=wss8YeLRqt8C&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('John Grisham') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Mystery' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Runaway Jury')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('David Hume') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'A Treatise of Human Nature', 0, 0, 0, 746, 1492, DATE '1888-01-01', '', 'https://books.google.com/books/content?id=HOjWAAAAMAAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('David Hume') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('A Treatise of Human Nature')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Alasdair MacIntyre') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'After Virtue', 0, 0, 0, 426, 852, DATE '2007-03-06', 'When After Virtue first appeared in 1981, it was recognized as a significant and potentially controversial critique of contemporary moral philosophy. Newsweek called it “a stunning new study of ethics by one of the foremost moral philosophers in the English-speaking world.” Since that time, the book has been translated into more than fifteen foreign languages and has sold over one hundred thousand copies. Now, twenty-five years later, the University of Notre Dame Press is pleased to release the third edition of After Virtue, which includes a new prologue “After Virtue after a Quarter of a Century.” In this classic work, Alasdair MacIntyre examines the historical and conceptual roots of the idea of virtue, diagnoses the reasons for its absence in personal and public life, and offers a tentative proposal for its recovery. While the individual chapters are wide-ranging, once pieced together they comprise a penetrating and focused argument about the price of modernity. In the Third Edition prologue, MacIntyre revisits the central theses of the book and concludes that although he has learned a great deal and has supplemented and refined his theses and arguments in other works, he has “as yet found no reason for abandoning the major contentions” of this book. While he recognizes that his conception of human beings as virtuous or vicious needed not only a metaphysical but also a biological grounding, ultimately he remains “committed to the thesis that it is only from the standpoint of a very different tradition, one whose beliefs and presuppositions were articulated in their classical form by Aristotle, that we can understand both the genesis and the predicament of moral modernity.”', 'https://books.google.com/books/content?id=4pUFDgAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Alasdair MacIntyre') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('After Virtue')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('John Dewey') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Art as Experience', 0, 4.5, 12, 390, 780, DATE '2005-07-05', 'Based on John Dewey''s lectures on esthetics, delivered as the first William James Lecturer at Harvard in 1932, Art as Experience has grown to be considered internationally as the most distinguished work ever written by an American on the formal structure and characteristic effects of all the arts: architecture, sculpture, painting, music, and literature.', 'https://books.google.com/books/content?id=aAbqAGo5MwwC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('John Dewey') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Art as Experience')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Lucius Annaeus Seneca') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Letters from a Stoic', 0, 0, 0, 224, 448, DATE '2013-01-01', 'Seneca''s major contribution to Stoicism was to spiritualize and humanize a system which could appear cold and unrealistic.', 'https://books.google.com/books/content?id=GBCbCwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Lucius Annaeus Seneca') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Letters from a Stoic')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Michel Foucault') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Madness and Civilization', 0, 0, 0, 324, 648, DATE '1971-01-01', '', 'https://books.google.com/books/content?id=yyVJWum2M3MC&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Michel Foucault') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Madness and Civilization')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Augustine') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'On Free Choice of the Will', 0, 3, 3, 164, 328, DATE '1993-01-01', '"Translated with an uncanny sense for the overall point of Augustine''s doctrine. In short, a very good translation. The Introduction is admirably clear." --Paul Vincent Spade, Indiana University', 'https://books.google.com/books/content?id=axCM5xaDKZ0C&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Augustine') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('On Free Choice of the Will')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Plato') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Phaedrus', 0, 0, 0, 132, 264, DATE '1998-01-01', '"Phaedrus is widely recognized as one of Plato''s most profound and beautiful works. It takes the form of a dialogue between Socrates and Phaedrus and its ostensible subject is love, especially homoerotic love. Socrates reveals it to be a kind of divine madness that can allow our souls to grow wings and soar to their greatest heights. Then the conversation changes direction and turns to a discussion of rhetoric, which must be based on truth passionately sought, thus allying it to philosophy. The dialogue closes by denigrating the value of the written word in any context, compared to the living teaching of a Socratic philosopher." "The shifts of topic and register have given rise to doubts about the unity of the dialogue, doubts which are addressed in the introduction to this volume. Full explanatory notes also elucidate issues throughout the dialogue that might puzzle a modern reader."--Jacket.', 'https://books.google.com/books/content?id=m56EqYgBh-wC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Plato') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Phaedrus')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Georg Wilhelm Friedrich Hegel') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Phenomenology of Spirit', 0, 4, 9, 648, 1296, DATE '1998-01-01', 'wide criticism both from Western and Eastern scholars.', 'https://books.google.com/books/content?id=xOnhG9tidGsC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Georg Wilhelm Friedrich Hegel') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Phenomenology of Spirit')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Jürgen Habermas') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Philosophy in a Time of Terror', 0, 0, 0, 236, 472, DATE '2003-06-15', 'The idea for Philosophy in a Time of Terror was born hours after the attacks on 9/11 and was realized just weeks later when Giovanna Borradori sat down with Jürgen Habermas and Jacques Derrida in New York City, in separate interviews, to evaluate the significance of the most destructive terrorist act ever perpetrated. This book marks an unprecedented encounter between two of the most influential thinkers of our age as here, for the first time, Habermas and Derrida overcome their mutual antagonism and agree to appear side by side. As the two philosophers disassemble and reassemble what we think we know about terrorism, they break from the familiar social and political rhetoric increasingly polarized between good and evil. In this process, we watch two of the greatest intellects of the century at work.', 'https://books.google.com/books/content?id=reNohFsTpEEC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Jürgen Habermas') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Philosophy in a Time of Terror')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Friedrich Nietzsche') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Birth of Tragedy', 0, 0, 0, 99, 198, DATE '2012-03-01', 'Philosopher''s classic study declares that Greek tragedy achieved greatness through a fusion of elements of Apollonian restraint and control with Dionysian components of passion and the irrational.', 'https://books.google.com/books/content?id=4dW7AQAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Friedrich Nietzsche') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Birth of Tragedy')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Brad Inwood') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Cambridge Companion to the Stoics', 0, 0, 0, 438, 876, DATE '2003-01-01', 'This unique volume offers an odyssey through the ideas of the Stoics in three particular ways: first, through the historical trajectory of the school itself and its influence; second, through the recovery of the history of Stoic thought; third, through the ongoing confrontation with Stoicism, showing how it refines philosophical traditions, challenges the imagination, and ultimately defines the kind of life one chooses to lead. A distinguished roster of specialists have written an authoritative guide to the entire philosophical tradition. The first two chapters chart the history of the school in the ancient world, and are followed by chapters on the core themes of the Stoic system: epistemology, logic, natural philosophy, theology, determinism, and metaphysics. There are two chapters on what might be thought of as the heart and soul of the Stoics system: ethics.', '/book-service/book-covers/default-book-cover.svg', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Brad Inwood') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Cambridge Companion to the Stoics')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Aristotle') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Categories', 0, 0, 0, 48, 96, DATE '2022-09-16', 'In ''The Categories,'' Aristotle embarks on a formidable exploration of logic and ontology with his characteristic meticulousness and foundational approach. Serving as an introduction to his logical treatises, colloquially known as the ''Organon,'' this work systematically delineates the ten categories—substance, quantity, quality, relation, place, time, position, state, action, and affection—through which beings are classified and by which the nature of reality can be contemplated. The literary style is a testament to Aristotle''s penchant for empirical observation and rigorous argumentation, situating ''The Categories'' in a pivotal place within both the Aristotelian corpus and the broader literary context of classical philosophy whose resonance echoes throughout the millennia. Relevant details such as its foundational role in the field of metaphysics and its influence on subsequent philosophical discourse underscore its perennial significance. Aristotle, the renowned student of Plato and tutor to Alexander the Great, composed this treatise to lay the groundwork for his successive inquiries into the nature of being and knowledge. Shaped by his experiences in the Academy and his own empirical investigations, ''The Categories'' reflects his dedication to the study of nature and commitment to the pursuit of truth. The text''s inception can partially be traced to Aristotle''s fascination with classifying and understanding the diversity within the natural world, an intellectual endeavor that would leave a monumental imprint upon the Western intellectual tradition. Scholars and students alike will find ''The Categories'' an indispensable entry point into Aristotelian thought. The work''s meticulous reconstruction by DigiCat Publishing enhances accessibility for contemporary audiences, echoing the timelessness of Aristotle''s inquiry into the essence of things. It is commended to those yearning for a foundational understanding of metaphysical concepts and their application to logical reasoning, as well as readers seeking to grasp the historical underpinnings of modern philosophical movements. ''The Categories'' remains a cornerstone of philosophical study, meriting deep reflection and rigorous engagement for any devoted scholar or impassioned reader of philosophy.', 'https://books.google.com/books/content?id=RZGKEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Aristotle') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Categories')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Carl Schmitt') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Concept of the Political', 0, 0, 0, 159, 318, DATE '2024-05-31', '"Arguably Schmitt''s most influential work . . . recognized as one of the most important tracts of modern political thought." —Samuel Earle, The New Statesman In this, his most influential work, legal theorist and political philosopher Carl Schmitt argues that liberalism''s basis in individual rights cannot provide a reasonable justification for sacrificing oneself for the state—a critique as cogent today as when it first appeared. George Schwab''s introduction to his translation of the 1932 German edition highlights Schmitt''s intellectual journey through the turbulent period of German history leading to the Hitlerian one-party state. In addition to analysis by Leo Strauss and a foreword by Tracy B. Strong placing Schmitt''s work into contemporary context, this expanded edition also includes a translation of Schmitt''s 1929 lecture "The Age of Neutralizations and Depoliticizations," which the author himself added to the 1932 edition of the book. An essential update on a modern classic, The Concept of the Political, Expanded Edition belongs on the bookshelf of anyone interested in political theory or philosophy. "Contains much of what is fundamental in Schmitt''s understanding of the political nature of man and the state, including his contentious definition of the political as the distinction between friend and enemy . . . Its scholarship is unquestionable." —Joseph W. Bendersky, Canadian Journal of Political and Social Theory "The best introduction to Schmitt''s thought." —Mark Lilla, New York Review of Books "[A] foundational work . . . Minor disagreements over terms fade . . . in light of the superb job Schwab has done rendering Schmitt''s long, multi-clausal German sentences into concise, pellucid English." —Robert D. Rachlin, HNet', 'https://books.google.com/books/content?id=sUYDQIXSEtoC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Carl Schmitt') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Concept of the Political')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Irving Singer') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Nature of Love', 0, 3, 1, 492, 984, DATE '1984-01-01', '"In this concluding volume of his impressive study of the history of Western thought about the nature of love, Irving Singer reviews the principal efforts that have been made by 20th-Century thinkers to analyze the phenomenon of love. . . . [T]he bulk of the book is taken up with critical accounts of the modern thinkers who have systematically called into question the possibility itself of love as a union of distinct human selves. For the most part, these critiques are effectively executed, and they bring a high level of critical acumen to bear on skeptical theses about love that are now too often accepted as truisms."--Frederick A. Olafson, Los Angeles Times Book Review "Irving Singer . . . has developed a method of historical analysis flexible enough to deal with all kinds of love, from Greek homosexual love in Plato, to the philia and agape of the New Testament, to the courtly love of medieval romance, to the Romantics, for whom love was magic. . . . [This] final volume brings us to the present. In ''The Modern World, '' Singer offers readings of Freud, Proust, and Sartre, among others. He shows how their work was formed in reaction to the 19th-century ideal of ''merging'' of the identities of lover and beloved. More often than not, the great modern writers portray love as impossible, as a field of failure and regret. . . . This masterpiece of critical thinking is a timely, eloquent, and scrupulous account of what, after all, still makes the world go round."--Thomas D''Evelyn, Christian Science Monitor "This is the third of a three-volume history of the philosophy of love. It begins with Kierkegaard, Tolstoy, and Nietzsche in the nineteenth century and treats Freud, Proust, Bergson, D. H. Lawrence, G. B. Shaw, Santayana, Sartre, and others in the twentieth. Although the author''s approach is primarily historical, he intersperses critical remarks throughout. Most of the major themes which are discussed by philosophers of love make their way into this history, including friendship, sexual love, and the distinction between love that is based on the value of the beloved and love that bestows value on the beloved. Singer devotes a number of pages to his own views on falling in love, being in love, and staying in love. . . . Singer''s exposition is lucid and organized; his criticisms are insightful."--Ethics "In this third volume of historical overview of the development of the Western conception of love, Singer uses writers, philosophers, and psychologists to provide the reader with an overview of love in the late 19th and 20th century. . . . Analyzing authors such as Tolstoy, Proust, D. H. Lawrence, and Shaw and philosophers such as Nietzsche, Kierkegaard, Sartre, and Santayana, as well as Freud, Singer . . . links each contributor''s thoughts to the influence of previous writers and also provides some psycho-historical insight into their personal lives that might have been either a source or direct result of their views. In this final volume, Singer proceeds to look at not just the ''great men'' influence but also provides a chapter overviewing scientific contributions to our understanding of love. . . . Singer''s work is a significant contribution to understanding the social construction of important, abstract social and personal values. By tracing love through different historical periods through a variety of voices, Singer has created a rich history of the struggle between the ideal and the real, between the dreams of what love should provide and the reality of what relationships have been in each historical period. By personalizing the voice through psychohistorical analysis, Singer also provides insight into the shaping of ideas through the intimate struggles of the shapers."--Mark V. Chaffee, Contemporary Psychology', 'https://books.google.com/books/content?id=fKT0UeAOQGsC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Irving Singer') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Nature of Love')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Adam Smith') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Theory of Moral Sentiments', 0, 0, 0, 205, 410, DATE '2023-09-13', 'Reproduction of the original.', 'https://books.google.com/books/content?id=Dd3WEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Adam Smith') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Theory of Moral Sentiments')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Friedrich Nietzsche') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Thus Spake Zarathustra', 0, 0, 0, 1371, 2742, DATE '2011-03-15', 'The origiinal text of Thus Spoke Zarathustra by Friedrich Noetzsche', 'https://books.google.com/books/content?id=bTIaAwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Friedrich Nietzsche') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Thus Spake Zarathustra')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Friedrich Wilhelm Nietzsche') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Thus Spoke Zarathustra', 0, 4, 4, 388, 776, DATE '2005-01-01', 'A landmark work of philosophy and of literature, Thus Spoke Zarathustra is the fullest expression of Nietzche''s belief that "the object of mankind should lie in its highest individuals." In his thirtieth year Zarathustra - the archetypal Ubermensch representative of supreme passion and creativity - abandons his home for the mountains, where he lives, literally and figuratively, on a level of experience far above the conventional standards of good and evil. The exuberant, poetic testimony of Nietzche''s great messianic hero (and alter ego) is a vivid demonstration of the philosopher''s genius.', 'https://books.google.com/books/content?id=u-GNHFScLgUC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Friedrich Wilhelm Nietzsche') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Thus Spoke Zarathustra')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Ludwig Wittgenstein') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Tractatus Logico-Philosophicus', 0, 5, 1, 145, 290, DATE '2013-08-22', 'Ludwig Wittgenstein is one of the greatest and most fascinating philosophers of all time. His Tractatus Logico-Philosophicus, composed in a series of remarkable numbered propositions, was the only book he published in his lifetime. He tackles nothing less than the question of whether there is such a thing as a logically perfect language and, armed with it, what we can say about the nature of the world itself. Pushing the limits of language, logic and philosophy, the Tractatus is a brilliant, cryptic and hypnotic tour de force, exerting a major impact on twentieth-century philosophy and stirring the imagination today. With a new foreword by Ray Monk.', 'https://books.google.com/books/content?id=FQCCAAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Ludwig Wittgenstein') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Philosophy' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Tractatus Logico-Philosophicus')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Norbert Wiener') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Cybernetics Or Control and Communication in the Animal and the Machine', 0, 0, 0, 353, 706, DATE '2019-10-08', 'A classic and influential work that laid the theoretical foundations for information theory and a timely text for contemporary informations theorists and practitioners. With the influential book Cybernetics, first published in 1948, Norbert Wiener laid the theoretical foundations for the multidisciplinary field of cybernetics, the study of controlling the flow of information in systems with feedback loops, be they biological, mechanical, cognitive, or social. At the core of Wiener''s theory is the message (information), sent and responded to (feedback); the functionality of a machine, organism, or society depends on the quality of messages. Information corrupted by noise prevents homeostasis, or equilibrium. And yet Cybernetics is as philosophical as it is technical, with the first chapter devoted to Newtonian and Bergsonian time and the philosophical mixed with the technical throughout. This book brings the 1961 second edition back into print, with new forewords by Doug Hill and Sanjoy Mitter. Contemporary readers of Cybernetics will marvel at Wiener''s prescience—his warnings against “noise,” his disdain for “hucksters” and “gadget worshipers,” and his view of the mass media as the single greatest anti-homeostatic force in society. This edition of Cybernetics gives a new generation access to a classic text.', 'https://books.google.com/books/content?id=p-mvDwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Norbert Wiener') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Cybernetics Or Control and Communication in the Animal and the Machine')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('R. Keith Sawyer') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Explaining Creativity', 0, 0, 0, 363, 726, DATE '2006-01-19', 'In the last 50 years, psychologists, anthropologists, and sociologists have increasingly turned to studying creativity, so we now know more about it than ever before. However, until about a decade ago, creativity researchers focused only on highly valued activities, such as creating masterpieces in art and making highly significant discoveries in science. In Explaining Creativity, R. Keith Sawyer extends the study of creativity by examining not only these endeavors, but also movies, music videos, cartoons, video games, hypertext fiction, stage performance, business innovation, and advances in computer technology.Sawyer uses the sociocultural approach to creativity that was pioneered by Howard Becker, Mihaly Csikszentmihalyi, and Howard Gardner, allowing him to move beyond the individual to consider the social process. Taking into account the interdisciplinary nature of creativity, Sawyer integrates psychological data with anthropological research on creativity in non-Western cultures and sociological studies on the situations, contexts, and networks of creative activity. For more information, see www.explainingcreativity.com.', 'https://books.google.com/books/content?id=GlT1AgAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('R. Keith Sawyer') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Explaining Creativity')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Rory C. O''Connor') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'International Handbook of Suicide Prevention', 0, 0, 0, 947, 1894, DATE '2011-06-01', 'The International Handbook of Suicide Prevention showcases the latest cutting-edge research from the world’s leading authorities, and highlights policy and practice implications for the prevention of suicide. Brings together the world’s leading authorities on suicidal behaviour, renowned for their suicide prevention research, policy and practice Addresses the key questions of why people attempt suicide, the best interventions, treatments and care for those at risk, and the key international challenges in trying to prevent suicide Describes up-to-date, theoretically-derived and evidence-based research and practice from across the globe, which will have implications across countries, cultures and the lifespan', 'https://books.google.com/books/content?id=cz8UiXwoST0C&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Rory C. O''Connor') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('International Handbook of Suicide Prevention')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Michael White') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Medios narrativos para fines terapéuticos', 0, 0, 0, 228, 456, DATE '1993-01-01', 'Los dos grandes territorios que Epston y White exploran para nosotros en este libro son los siguientes: por un lado, el asunto de la externalizacion del problema; por otro, y consecuentemente, la variedad de formas en que podemos usar terapeuticamente la palabra escrita. De este modo, y a traves de numerosos ejemplos, el lector puede elegir entre una gran variedad de nuevas intervenciones y cosechar asi los frutos de un nuevo terreno que ya ha sido cuidadosamente arado, regado y sembrado para nosotros. Al final, Epston y White nos invitan a preguntarnos: ?como podemos hacer posible la escritura de relatos personales y colectivos que liberen y curen, cuando los relatos dominantes estan tan saturados de problemas? Al publicar este libro, los autores estan compartiendo algunos de sus descubrimientos en relacion con este interrogante. ?Cual es la disposicion del profesional a unirse a ellos en esta exploracion y a dotarse de habilidades en el uso de medios literarios para reanimar la vida de sus clientes y de sus familias?', 'https://books.google.com/books/content?id=48_2KNBkks4C&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Michael White') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Medios narrativos para fines terapéuticos')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Richard H. Thaler') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Nudge', 0, 3.5, 29, 305, 610, DATE '2008-01-01', 'Thaler and Sunstein offer a groundbreaking discussion of how to apply the science of choice to nudge people toward decisions that can improve their lives without restricting their freedom of choice.', 'https://books.google.com/books/content?id=dSJQn8egXvUC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Richard H. Thaler') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Nudge')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Edward O. Wilson') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'On Human Nature', 0, 0, 0, 292, 584, DATE '2012-10-01', 'No one who cares about the human future can afford to ignore Edward O. Wilson''s book. On Human Nature begins a new phase in the most important intellectual controversy of this generation: Is human behavior controlled by the species'' biological heritage? Does this heritage limit human destiny?', 'https://books.google.com/books/content?id=gGDMGVvvBJMC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Edward O. Wilson') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('On Human Nature')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('David Semple') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Oxford Handbook of Psychiatry', 0, 0, 0, 1008, 2016, DATE '2009-03-26', 'The book is a pocket sized guide providing detailed and comprehensive coverage of clinical psychiatry. Useful to medical trainees in psychiatry and preparing for exams. Its detail and clinical coverage mean it can continue to be used by junior psychiatric trainees and those entering individual psychiatric sub-specialties later in training.', 'https://books.google.com/books/content?id=i4Q9vm411LwC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('David Semple') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Oxford Handbook of Psychiatry')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Robert Nozick') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Philosophical Explanations', 0, 3, 1, 788, 1576, DATE '1981-01-01', 'Nozick develops new views on philosophy’s central topics and weaves them into a unified perspective. He ranges widely over philosophy’s fundamental concerns: the identity of the self, knowledge and skepticism, free will, the question of why there is something rather than nothing, the foundations of ethics, the meaning of life.', 'https://books.google.com/books/content?id=N4zH86WogYwC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Robert Nozick') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Philosophical Explanations')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('John Gottman') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Raising An Emotionally Intelligent Child', 0, 0, 0, 100, 200, DATE '1998-08-12', 'Raising an Emotionally Intelligent Child is John Gottman’s groundbreaking guide to teaching children to understand and regulate their emotional world. Intelligence That Comes from the Heart Every parent knows the importance of equipping children with the intellectual skills they need to succeed in school and life. But children also need to master their emotions. Raising an Emotionally Intelligent Child is a guide to teaching children to understand and regulate their emotional world. And as acclaimed psychologist and researcher John Gottman shows, once they master this important life skill, emotionally intelligent children will enjoy increased self-confidence, greater physical health, better performance in school, and healthier social relationships. Raising an Emotionally Intelligent Child will equip parents with a five-step “emotion coaching” process that teaches how to: -Be aware of a child''s emotions -Recognize emotional expression as an opportunity for intimacy and teaching -Listen empathetically and validate a child''s feelings -Label emotions in words a child can understand -Help a child come up with an appropriate way to solve a problem or deal with an upsetting issue or situation Written for parents of children of all ages, Raising an Emotionally Intelligent Child will enrich the bonds between parent and child and contribute immeasurably to the development of a generation of emotionally healthy adults.', '/book-service/book-covers/default-book-cover.svg', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('John Gottman') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Raising An Emotionally Intelligent Child')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Sigmund Freud') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Reflections on War and Death', 0, 5, 1, 88, 176, DATE '1918-01-01', '', 'https://books.google.com/books/content?id=lcAVAAAAYAAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Sigmund Freud') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Reflections on War and Death')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Jean Lave') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Situated Learning', 0, 4.5, 7, 144, 288, DATE '1991-09-27', 'In this important theoretical treatist, the authors push forward the notion of situated learning - that learning is fundamentally a social process.', 'https://books.google.com/books/content?id=CAVIOrW3vYAC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Jean Lave') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Situated Learning')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Alain De Botton') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Status Anxiety', 0, 0, 0, 338, 676, DATE '2004-01-01', 'With characteristic originality, lucidity, and lan, de Botton addresses the anxieties that seem inextricably embedded in our pursuit of success and status, and explores what, if anything, we can do about them.', 'https://books.google.com/books/content?id=eYfZAAAAIAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Alain De Botton') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Status Anxiety')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Theodor Adorno') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Authoritarian Personality', 0, 0, 0, 1073, 2146, DATE '2019-08-27', 'This hugely influential study on the psychology of authoritarianism was written in answer to Hitler’s Germany—and now rings more relevant than ever as fascism and anti-Semitism sweep across America. What makes a fascist? Are there character traits that make someone more likely to vote for the far right? The Authoritarian Personality is not only one of the most significant works of social psychology ever written, it also marks a milestone in the development of Adorno’s thought, showing him grappling with the problem of fascism and the reasons for Europe’s turn to reaction. Over half a century later, and with the rise of right-wing populism and the reemergence of the far-right in recent years, this hugely influential study remains as insightful and relevant as ever. This new edition includes an introduction by Frankfurt School scholar Peter E. Gordon and contains the first-ever publication of Adorno’s subsequent critical notes on the project. “Adorno and his colleagues could easily have been describing Alex Jones’s paranoid InfoWars rants or the racist views expressed by many Trump supporters.” —Molly Worthen, New York Times', 'https://books.google.com/books/content?id=SUmHDwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Theodor Adorno') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Authoritarian Personality')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Charles Darwin') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Expression of the Emotions in Man and Animals', 0, 0, 0, 582, 1164, DATE '2023-10-01', 'The Expression of the Emotions in Man and Animals by Charles Darwin: The Expression of the Emotions in Man and Animals is a scientific work by Charles Darwin that examines the expression of emotions in humans and animals. Published in 1872, the book explores the evolutionary origins and universality of facial expressions, providing insights into the communication of emotions across species and shedding light on the nature of human emotions. Key Aspects of the Book "The Expression of the Emotions in Man and Animals": Evolutionary Perspective: The book applies an evolutionary framework to the study of emotions, considering their adaptive value and tracing their origins across different species. Facial Expressions: Darwin''s detailed analysis of facial expressions and their connection to specific emotions offers valuable insights into the universality and nonverbal communication of emotions. Psychology and Ethology: The Expression of the Emotions in Man and Animals bridges the fields of psychology and ethology, contributing to our understanding of emotions and their expression in both humans and animals. Charles Darwin (1809-1882) was an English naturalist, geologist, and biologist, best known for his theory of evolution and his book On the Origin of Species. The Expression of the Emotions in Man and Animals represents Darwin''s exploration of the intersection between biology, psychology, and animal behavior, highlighting his multidisciplinary approach to scientific inquiry.', 'https://books.google.com/books/content?id=tc9bDgAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Charles Darwin') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Expression of the Emotions in Man and Animals')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Sigmund Freud') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Interpretation Of Dreams', 0, 0, 0, 478, 956, DATE '1915-01-01', '', 'https://books.google.com/books/content?id=V1eNXAzSRZwC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Sigmund Freud') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Interpretation Of Dreams')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Charles Duhigg') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Power of Habit', 0, 0, 0, 100, 200, DATE '2014-01-07', 'NEW YORK TIMES BESTSELLER • This instant classic explores how we can change our lives by changing our habits. NAMED ONE OF THE BEST BOOKS OF THE YEAR BY The Wall Street Journal • Financial Times In The Power of Habit, award-winning business reporter Charles Duhigg takes us to the thrilling edge of scientific discoveries that explain why habits exist and how they can be changed. Distilling vast amounts of information into engrossing narratives that take us from the boardrooms of Procter & Gamble to the sidelines of the NFL to the front lines of the civil rights movement, Duhigg presents a whole new understanding of human nature and its potential. At its core, The Power of Habit contains an exhilarating argument: The key to exercising regularly, losing weight, being more productive, and achieving success is understanding how habits work. As Duhigg shows, by harnessing this new science, we can transform our businesses, our communities, and our lives. With a new Afterword by the author “Sharp, provocative, and useful.”—Jim Collins “Few [books] become essential manuals for business and living. The Power of Habit is an exception. Charles Duhigg not only explains how habits are formed but how to kick bad ones and hang on to the good.”—Financial Times “A flat-out great read.”—David Allen, bestselling author of Getting Things Done: The Art of Stress-Free Productivity “You’ll never look at yourself, your organization, or your world quite the same way.”—Daniel H. Pink, bestselling author of Drive and A Whole New Mind “Entertaining . . . enjoyable . . . fascinating . . . a serious look at the science of habit formation and change.”—The New York Times Book Review', 'https://books.google.com/books/content?id=syiPEAAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Charles Duhigg') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Power of Habit')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('William James') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Principles of Psychology', 0, 0, 0, 720, 1440, DATE '1890-01-01', '', 'https://books.google.com/books/content?id=HRwuAAAAIAAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('William James') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Principles of Psychology')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('William James') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Principles of Psychology (Vol. 1&2)', 0, 0, 0, 1335, 2670, DATE '2023-12-15', 'In "The Principles of Psychology" (Vol. 1 & 2), William James embarks on an ambitious exploration of the human mind, intertwining the emerging fields of psychology and philosophy. Written with a distinctive clarity and a conversational style that invites readers to ponder deep questions, James delves into topics such as consciousness, emotion, and habit, while advocating for a pragmatic approach to psychological inquiry. This seminal work serves as a cornerstone in the establishment of psychology as a rigorous, scientific discipline, situating itself within the rich intellectual currents of late 19th-century American thought, particularly influenced by pragmatism and functionalism. William James, often regarded as the father of American psychology, drew upon his extensive background in philosophy and physiology to pen this comprehensive treatise. His personal interest in the workings of the mind, coupled with his conviction that psychology should address practical life issues, propelled him to synthesize various schools of thought, aligning them with lived experiences. Influenced by his contemporaries and his own introspections, James''s views on the plasticity of the mind and the importance of individual experience were groundbreaking. This work is essential for any reader interested in the foundations of psychology, offering profound insights that remain relevant today. Its engaging prose and insightful analyses make it a must-read for scholars, students, and anyone intrigued by the complexity of human thought and behavior. In this enriched edition, we have carefully created added value for your reading experience: - A succinct Introduction situates the work''s timeless appeal and themes. - The Synopsis outlines the central plot, highlighting key developments without spoiling critical twists. - A detailed Historical Context immerses you in the era''s events and influences that shaped the writing. - An Author Biography reveals milestones in the author''s life, illuminating the personal insights behind the text. - A thorough Analysis dissects symbols, motifs, and character arcs to unearth underlying meanings. - Reflection questions prompt you to engage personally with the work''s messages, connecting them to modern life. - Hand‐picked Memorable Quotes shine a spotlight on moments of literary brilliance. - Interactive footnotes clarify unusual references, historical allusions, and archaic phrases for an effortless, more informed read.', 'https://books.google.com/books/content?id=FSzmEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('William James') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Principles of Psychology (Vol. 1&2)')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Wallace D. Wattles') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Science of Getting Rich', 0, 0, 0, 74, 148, DATE '2007-12-01', '', 'https://books.google.com/books/content?id=r_gsofmbgqwC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Wallace D. Wattles') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Science of Getting Rich')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('James R. Flynn') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'What Is Intelligence?', 0, 0, 0, 100, 200, DATE '2009-03-23', 'Professor James Flynn is one of the most creative and influential psychologists in the field of intelligence. The ''Flynn Effect'' refers to the massive increase in IQ test scores over the course of the twentieth century and the term was coined to recognize Professor Flynn''s central role in measuring and analyzing these gains. For over twenty years, psychologists have struggled to understand the implications of IQ gains. Do they mean that each generation is more intelligent than the last? Do they suggest how each of us can enhance our own intelligence? Professor Flynn is finally ready to give his own views. He asks what intelligence really is and gives a surprising and illuminating answer. This book bridges the gulf that separates our minds from those of our ancestors a century ago. It is a fascinating and unique book that makes an important contribution to our understanding of human intelligence.', '/book-service/book-covers/default-book-cover.svg', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('James R. Flynn') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Psychology' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('What Is Intelligence?')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Johanna Lindsey') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'A Loving Scoundrel', 0, 0, 0, 448, 896, DATE '2022-05-24', 'When Jeremy Malory hires Danny, a young woman who grew up on London''s streets disguised as a boy, as his upstairs maid, he secretly intends to make her his mistress. But Danny surprises him with her dreams of becoming a refined lady and a gentleman''s wife. As she transforms from urchin to elegant beauty before Jeremy''s eyes, she unwittingly captivates the charming scoundrel. Now high society tongues are wagging: Who is this mysterious newcomer, and what is the truth about her past? No matter that a lifelong adversary will go to any lengths to ensure Danny''s downfall, Jeremy, who vowed never to succumb to matrimony, finds his resolve weakening as he pursues a woman whose strong, passionate nature rivals his own and promises the kind of challenge a Malory man can''t resist.', 'https://books.google.com/books/content?id=K19wEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Johanna Lindsey') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('A Loving Scoundrel')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Johanna Lindsey') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'A Man to Call My Own', 0, 0, 0, 465, 930, DATE '2004-04-01', 'Charismatic twins Amanda and Marlan Laton, sent to live with their aunt on a sprawling 1870s Texas ranch, find themselves competing for the love of cowboy neighbor Chad Kinkaid.', 'https://books.google.com/books/content?id=ZaBBAAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Johanna Lindsey') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('A Man to Call My Own')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Roald Dahl') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Esio Trot', 0, 0, 0, 100, 200, DATE '2008-01-01', '', 'https://books.google.com/books/content?id=2XiUNAEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Roald Dahl') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Esio Trot')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Charlotte Brontë') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Jane Eyre', 0, 0, 0, 100, 200, DATE '2024-01-01', '', '/book-service/book-covers/default-book-cover.svg', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Charlotte Brontë') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Jane Eyre')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Santa Montefiore') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Last Voyage of the Valentina', 0, 0, 0, 417, 834, DATE '2006-05-23', '"Originally published in Great Britain in 2005 by Hodder and Stoughton"--T.p. verso.', 'https://books.google.com/books/content?id=uycf7ReHlYYC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Santa Montefiore') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Last Voyage of the Valentina')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Jane Austen') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Mansfield Park', 0, 0, 0, 532, 1064, DATE '2001-04-03', 'Mansfield Park is Jane Austen’s darkest, and most complex novel. In contrast to the confident and vivacious heroines of Emma and Pride and Prejudice, its central character, Fanny Price, is a shy and vulnerable poor relation who finds the courage to stand up for her principles and desires. Fanny comes to live at Mansfield Park, the home of the wealthy Bertram family, and of Fanny’s aunt, Lady Bertram. Though the family impresses upon Fanny her inferior status, she finds a friend in Edmund, the younger brother. Mansfield Park explores important issues such as slavery (the source of the Bertrams’ wealth), the oppressive nature of idealized femininity, and women’s education. This edition sheds light on these and other issues through its insightful introduction and wide-ranging appendices of contemporary documents.', 'https://books.google.com/books/content?id=fKYlFg0SbPkC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Jane Austen') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Mansfield Park')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Johanna Lindsey') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Marriage Most Scandalous', 0, 0, 0, 454, 908, DATE '2006-05-01', 'Set in Regency-era England, this latest historical romance by a "New York Times" bestselling author is the story of a spunky aristocratic lady and a brooding mercenary whose services come at a price.', 'https://books.google.com/books/content?id=U3PytoGF7H0C&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Johanna Lindsey') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Marriage Most Scandalous')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Jojo Moyes') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Me Before You (Movie Tie-In)', 0, 0, 0, 402, 804, DATE '2016-04-26', 'USA Today''s top 100 books to read while stuck at home social distancing From the #1 New York Times bestselling author of The Giver of Stars, discover the love story that captured over 20 million hearts in Me Before You, After You, and Still Me. They had nothing in common until love gave them everything to lose . . . Louisa Clark is an ordinary girl living an exceedingly ordinary life—steady boyfriend, close family—who has barely been farther afield than their tiny village. She takes a badly needed job working for ex–Master of the Universe Will Traynor, who is wheelchair bound after an accident. Will has always lived a huge life—big deals, extreme sports, worldwide travel—and now he’s pretty sure he cannot live the way he is. Will is acerbic, moody, bossy—but Lou refuses to treat him with kid gloves, and soon his happiness means more to her than she expected. When she learns that Will has shocking plans of his own, she sets out to show him that life is still worth living. A Love Story for this generation and perfect for fans of John Green’s The Fault in Our Stars, Me Before You brings to life two people who couldn’t have less in common—a heartbreakingly romantic novel that asks, What do you do when making the person you love happy also means breaking your own heart?', 'https://books.google.com/books/content?id=XEACDAAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Jojo Moyes') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Me Before You (Movie Tie-In)')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Jane Austen') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Northanger Abbey', 0, 3, 1, 630, 1260, DATE '1882-01-01', '"Jane Austen is a genius, and "Northanger Abbey" is hugely underrated." --Martin Amis Catherine Morland is a young girl with a very active imagination. Her naivety and love of sensational novels lead her to approach the fashionable social scene in Bath and her stay at nearby Northanger Abbey with preconceptions that have embarrassing and entertaining consequences.', 'https://books.google.com/books/content?id=MfG-bSaIH0IC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Jane Austen') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Northanger Abbey')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Nora Roberts') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Northern Lights', 0, 0, 0, 852, 1704, DATE '2004-01-01', 'Nora Robets flies us into Lunacy, Alaska, population 506, and into a colorful, compelling new novel about two lonely souls who find love - and redemption.', 'https://books.google.com/books/content?id=RvugDLP2U_oC&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Nora Roberts') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Northern Lights')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Jane Austen') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Pride and Prejudice', 0, 4, 359, 448, 896, DATE '1918-01-01', 'Austen’s most celebrated novel tells the story of Elizabeth Bennet, a bright, lively young woman with four sisters, and a mother determined to marry them to wealthy men. At a party near the Bennets’ home in the English countryside, Elizabeth meets the wealthy, proud Fitzwilliam Darcy. Elizabeth initially finds Darcy haughty and intolerable, but circumstances continue to unite the pair. Mr. Darcy finds himself captivated by Elizabeth’s wit and candor, while her reservations about his character slowly vanish. The story is as much a social critique as it is a love story, and the prose crackles with Austen’s wry wit.', 'https://books.google.com/books/content?id=s1gVAAAAYAAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Jane Austen') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Pride and Prejudice')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Danielle Steel') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Second Chance', 0, 0, 0, 338, 676, DATE '2001-01-01', 'A free-wheeling NYC high fashion magazine editor falls for a conservative widower with two children.', 'https://books.google.com/books/content?id=Ytdp84ikMIgC&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Danielle Steel') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Second Chance')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Jane Austen') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Sense and Sensibility', 0, 5, 4, 372, 744, DATE '1833-01-01', '', 'https://books.google.com/books/content?id=bcUNAAAAQAAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Jane Austen') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Sense and Sensibility')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Judith McNaught') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Simple Gifts', 0, 0, 0, 100, 200, DATE '2002-01-01', 'Bestselling authors each provide two Christmas tales.', 'https://books.google.com/books/content?id=p3B5PwAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Judith McNaught') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Simple Gifts')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('David Herbert Lawrence') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Sons and Lovers', 0, 0, 0, 606, 1212, DATE '2005-01-01', 'Lawrence''s first major novel was also the first in the English language to explore ordinary working-class life from the inside. No writer before or since has written so well about the intimacies enforced by a tightly-knit mining community and by a family where feelings are never hidden for long.When the marriage between Walter Morel and his sensitive, high-minded wife begins to break down, the bitterness of their frustration seeps into their children''s lives. Their second son, Paul, craves the warmth of family and community, but knows that he must sacrifice everything in the struggle for independence if he is not to repeat his parents'' failure.Lawrence''s powerful description of Paul''s single-minded efforts to define himself sexually and emotionally through relationships with two women - the innocent, old-fashioned Miriam Leivers and the experienced, provocatively modern Clara Dawes - makes this a novel as much for the beginning of the twenty-first century as it was for the beginning of the twentieth.', 'https://books.google.com/books/content?id=5k7M8Uj1vWcC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('David Herbert Lawrence') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Sons and Lovers')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Danielle Steel') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Special Delivery', 0, 0, 0, 100, 200, DATE '1999-01-01', 'The playboy owner of a successful Beverly Hills boutique, Jack Watson is unexpectedly drawn to Amanda Robbins, the widowed mother of his grown son''s wife, in a story of two mismatched, middle-aged people who find happiness and romance despite the confusion, obstacles, and opposition around them.', 'https://books.google.com/books/content?id=kiqWPwAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Danielle Steel') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Special Delivery')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Danielle Steel') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Sunset in St. Tropez', 0, 4, 2, 248, 496, DATE '2002-01-01', 'Taking a vacation together to grieve over the death of one of their group, five friends are dismayed by the ramshackle mansion they find instead of the garden villa they expected, and the unexpected appearance of the new girlfriend of the widowed husband.', 'https://books.google.com/books/content?id=LUVbAAAAMAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Danielle Steel') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Sunset in St. Tropez')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Isabel Allende') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Japanese Lover', 0, 0, 0, 336, 672, DATE '2015-11-03', 'House of the Spirits, The Japanese Lover is a profoundly moving tribute to the constancy of the human heart in a world of unceasing change"--', 'https://books.google.com/books/content?id=LITRCgAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Isabel Allende') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Japanese Lover')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Danielle Steel') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Toxic Bachelors', 0, 5, 1, 344, 688, DATE '2005-01-01', 'Three daunting bachelors embark on a journey to the Mediterranean where they face women who challenge their deepest relationship phobias, sparking big changes in the once-carefree trio that just might put an end to their carousing days.', 'https://books.google.com/books/content?id=9vVlAAAAMAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Danielle Steel') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Toxic Bachelors')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Emily Bront?e') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Wuthering Heights', 0, 0, 0, 100, 200, DATE '1997-01-01', '', '/book-service/book-covers/default-book-cover.svg', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Emily Bront?e') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Romantic' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Wuthering Heights')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Stephen D. Fairbanks') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Science Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Cloning', 0, 0, 0, 252, 504, DATE '2004-01-01', 'The terms ''recombinant DNA technology'', ''DNA cloning'', ''molecular cloning'' or ''gene cloning'' all refer to the same process: the transfer of a DNA fragment of interest from one organism to a self-replicating genetic element such as a bacterial plasmid. The DNA of interest can then be propagated in a foreign host cell. This technology has been around since the 1970s, and it has become a common practice in molecular biology labs today. Reproductive cloning is a technology used to generate an animal that has the same nuclear DNA as another currently or previously existing animal. Dolly was created by reproductive cloning technology. In a process called ''somatic cell nuclear transfer'' (SCNT), scientists transfer genetic material from the nucleus of a donor adult cell to an egg whose nucleus, and thus its genetic material, has been removed. The reconstructed egg containing the DNA from a donor cell must be treated with chemicals or electric current in order to stimulate cell division. Once the cloned embryo reaches a suitable stage, it is transferred to the uterus of a female host where it continues to develop until birth. Therapeutic cloning, also called "embryo cloning," is the production of human embryos for use in research. The goal of this process is not to create cloned human beings, but rather to harvest stem cells that can be used to study human development and to treat disease. Stem cells are important to biomedical researchers because they can be used to generate virtually any type of specialised cell in the human body. This new book presents an up-to-date Chronology of Cloning along with current and selected abstracts dealing with cloning as well as a guide to books on the topic. Access to the abstract and books sections is provided by title, subject and author indexes.', 'https://books.google.com/books/content?id=jBWhaabgD3gC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Stephen D. Fairbanks') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Science Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Cloning')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Royal Society of Canada') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Science Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Déliberations Et Mémoires de la Société Royale Du Canada', 0, 0, 0, 1092, 2184, DATE '1896-01-01', '', 'https://books.google.com/books/content?id=-mIXAQAAIAAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Royal Society of Canada') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Science Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Déliberations Et Mémoires de la Société Royale Du Canada')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Valentina Cuccio') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Science Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Experimental Approaches to Pragmatics', 0, 0, 0, 287, 574, DATE '2022-05-06', '', 'https://books.google.com/books/content?id=h05uEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Valentina Cuccio') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Science Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Experimental Approaches to Pragmatics')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Carnegie Library of Pittsburgh') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Science Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Men of Science and Industry', 0, 0, 0, 206, 412, DATE '1915-01-01', '', 'https://books.google.com/books/content?id=0PNAAQAAIAAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Carnegie Library of Pittsburgh') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Science Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Men of Science and Industry')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Roman Frigg') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Science Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Modelling Nature: An Opinionated Introduction to Scientific Representation', 0, 0, 0, 250, 500, DATE '2020-09-02', 'This monograph offers a critical introduction to current theories of how scientific models represent their target systems. Representation is important because it allows scientists to study a model to discover features of reality. The authors provide a map of the conceptual landscape surrounding the issue of scientific representation, arguing that it consists of multiple intertwined problems. They provide an encyclopaedic overview of existing attempts to answer these questions, and they assess their strengths and weaknesses. The book also presents a comprehensive statement of their alternative proposal, the DEKI account of representation, which they have developed over the last few years. They show how the account works in the case of material as well as non-material models; how it accommodates the use of mathematics in scientific modelling; and how it sheds light on the relation between representation in science and art. The issue of representation has generated a sizeable literature, which has been growing fast in particular over the last decade. This makes it hard for novices to get a handle on the topic because so far there is no book-length introduction that would guide them through the discussion. Likewise, researchers may require a comprehensive review that they can refer to for critical evaluations. This book meets the needs of both groups.', 'https://books.google.com/books/content?id=wPD6DwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Roman Frigg') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Science Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Modelling Nature: An Opinionated Introduction to Scientific Representation')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Alejandro Cassini') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Science Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Models and Idealizations in Science', 0, 0, 0, 100, 200, DATE '2021-01-01', 'This book provides both an introduction to the philosophy of scientific modeling and a contribution to the discussion and clarification of two recent philosophical conceptions of models: artifactualism and fictionalism. These can be viewed as different stances concerning the standard representationalist account of scientific models. By better understanding these two alternative views, readers will gain a deeper insight into what a model is as well as how models function in different sciences. Fictionalism has been a traditional epistemological stance related to antirealist construals of laws and theories, such as instrumentalism and inferentialism. By contrast, the more recent fictional view of models holds that scientific models must be conceived of as the same kind of entities as literary characters and places. This approach is essentially an answer to the ontological question concerning the nature of models, which in principle is not incompatible with a representationalist account of the function of models. The artifactual view of models is an approach according to which scientific models are epistemic artifacts, whose main function is not to represent the phenomena but rather to provide epistemic access to them. It can be conceived of as a non-representationalist and pragmatic account of modeling, which does not intend to focus on the ontology of models but rather on the ways they are built and used for different purposes. The different essays address questions such as the artifactual view of idealization, the use of information theory to elucidate the concepts of abstraction and idealization, the deidealization of models, the nature of scientific fictions, the structural account of representation and the ontological status of structures, the role of surrogative reasoning with models, and the use of models for explaining and predicting physical phenomena.', '/book-service/book-covers/default-book-cover.svg', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Alejandro Cassini') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Science Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Models and Idealizations in Science')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Royal Institution of Great Britain') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Science Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Notices of the Proceedings', 0, 0, 0, 542, 1084, DATE '1884-01-01', '', 'https://books.google.com/books/content?id=biZfyi-I2CYC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Royal Institution of Great Britain') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Science Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Notices of the Proceedings')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Brian M. Stableford') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Science Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Science Fact and Science Fiction', 0, 5, 1, 758, 1516, DATE '2006-01-01', 'Publisher description', 'https://books.google.com/books/content?id=uefwmdROKTAC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Brian M. Stableford') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Science Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Science Fact and Science Fiction')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Eugene Morlock Emme') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Science Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Science Fiction and Space Futures', 0, 0, 0, 292, 584, DATE '1982-01-01', '', 'https://books.google.com/books/content?id=jHNQAAAAMAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Eugene Morlock Emme') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Science Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Science Fiction and Space Futures')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Paul Carus') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Science Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Monist', 0, 0, 0, 100, 200, DATE '2025-05-22', '"The Monist" is a journal dedicated to the exploration of philosophical unity and the interconnectedness of all things. Founded with the aim of fostering a deeper understanding of monistic thought, this volume presents a collection of essays and articles delving into various aspects of philosophy, logic, and metaphysics. Originally published in the late 19th and early 20th centuries, "The Monist" features contributions from leading thinkers of the time, providing valuable insights into the intellectual landscape of the era. Edited by notable figures such as Edward C. Hegeler and Paul Carus, this journal offers a rich and enduring exploration of monistic principles and their implications for understanding the nature of reality. This work has been selected by scholars as being culturally important, and is part of the knowledge base of civilization as we know it. This work was reproduced from the original artifact, and remains as true to the original work as possible. Therefore, you will see the original copyright references, library stamps (as most of these works have been housed in our most important libraries around the world), and other notations in the work. This work is in the public domain in the United States of America, and possibly other nations. Within the United States, you may freely copy and distribute this work, as no entity (individual or corporate) has a copyright on the body of the work. As a reproduction of a historical artifact, this work may contain missing or blurred pages, poor pictures, errant marks, etc. Scholars believe, and we concur, that this work is important enough to be preserved, reproduced, and made generally available to the public. We appreciate your support of the preservation process, and thank you for being an important part of keeping this knowledge alive and relevant.', 'https://books.google.com/books/content?id=3EB90QEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Paul Carus') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Science Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Monist')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Albert John Walford') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Science Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Walford''s Guide to Reference Material: Generalia, language and literature, the arts', 0, 0, 0, 1212, 2424, DATE '1998-01-01', 'From its first edition the purpose of Walford has been to identify and evaluate the widest possible range of reference materials. No rigid definition of reference is applied. In addition to the expected bibliographies, indexes, dictionaries, encyclopaedias, and directories, a number of important textbooks and manuals of general practice are included. While the majority of the items are books, Walford is a guide to reference material. Thus periodical articles, microforms, online and CD-ROM sources are all represented. In this volume a particular effort has been made to improve coverage of the latter two categories.', 'https://books.google.com/books/content?id=XlfhAAAAMAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Albert John Walford') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Science Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Walford''s Guide to Reference Material: Generalia, language and literature, the arts')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Lisa Zunshine') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Science Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Why We Read Fiction', 0, 3, 1, 210, 420, DATE '2006-01-01', 'Why We Read Fiction offers a lucid overview of the most exciting area of research in contemporary cognitive psychology known as "Theory of Mind" and discusses its implications for literary studies. It covers a broad range of fictional narratives, from Richardson s Clarissa, Dostoyevski''s Crime and Punishment, and Austen s Pride and Prejudice to Woolf''s Mrs. Dalloway, Nabokov''s Lolita, and Hammett s The Maltese Falcon. Zunshine''s surprising new interpretations of well-known literary texts and popular cultural representations constantly prod her readers to rethink their own interest in fictional narrative. Written for a general audience, this study provides a jargon-free introduction to the rapidly growing interdisciplinary field known as cognitive approaches to literature and culture.', 'https://books.google.com/books/content?id=BtdB2CcXazEC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Lisa Zunshine') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Science Fiction' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Why We Read Fiction')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Richard B. Stuart') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Self-Help' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Act Thin, Stay Thin', 0, 0, 0, 292, 584, DATE '1987-01-01', '', 'https://books.google.com/books/content?id=53t__AW78d4C&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Richard B. Stuart') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Self-Help' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Act Thin, Stay Thin')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Leon Harold Warshay') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Self-Help' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Breadth of Perspective, Culture Contact, and Self', 0, 0, 0, 588, 1176, DATE '1959-01-01', '', 'https://books.google.com/books/content?id=krchlWLqnmUC&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Leon Harold Warshay') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Self-Help' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Breadth of Perspective, Culture Contact, and Self')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Rosanne du Bois Brouwer') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Self-Help' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Constellations of Life Satisfaction in Three Cohorts of Women', 0, 0, 0, 210, 420, DATE '1995-01-01', '', 'https://books.google.com/books/content?id=OmEWB3y3iqUC&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Rosanne du Bois Brouwer') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Self-Help' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Constellations of Life Satisfaction in Three Cohorts of Women')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Frances Upham') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Self-Help' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Ego Analysis in the Helping Professions', 0, 0, 0, 280, 560, DATE '1973-01-01', '', 'https://books.google.com/books/content?id=OAVHAAAAMAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Frances Upham') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Self-Help' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Ego Analysis in the Helping Professions')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('G. Sreeramulu') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Self-Help' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Empowerment of Women Through Self Help Groups', 0, 0, 0, 334, 668, DATE '2006-01-01', 'The book is an in-depth study of Empowerment of Women Through Self Help Groups. It covers the problems and perspectives of Self Help Groups and suggest several measures. The study has evaluated the implementation of several schemes in Anantapur District in particular and in Andhra Pradesh in general such as rearing goats, dairying, petty business activities, making of soft toys and so on. The findings are very much encouraging, such as Women are now managing their families, Panchayat Raj Institutions, are able to concentrate on their children s education and health. Contents include: Introduction, Public Policy Theoretical Perspectives, Evaluation, Aims and Objectctives of Self Help Groups in Anantapur District, Socio-Economic Background of the Sample Study, Problems and perspectives of Self Help Groups, Performance of Self Help Groups and Conclusion. This outstanding Text-cum-Reference book will be of great use to Scholars, Administrators, Planners, Policy-makers, Statesmen and Students of Political Science, Economics, Sociology, Commerce and Women Studites.', 'https://books.google.com/books/content?id=Mmtn9-YpF6EC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('G. Sreeramulu') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Self-Help' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Empowerment of Women Through Self Help Groups')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Chiara Thumiger') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Self-Help' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Hidden Paths', 0, 0, 0, 292, 584, DATE '2007-01-01', 'Hidden paths analyses the representation of character in Greek tragedy, focusing on one of the most important and controversial theatre plays of all times the Bacchae. Euripides'' last play has always been a favourite, enjoying an enormous success for centuries on and off the stage. This book argues that in the representation of characters in the play we can find a development in the view of self and representation of man. This development, which is also to be partly traced in the works of Sophocles and in earlier plays by Euripides, finds a fuller expression in the Bacchae and culminates in the catastrophe of ignorance and incommunicability which has Pentheus at its centre. The construction of character in the text and the view of self which it entails are explored through a meticulous analysis of keywords, while verbal usage, imagery and style are exposed as the very ''stuff'' of characterisation. The book uncovers the ''hidden paths'' along which human life is experienced in the play and through which human characterisation materializes from the fabric of the text.', 'https://books.google.com/books/content?id=BkxoAAAAMAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Chiara Thumiger') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Self-Help' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Hidden Paths')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Hendrikus Laan') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Self-Help' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'In an African Direction', 0, 0, 0, 286, 572, DATE '1999-01-01', '', 'https://books.google.com/books/content?id=1BC5AAAAIAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Hendrikus Laan') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Self-Help' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('In an African Direction')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Frances M. Epps') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Self-Help' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Inquiring about Myself', 0, 0, 0, 390, 780, DATE '1972-01-01', '', 'https://books.google.com/books/content?id=7kJMAQAAIAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Frances M. Epps') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Self-Help' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Inquiring about Myself')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Jane Loevinger') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Self-Help' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Measuring Ego Development', 0, 0, 0, 490, 980, DATE '1970-01-01', 'Vol.2 by Jane Loevinger, Ruth Wessler and Carolyn Redmore.', 'https://books.google.com/books/content?id=XkdqAAAAMAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Jane Loevinger') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Self-Help' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Measuring Ego Development')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Elizabeth Irene Price') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Self-Help' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Midlife Mothers in Transition', 0, 0, 0, 318, 636, DATE '1994-01-01', '', 'https://books.google.com/books/content?id=KmeO-N1ES9AC&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Elizabeth Irene Price') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Self-Help' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Midlife Mothers in Transition')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Kathryn Allen Rabuzzi') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Self-Help' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Motherself', 0, 0, 0, 264, 528, DATE '1988-01-01', 'In Western cultures, the central image of the spiritual quest for selfhood is that of the mythic, male, hero. A male hero, however, represents the quest for selfhood incompletely and awkwardly for women. In this provocative work, Kathryn Rabuzzi focuses on a different image -- that of the mother. For women seeking spiritual fulfillment of self, Rabuzzi points out the way of the mother, replacing the androcentric myths of the West with gynocentric myths based on the archetypal model of the Goddess. In contrast to the selfhood for which the hero quests, "motherself" is the name for what women achieve when they follow the way of the mother. Rabuzzi defines that way with imagination and lucidity; her work provides an invaluable guide to all women struggling to articulate their religious experience in new terms.', 'https://books.google.com/books/content?id=6nw6AAAAMAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Kathryn Allen Rabuzzi') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Self-Help' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Motherself')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Jane Cary Peck') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Self-Help' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'Self and Family', 0, 0, 0, 124, 248, DATE '1984-01-01', '', 'https://books.google.com/books/content?id=45jlDZlhT4sC&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Jane Cary Peck') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Self-Help' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('Self and Family')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Stanley I. Greenspan') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Self-Help' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Development of the Ego', 0, 0, 0, 390, 780, DATE '1989-01-01', 'On the developmental stages of the ego, beginning in early infancy, from the perspectives of tasks and challenges, internal self and object representations, and ego mechanisms and functions. Annotation copyrighted by Book News, Inc., Portland, OR', 'https://books.google.com/books/content?id=4IvL1DHwlycC&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Stanley I. Greenspan') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Self-Help' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Development of the Ego')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Mary Lee Zawadski') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Self-Help' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Magic Within', 0, 0, 0, 144, 288, DATE '1990-01-01', '', 'https://books.google.com/books/content?id=8QoNAQAAMAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Mary Lee Zawadski') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Self-Help' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Magic Within')
      AND b.marked_as_deleted = FALSE
  );

INSERT INTO public.book
(author_id, category_id, name, price, rate, users_rate_count, pages_number, reading_duration, publish_date, description, image_url, total_copies, available_copies, created_date, modified_date, created_by, modified_by, marked_as_deleted)
SELECT (SELECT id FROM public.author WHERE lower(name) = lower('Kirk J. Schneider') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), (SELECT id FROM public.book_category WHERE name = 'Self-Help' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1), 'The Paradoxical Self', 0, 0, 0, 248, 496, DATE '1990-03-21', 'Toward an understanding of our contradictory nature.', 'https://books.google.com/books/content?id=BRuCAAAAIAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'list-import', 'list-import', FALSE
WHERE (SELECT id FROM public.author WHERE lower(name) = lower('Kirk J. Schneider') AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND (SELECT id FROM public.book_category WHERE name = 'Self-Help' AND marked_as_deleted = FALSE ORDER BY id LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.book b
    WHERE lower(b.name) = lower('The Paradoxical Self')
      AND b.marked_as_deleted = FALSE
  );

COMMIT;

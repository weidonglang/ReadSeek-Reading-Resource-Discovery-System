-- liquibase formatted sql

-- changeset codex:20260401_fix_invalid_seed_book_images

UPDATE public.book
SET image_url = '/book-service/book-covers/default-book-cover.svg',
    modified_date = CURRENT_TIMESTAMP,
    modified_by = 'codex'
WHERE image_url LIKE 'https://example.com/books/%'
  AND name IN (
    'The Three-Body Problem',
    'The Dark Forest',
    'Deaths End',
    'Twenty Thousand Leagues Under the Seas',
    'The Shining',
    'IT',
    'Pride and Prejudice',
    'Sense and Sensibility',
    'Sapiens',
    'Leonardo da Vinci',
    'Around the World in Eighty Days',
    'Journey to the Center of the Earth'
  );

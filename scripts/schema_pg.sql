DROP SCHEMA IF EXISTS shakespeare CASCADE;
CREATE SCHEMA shakespeare;
SET search_path TO shakespeare, public;
CREATE TABLE work
  ( work_id    VARCHAR(32) PRIMARY KEY,
    title     VARCHAR(32) NOT NULL,
    long_title VARCHAR(64) NOT NULL,
    year      INTEGER NOT NULL,
    genre_type VARCHAR(1) NOT NULL,
    notes     TEXT,
    source    VARCHAR(16) NOT NULL,
    total_words      INTEGER NOT NULL,
    total_paragraphs INTEGER NOT NULL
  );

\copy work FROM '../opensourceshakespeare/Works.txt' WITH (FORMAT csv, QUOTE '~')

CREATE TABLE character 
  ( char_id      VARCHAR(32) PRIMARY KEY,
    char_name    VARCHAR(64) NOT NULL,
    abbrev      VARCHAR(32),
    works       VARCHAR(256) NOT NULL,
    description VARCHAR(2056),
    speech_count INTEGER NOT NULL
  );

\copy character FROM '../opensourceshakespeare/Characters.txt' WITH (FORMAT csv, QUOTE '~')

CREATE TABLE character_work
  ( char_id     VARCHAR(32) NOT NULL REFERENCES character (char_id),
    work_id     VARCHAR(32) NOT NULL REFERENCES work (work_id),
    PRIMARY KEY (char_id, work_id)
  );

INSERT INTO character_work (char_id, work_id)
SELECT char_id,
       regexp_split_to_table(works, ',')
FROM   character;

ALTER TABLE character DROP COLUMN works;

CREATE TABLE chapter 
  ( work_id         VARCHAR(32) NOT NULL REFERENCES work (work_id),
    chapter_id      INTEGER PRIMARY KEY,
    section        INTEGER NOT NULL,
    chapter        INTEGER NOT NULL,
    description    VARCHAR(256) NOT NULL
  );

\copy chapter FROM '../opensourceshakespeare/Chapters.txt' WITH (FORMAT csv, QUOTE '~')

UPDATE chapter SET description = '' WHERE description LIKE '---%';
UPDATE chapter SET description = REPLACE(description, '&#8217;','''');

CREATE TABLE paragraph
  ( work_id         VARCHAR(32) NOT NULL REFERENCES work (work_id), paragraph_id    INTEGER PRIMARY KEY NOT NULL,
    paragraph_num   INTEGER NOT NULL,
    char_id         VARCHAR(32) NOT NULL REFERENCES character (char_id),
    plain_text      TEXT NOT NULL,
    phonetic_text   TEXT NOT NULL,
    stem_text       TEXT NOT NULL,
    paragraph_type  VARCHAR(1) NOT NULL,
    section        INTEGER NOT NULL,
    chapter        INTEGER NOT NULL,
    char_count      INTEGER NOT NULL,
    word_count      INTEGER NOT NULL
  );

\copy paragraph FROM '../opensourceshakespeare/Paragraphs.txt' WITH (FORMAT csv, QUOTE '~')

CREATE TABLE wordform
  ( word_form_id     INTEGER PRIMARY KEY,
    plain_text      VARCHAR(64) NOT NULL,
    phonetic_text   VARCHAR(64) NOT NULL,
    stem_text       VARCHAR(64) NOT NULL,
    occurences     INTEGER NOT NULL
  );

\copy wordform FROM '../opensourceshakespeare/WordForms.txt' WITH (FORMAT csv, QUOTE '~')


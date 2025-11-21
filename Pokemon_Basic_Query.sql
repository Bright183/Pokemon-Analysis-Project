use pokemon_data;


-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or Blank values
-- 4. Remove Any Columns



-- Looking at the table
SELECT *
FROM pokemon_data.pokemon;


-- Copy of raw data so I can clean it
CREATE TABLE pokemon_staging
LIKE pokemon;

INSERT pokemon_staging
SELECT *
FROM pokemon;














-- Look at copied table
SELECT *
FROM pokemon_staging;








-- Clean the abilities column so it doesnt have wierd symbols
ALTER TABLE pokemon_staging 
CHANGE ï»¿abilities abilities VARCHAR(20);

-- Classification Cloumn is spelled as classfication so it needs to be fixed
ALTER TABLE pokemon_staging 
CHANGE classfication classification VARCHAR(255);



-- Removing Duplicates -> Resulted in no duplicates ------------------------------------------------------------------------------------------------------
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY pokedex_number) AS row_num
FROM pokemon_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;



-- Reorder the columns so the important info I want to see first are in the front
ALTER TABLE pokemon_staging
CHANGE pokedex_number pokedex_number VARCHAR(100) NOT NULL FIRST;

ALTER TABLE pokemon_staging
CHANGE name name VARCHAR(100) NOT NULL AFTER pokedex_number;




-- Standardize the Data ---------------------------------------------------------------------------------------------------------------------------------------
-- Gets rid of white spaces in the pokemon names and types -> Results in no names or types to trim
SELECT name, TRIM(name)
FROM pokemon_staging
WHERE name != TRIM(name);

SELECT type1, TRIM(type1)
FROM pokemon_staging
WHERE type1 != TRIM(type1);

SELECT type2, TRIM(type2)
FROM pokemon_staging
WHERE type2 != TRIM(type2);



-- Make sure the pokemon data has no weird symbols
-- Looking at Name and Classification Columns
SELECT *
FROM pokemon_staging
WHERE name <> CONVERT(name USING ASCII)
OR classification <> CONVERT(classification USING ASCII);





























use pokemon_data;

-- This data set does not include different forms of pokemon and also excludes ultra beasts

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
FROM pokemon_staging
ORDER BY pokedex_number ASC;







-- Make the pokedex_number column a int so it sorts properly
ALTER TABLE pokemon_staging
MODIFY COLUMN pokedex_number INT;

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


-- Make sure the pokemon data has no weird symbols (So it can be typable for english and prevents errors with older tools)
-- Looking at Name and Classification Columns
SELECT pokedex_number, name, classification
FROM pokemon_staging
WHERE name <> CONVERT(name USING ASCII)
OR classification <> CONVERT(classification USING ASCII);


-- Targes the names
SELECT pokedex_number, name, classification
FROM pokemon_staging
WHERE name <> CONVERT(name USING ASCII);

-- Changes the name for Flabebe without accent
UPDATE pokemon_staging
SET name = 'Flabebe'
WHERE pokedex_number = 669;


-- Targets the Classification
SELECT pokedex_number, name, classification
FROM pokemon_staging
WHERE classification <> CONVERT(classification USING ASCII);

-- Changes where Pokemon is spelt with accent
UPDATE pokemon_staging
SET classification = REPLACE(classification, 'Pokémon', 'Pokemon')
WHERE classification LIKE '%Pokémon%';

-- Change the name of Hoopa to match with its form (Unbound - Based on the stats given)
UPDATE pokemon_staging
SET name = 'Hoopa-Unbound'
WHERE pokedex_number = 720;

-- Change the name of Lycanroc to match with its form (Midnight form - Based on the stats given)
UPDATE pokemon_staging
SET name = 'Lycanroc-Midnight'
WHERE pokedex_number = 745;




-- Deal with NULL or Blank Values ----------------------------------------------------------------------------------------------------------------------------------
-- Second Typing for pokemon will be left as null because they are intentionally not supposed to have a value

-- Delete NULL rows (There were none)
DELETE FROM pokemon_staging
WHERE pokedex_number IS NULL OR name IS NULL;


-- Fixing the pokemon without height listed in the data
SELECT name, height_m
FROM pokemon_staging
WHERE height_m IS NULL;


-- Creates a temp table so I can update the heights/weight of pokemon with null values (Because these pokemon have different forms) - Height/Weight updated will be the form provided by the data
CREATE TEMPORARY TABLE null_data_temp_table(
	name varchar(100) PRIMARY KEY,
    height_m decimal(4,1),
    weight_kg decimal(5,1)
);

SELECT *
FROM null_data_temp_table;

-- Give the right heights to all the pokemon
INSERT INTO null_data_temp_table VALUES
('Exeggutor', 2.0, 120),
('Rattata', 0.3, 3.5),
('Raticate', 0.7, 18.5),
('Raichu', 0.8, 30.0),
('Sandshrew', 0.6, 12.0),
('SandSlash', 1.0, 29.5),
('Vulpix', 0.6, 9.9),
('Ninetales', 1.1, 20.0),
('Diglett', 0.2, 0.8),
('Dugtrio', 0.7, 33.3),
('Meowth', 0.4, 4.2),
('Persian', 1.0, 32.0),
('Geodude', 0.4, 20.0),
('Graveler', 1.0, 105.0),
('Golem', 1.4, 300.0),
('Grimer', 0.9, 30.0),
('Muk', 1.2, 30.0),
('Marowak', 1.0, 45.0),
('Hoopa-Unbound', 6.5, 490.0),
('Lycanroc-Midnight', 1.1, 25.0);


-- Join the tables so the heigths can be in the main table
UPDATE pokemon_staging t1
JOIN null_data_temp_table t2 ON t1.name = t2.name
SET t1.height_m = t2.height_m, t1.weight_kg = t2.weight_kg
WHERE t1.height_m AND t1.weight_kg IS NULL;

-- Deletes Temp table
DROP TEMPORARY TABLE height_null_data;



























































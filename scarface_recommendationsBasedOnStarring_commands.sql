/* change table movies and add a new columne called 
lexemesStarring of the data typ tsvector for full text search */
ALTER TABLE movies
ADD IF NOT EXISTS lexemesStarring tsvector;

/* insert tsvector value for each movie regarding Starring */
UPDATE movies
SET lexemesStarring = to_tsvector(Starring);

/* select all url from movies whith the word face
in the lexemesStarring  with the to_tsquery function - output: 0 rows */
SELECT url FROM movies
WHERE lexemesStarring @@ to_tsquery('face');

/* change table movies and add a new columne of type float4 */
ALTER TABLE movies
ADD IF NOT EXISTS rank float4;

/* have a rank for all movies compared to scarface movie
regarding lexemesStarring */
UPDATE movies
SET rank = ts_rank(lexemesStarring,plainto_tsquery(
(
SELECT Starring FROM movies WHERE url='scarface'
)
));

/* check what rank your fav. movie has - Output: 0.463 */
SELECT rank FROM movies WHERE url ='scarface';

/* creating another table with the 50 highest ranked movies, where rank
is higher then 0.05 - should be higher then result above */
CREATE TABLE recommendationsBasedOnStarringFieldSF AS
SELECT url, rank FROM movies WHERE rank > 0.05 ORDER BY rank DESC LIMIT 50;

/* creating a csv file with our results */
\copy (SELECT * FROM recommendationsBasedOnStarringFieldSF) to '/home/pi/RSL/scarface_top50recommendationsStarring.csv' WITH csv;


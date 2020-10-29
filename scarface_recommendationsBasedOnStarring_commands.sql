ALTER TABLE movies
ADD IF NOT EXISTS lexemesStarring tsvector;
/* adding a new columne, to be able to compare the Starring */ 

UPDATE movies
SET lexemesStarring = to_tsvector(Starring);
/* output: 5229 */ 

SELECT url FROM movies
WHERE lexemesStarring @@ to_tsquery('scarface');
/* output: 0 movies */ 

ALTER TABLE movies
ADD IF NOT EXISTS rank float4;
/* command included IF NOT EXISTS */

UPDATE movies
SET rank = ts_rank(lexemesStarring,plainto_tsquery(
(
SELECT Starring FROM movies WHERE url='scarface'
)
));
/* update: 5229 */

CREATE TABLE recommendationsBasedOnStarringFieldSF AS
SELECT url, rank FROM movies WHERE rank > 0.99 ORDER BY rank DESC LIMIT 50;
* Output: SELECT 0 -> only one movie with with p 0.99 -> that means, we have to set a lower treshold */

DROP TABLE recommendationsBasedOnStarringFieldSF;
/* first, delete the table that we already have */

CREATE TABLE recommendationsBasedOnStarringFieldSF AS
SELECT url, rank FROM movies WHERE rank > 0.05 ORDER BY rank DESC LIMIT 50;
/* by changing the treshold we  receive 29 results */

\copy (SELECT * FROM recommendationsBasedOnStarringFieldSF) to '/home/pi/RSL/scarface_top50recommendationsStarring.csv' WITH csv;
/* creating a csv file with your personal recommendations */


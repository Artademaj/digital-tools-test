ALTER TABLE movies
ADD IF NOT EXISTS lexemestitle tsvector;
/* adding a new columne, to be able to compare the title */ 

UPDATE movies
SET lexemestitle = to_tsvector(title);
/* output: 5229 */ 

SELECT url FROM movies
WHERE lexemestitle @@ to_tsquery('scarface');
/* output: 1 rows */ 

ALTER TABLE movies
ADD IF NOT EXISTS rank float4;
/* command included IF NOT EXISTS */

UPDATE movies
SET rank = ts_rank(lexemestitle,plainto_tsquery(
(
SELECT title FROM movies WHERE url='scarface'
)
));
/* update: 5229 */

CREATE TABLE recommendationsBasedOnTitleFieldSF AS
SELECT url, rank FROM movies WHERE rank > 0.99 ORDER BY rank DESC LIMIT 50;
/* Output: SELECT 0 -> only one movie with with p 0.99 -> that means, we have to set a lower treshold */

DROP TABLE recommendationsBasedOnTitleFieldSF;
/* first, delete the table that we already have */

CREATE TABLE recommendationsBasedOnTitleFieldSF AS
SELECT url, rank FROM movies WHERE rank > 0.05 ORDER BY rank DESC LIMIT 50;
/* by changing the treshold we receive 1 result */

DROP TABLE recommendationsBasedOnTitleFieldSF;
/* first, delete the table that we already have */

CREATE TABLE recommendationsBasedOnTitleFieldSF AS
SELECT url, rank FROM movies WHERE rank > 0.005 ORDER BY rank DESC LIMIT 50;
/* by changing the treshold still  1 result */

\copy (SELECT * FROM recommendationsBasedOnTitleFieldSF) to '/home/pi/RSL/scarface_top50recommendationsTitle.csv' WITH csv;
/* creating a csv file with your personal recommendations */


ALTER TABLE movies
ADD IF NOT EXISTS lexemestitle tsvector;
/* adding a new columne, to be able to compare the title */ 

UPDATE movies
SET lexemestitle = to_tsvector(title);
/* output: 5229 */ 

SELECT url FROM movies
WHERE lexemestitle @@ to_tsquery('dancing');
/* output: 12 rows */ 

ALTER TABLE movies
ADD IF NOT EXISTS rank float4;
/* command included IF NOT EXISTS */

UPDATE movies
SET rank = ts_rank(lexemestitle,plainto_tsquery(
(
SELECT title FROM movies WHERE url='dirty-dancing'
)
));
/* update: 5229 */

CREATE TABLE recommendationsBasedOnTitleFieldDD AS
SELECT url, rank FROM movies WHERE rank > 0.99 ORDER BY rank DESC LIMIT 50;
/* Output: SELECT 0 -> only one movie with with p 0.99 -> that means, we have to set a lower treshold */

DROP TABLE recommendationsBasedOnTitleFieldDD;
/* first, delete the table that we already have */

CREATE TABLE recommendationsBasedOnTitleFieldDD AS
SELECT url, rank FROM movies WHERE rank > 0.05 ORDER BY rank DESC LIMIT 50;
/* by changing the treshold we  receive 2 results */

\copy (SELECT * FROM recommendationsBasedOnTitleFieldDD) to '/home/pi/RSL/dirty-dancing_top50recommendationsTitle.csv' WITH csv;
/* creating a csv file with your personal recommendations */

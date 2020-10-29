ALTER TABLE movies
ADD IF NOT EXISTS lexemestitle tsvector;
/* adding a new columne, to be able to compare the title */ 

UPDATE movies
SET lexemestitle = to_tsvector(title);
/* output: 5229 */ 

SELECT url FROM movies
WHERE lexemestitle @@ to_tsquery('life');
/* output: 35 rows */ 

ALTER TABLE movies
ADD IF NOT EXISTS rank float4;
/* command included IF NOT EXISTS */

UPDATE movies
SET rank = ts_rank(lexemestitle,plainto_tsquery(
(
SELECT title FROM movies WHERE url='the-life-of-david-gale'
)
));
/* update: 5229 */

CREATE TABLE recommendationsBasedOnTitleFieldDG AS
SELECT url, rank FROM movies WHERE rank > 0.99 ORDER BY rank DESC LIMIT 50;
/* Output: SELECT 0 -> only one movie with with p 0.99 -> that means, we have to set a lower treshold */

DROP TABLE recommendationsBasedOnTitleFieldDG;
/* first, delete the table that we already have */

CREATE TABLE recommendationsBasedOnTitleFieldDG AS
SELECT url, rank FROM movies WHERE rank > 0.05 ORDER BY rank DESC LIMIT 50;
/* by changing the treshold we still have 0 results -> it does not make sense to lower. We skip the recommendations based Summary for this movie */



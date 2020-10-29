ALTER TABLE movies
ADD IF NOT EXISTS lexemesStarring tsvector;
/* adding a new columne, to be able to compare the Starring */ 

UPDATE movies
SET lexemesStarring = to_tsvector(Starring);
/* output: 5229 */ 

SELECT url FROM movies
WHERE lexemesStarring @@ to_tsquery('life');
/* output: 0 movies */ 

ALTER TABLE movies
ADD IF NOT EXISTS rank float4;
/* command included IF NOT EXISTS */

UPDATE movies
SET rank = ts_rank(lexemesStarring,plainto_tsquery(
(
SELECT Starring FROM movies WHERE url='the-life-of-david-gale'
)
));
/* update: 5229 */

CREATE TABLE recommendationsBasedOnStarringFieldDG AS
SELECT url, rank FROM movies WHERE rank > 0.99 ORDER BY rank DESC LIMIT 50;
* Output: SELECT 0 -> only one movie with with p 0.99 -> that means, we have to set a lower treshold */

DROP TABLE recommendationsBasedOnStarringFieldDG;
/* first, delete the table that we already have */

CREATE TABLE recommendationsBasedOnStarringFieldDG AS
SELECT url, rank FROM movies WHERE rank > 0.05 ORDER BY rank DESC LIMIT 50;
/* by changing the treshold we still receive 0 results -> seems that recommendations based on title make no sense */
/* creating a csv file makes no sense */



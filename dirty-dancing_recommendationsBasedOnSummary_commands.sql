ALTER TABLE movies
ADD IF NOT EXISTS lexemesSummary tsvector;
/* adding a new columne, to be able to compare the summaries */ 

UPDATE movies
SET lexemesSummary = to_tsvector(Summary);
/* output: 5229 */ 

SELECT url FROM movies
WHERE lexemesSummary @@ to_tsquery('dancing');
/* output: 75 rows */ 

ALTER TABLE movies
ADD IF NOT EXISTS rank float4;
/* comment */

UPDATE movies
SET rank = ts_rank(lexemesSummary,plainto_tsquery(
(
SELECT Summary FROM movies WHERE url='dirty-dancing'
)
));
/* update: 5229 */

CREATE TABLE recommendationsBasedOnSummaryFieldDD AS
SELECT url, rank FROM movies WHERE rank > 0.99 ORDER BY rank DESC LIMIT 50;
/* Output: SELECT 0 -> only one movie with with p 0.99 -> that means, we have to set a lower treshold */

DROP TABLE recommendationsBasedOnSummaryFieldDD;
/* first, delete the table that we already have */

CREATE TABLE recommendationsBasedOnSummaryFieldDD AS
SELECT url, rank FROM movies WHERE rank > 0.05 ORDER BY rank DESC LIMIT 50;
/* by changing the treshold we receive 2 results -> seems to be a better solution */

\copy (SELECT * FROM recommendationsBasedOnSummaryFieldDD) to '/home/pi/RSL/dirty-dancing_top50recommendationsSummary.csv' WITH csv;
/* creating a csv file with your personal recommendations */


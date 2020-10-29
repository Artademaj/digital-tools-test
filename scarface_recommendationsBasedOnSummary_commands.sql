ALTER TABLE movies
ADD IF NOT EXISTS lexemesSummary tsvector;
/* adding a new columne, to be able to compare the summaries */ 

UPDATE movies
SET lexemesSummary = to_tsvector(Summary);
/* output: 5229 */ 

SELECT url FROM movies
WHERE lexemesSummary @@ to_tsquery('scarface');
/* output: 5 rows (herold and lillian a hollywood love story, harsh times, de palma, kika, scarface */ 

ALTER TABLE movies
ADD IF NOT EXISTS rank float4;
/* comment */

UPDATE movies
SET rank = ts_rank(lexemesSummary,plainto_tsquery(
(
SELECT Summary FROM movies WHERE url='scarface'
)
));
/* update: 5229 */

CREATE TABLE recommendationsBasedOnSummaryFieldSF AS
SELECT url, rank FROM movies WHERE rank > 0.99 ORDER BY rank DESC LIMIT 50;
/* Output: SELECT 1 -> only one movie with with p 0.99 -> that means, we have to set a lower treshold */

DROP TABLE recommendationsBasedOnSummaryFieldSF;
/* first, delete the table that we already have */

CREATE TABLE recommendationsBasedOnSummaryFieldSF AS
SELECT url, rank FROM movies WHERE rank > 0.5 ORDER BY rank DESC LIMIT 50;
/* by changing the treshold we receive 13 results -> seems to be a better solution */

\copy (SELECT * FROM recommendationsBasedOnSummaryFieldSF) to '/home/pi/RSL/scarface_top50recommendationsSummary.csv' WITH csv;
/* creating a csv file with your personal recommendations */


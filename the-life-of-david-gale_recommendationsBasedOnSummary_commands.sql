ALTER TABLE movies
ADD lexemesSummary tsvector;
/* adding a new columne, to be able to compare the summaries */ 

UPDATE movies
SET lexemesSummary = to_tsvector(Summary);
/* output: 5229 */ 

SELECT url FROM movies
WHERE lexemesSummary @@ to_tsquery('life');
/* output: 166 movies */ 

ALTER TABLE movies
ADD IF NOT EXISTS rank float4;
/* comment */

UPDATE movies
SET rank = ts_rank(lexemesSummary,plainto_tsquery(
(
SELECT Summary FROM movies WHERE url='the-life-of-david-gale'
)
));
/* update: 5229 */

CREATE TABLE recommendationsBasedOnSummaryFieldDG AS
SELECT url, rank FROM movies WHERE rank > 0.99 ORDER BY rank DESC LIMIT 50;
/* Output: SELECT 0 -> only one movie with with p 0.99 -> that means, we have to set a lower treshold */

DROP TABLE recommendationsBasedOnSummaryFieldDG;
/* first, delete the table that we already have */

CREATE TABLE recommendationsBasedOnSummaryFieldDG AS
SELECT url, rank FROM movies WHERE rank > 0.05 ORDER BY rank DESC LIMIT 50;
/* by changing the treshold we still have 0 results -> it does not make sense to lower. We skip the recommendations based Summary for this movie */


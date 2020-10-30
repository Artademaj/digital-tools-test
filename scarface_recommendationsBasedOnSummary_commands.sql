/* change table movies and add a new columne called 
lexemesSummary of the data typ tsvector for full text search */
ALTER TABLE movies
ADD IF NOT EXISTS lexemesSummary tsvector; 

/* insert tsvector value for each movie regarding summary and 
collect it in the columne lexemesSummary with the to_tsvector function*/ 
UPDATE movies
SET lexemesSummary = to_tsvector(Summary);

/* select all url from movies whith the word dancing
in the lexemesSummary with the to_tsquery function - output: 5 rows */
SELECT url FROM movies
WHERE lexemesSummary @@ to_tsquery('scarface');

/* change table movies and add a new columne of type float4 */
ALTER TABLE movies
ADD IF NOT EXISTS rank float4;

/* have a rank for all movies compared to dirty dancing movie;
compare lexemessummary from all movies with dirty dancing with the
plainto_tsquery function */
UPDATE movies
SET rank = ts_rank(lexemesSummary,plainto_tsquery(
(
SELECT Summary FROM movies WHERE url='scarface'
)
));

/* check what rank your fav. movie has - Output: 0.999 */
SELECT rank FROM movies WHERE url ='scarface';

/* creating another table with the 50 highest ranked movies, where rank
is higher then 0.5 - higher then the rank above */
CREATE TABLE recommendationsBasedOnSummaryFieldSF AS
SELECT url, rank FROM movies WHERE rank > 0.5 ORDER BY rank DESC LIMIT 50;

/* see the results from the new recommendations table */
SELECT * FROM recommendationsBasedOnSummaryFieldSF;

/* creating a csv file with our results */
\copy (SELECT * FROM recommendationsBasedOnSummaryFieldSF) to '/home/pi/RSL/scarface_top50recommendationsSummary.csv' WITH csv;

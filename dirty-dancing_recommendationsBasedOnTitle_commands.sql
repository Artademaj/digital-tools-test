/* change table movies and add a new columne called 
lexemestitle of the data typ tsvector for full text search */ 
ALTER TABLE movies
ADD IF NOT EXISTS lexemestitle tsvector;

/* insert tsvector value for each movie regarding title */ 
UPDATE movies
SET lexemestitle = to_tsvector(title);

/* select all url from movies whith the word dancing
in the lexemestitle with the to_tsquery function - output: 12 rows */
SELECT url FROM movies
WHERE lexemestitle @@ to_tsquery('dancing');

/* change table movies and add a new columne of type float4 */
ALTER TABLE movies
ADD IF NOT EXISTS rank float4;

/* have a rank for all movies compared to dirty dancing movie
regarding lexemestitle */
UPDATE movies
SET rank = ts_rank(lexemestitle,plainto_tsquery(
(
	SELECT title 
	FROM movies 
	WHERE url='dirty-dancing'
)
));

/* check what rank your fav. movie has - Output: 0.099 */
SELECT rank FROM movies WHERE url ='dirty-dancing';

/* creating another table with the 50 highest ranked movies, where rank
is higher then 0.05 - should be higher then result above */
CREATE TABLE recommendationsBasedOnTitleFieldDD AS
SELECT url, rank FROM movies WHERE rank > 0.05 ORDER BY rank DESC LIMIT 50;

/* creating a csv file with our results */
\copy (SELECT * FROM recommendationsBasedOnTitleFieldDD) to '/home/pi/RSL/dirty-dancing_top50recommendationsTitle.csv' WITH csv;


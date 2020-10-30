/* change table movies and add a new columne called 
lexemesStarring of the data typ tsvector for full text search */ 
ALTER TABLE movies
ADD IF NOT EXISTS lexemesStarring tsvector; 

/* insert tsvector value for each movie regarding Starring */ 
UPDATE movies
SET lexemesStarring = to_tsvector(Starring);

/* change table movies and add a new columne of type float4 */
ALTER TABLE movies
ADD IF NOT EXISTS rank float4;

/* have a rank for all movies compared to iron man movie
regarding lexemesStarring */
UPDATE movies
SET rank = ts_rank(lexemesStarring,plainto_tsquery(
(
SELECT Starring FROM movies WHERE url='iron man'
)
));

/* check what rank your fav. movie has - Output: 0 */
SELECT rank FROM movies WHERE url ='iron-man';

/* creating another table makes no sense, because no 
lexemesStarring output */
CREATE TABLE recommendationsBasedOnStarringFieldIM AS
SELECT url, rank FROM movies WHERE rank > 0.005 ORDER BY rank DESC LIMIT 50;

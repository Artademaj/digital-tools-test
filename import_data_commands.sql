sudo apt-get update
sudo apt install postgresql libpq-dev postgresql-client postgresql-client-common -y
sudo apt install postgresql libpq-dev postgresql-client postgresql-client-common -y > myPersonalLog
sudo su postgres
psql test
pwd Is
mkdir RSL
cd RSL
/* installing postgres and create the new file "RSL" */ 

psql test 
/* be able, to create a new table for the test */ 

CREATE TABLE movies (
url text,
title text,
ReleaseDate text,
Distributor text,
Starring text,
Summary text,
Director text,
Genre text, 
Rating text, 
Runtime text,
Userscore text,
Metascore text,
scoreCounts text
);

\copy movies FROM '/home/pi/RSL/moviesFromMetacritic.csv'delimiter ';' csv header;
/* output: 5229 / import csv file to our table */ 

SELECT * FROM movies where url='dirty-dancing';
SELECT * FROM movies where url='scarface';
SELECT * FROM movies where url='the-life-of-david-gale';
/* check, if my favorite movies are included in the dataset */ 

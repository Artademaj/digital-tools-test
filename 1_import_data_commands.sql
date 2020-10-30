/* installing postgres and create the new file "RSL" */ 
sudo apt-get update
sudo apt install postgresql libpq-dev postgresql-client postgresql-client-common -y
sudo apt install postgresql libpq-dev postgresql-client postgresql-client-common -y > myPersonalLog
sudo su postgres
psql test
pwd Is
mkdir RSL
cd RSL

/* be able, to create a new table for the test */ 
psql test 

/* creating table movies */ 
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

/* import csv file to our table with output: 5229 */ 
\copy movies FROM '/home/pi/RSL/moviesFromMetacritic.csv' delimiter ';' csv header;

/* check, if my favorite movies are included in the dataset */ 
SELECT * FROM movies where url='dirty-dancing';
SELECT * FROM movies where url='scarface';
SELECT * FROM movies where url='the-lif-of-david-gale';
SELECT * FROM movies where url='iron-man';


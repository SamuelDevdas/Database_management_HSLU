# Solve the challenge "ELT of spoken language data"



USE Recommendb;

#Create empty table named Spoken_lang with 2 columns 'lang_name' and 'iso_number'

CREATE TABLE Spoken_lang(
lang_name TEXT,
iso_number TEXT );


#Currently, the Spoken_languages column in the Movies table contains lists of
#languages that we would like to unpack into the Spoken_lang reference table.

INSERT INTO Spoken_lang
SELECT DISTINCT 
#'[{"name": "English", "iso_639_1": "en"}]'
JSON_UNQUOTE(JSON_EXTRACT(Spoken_languages, "$[0].name")), JSON_UNQUOTE(JSON_EXTRACT(Spoken_languages, "$[0].iso_639_1"))
FROM Movies
WHERE JSON_EXTRACT(Spoken_languages, "$[0].name") IS NOT NULL;

#Check if the table is loaded correctly
SELECT * FROM spoken_lang;
SELECT count(*) FROM spoken_lang;



############################################################
#2.What is the SQL statement to transform JSON lists of multiple spoken languages of all movies 
#such that exactly one row is loaded in the relationship table for each movie to language mapping?

#Create empty table named Movie_and_languages with 2 columns 'Movie_ID' and 'iso_number'
CREATE TABLE Movie_and_languages(
MovieID INTEGER,
iso_number TEXT );




#For each pair of MovieID and Spoken_languages that belongs together, we
#can generate one row in the mapping table movie_and_languages.

INSERT INTO Movie_and_languages
SELECT MovieID, iso_number
FROM movies
JOIN 
JSON_TABLE( Spoken_languages, '$[*]' COLUMNS ( iso_number TEXT PATH '$.iso_639_1' ))
AS Spoken_languages;


#Check if the table is loaded correctly
SELECT * FROM Movie_and_languages;

#Selecting Language relationships for movies with IDs 1, 2 and 3
SELECT *
FROM Movie_and_languages
WHERE MovieID IN (1,2,3);

############################################################

# Solve the challenge "Big Data Management"

#
CREATE DATABASE Steam_games;
USE Steam_games;

#
CREATE TABLE Steam_games(
MovieID INTEGER PRIMARY KEY,
Title TEXT,
Release_date DATE,
Budget INTEGER,
Genres JSON,
Spoken_languages JSON);



LOAD DATA LOCAL INFILE 'C:/Users/samue/switchdrive/SyncVM/MscIds Course Materials/2nd Semester/DBM/Dataset/Movies_and_Ratings/movies.csv'
INTO TABLE Movies
FIELDS ENCLOSED BY '"' ESCAPED BY '\\'
IGNORE 1 LINES;

select count(distinct(Title)) from Movies;

select * from movies;





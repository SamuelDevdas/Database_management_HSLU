CREATE DATABASE BooksDB;
USE BooksDB;

CREATE TABLE Books(
ISBN_13 VARCHAR(13) PRIMARY KEY,
title TEXT,
series TEXT,
rating_bbe INTEGER,
description TEXT,
language TEXT,
genres TEXT,
characters TEXT,
book_format TEXT,
edition TEXT,
pages TEXT,
publisher TEXT,
publish_date TEXT,
first_publish_date TEXT,
awards TEXT,
num_ratings INTEGER,
ratings_by_stars TEXT,
liked_percent INTEGER,
setting TEXT,
bbe_score  INTEGER,
bbe_votes INTEGER,
price TEXT,
ISBN_10 TEXT,
author TEXT,
year_of_publication INTEGER,
has_award INTEGER);

SET GLOBAL local_infile = TRUE;

LOAD DATA LOCAL INFILE "C:/Users/samue/Desktop/book_reviews/merged_updated.csv"
INTO TABLE Books
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
IGNORE 1 LINES;
 
SELECT * FROM Books;
SELECT count(distinct(ISBN_13)) FROM Books;

###########################################################################################

# Create user table first as User_has_rating will be created out of it

CREATE TABLE users (
  user_id INT,
  location TEXT,
  age INT
);

LOAD DATA LOCAL INFILE "C:/Users/samue/Desktop/book_reviews/Users.csv"
INTO TABLE users
FIELDS TERMINATED BY ';' ENCLOSED BY '"'
IGNORE 1 LINES;

# gives "Error Code: 1300. Invalid utf8mb4 character string: '"1407 k'"


# Create publisher entity table with unique created from parent book table

CREATE TABLE Publisher (
  publisher_id INT AUTO_INCREMENT PRIMARY KEY,
  publisher TEXT
);

#Insert unique publishers from the Books table into the Publisher table
INSERT INTO Publisher (publisher)
SELECT DISTINCT publisher
FROM Books;

select count(distinct(publisher))
from publisher;


# Create table genre from genre column in books table

CREATE TABLE genres (
    genre_id INT PRIMARY KEY,
    genres VARCHAR(255)
);

LOAD DATA LOCAL INFILE "C:/Users/samue/Desktop/book_reviews/genres.csv"
INTO TABLE genres
FIELDS TERMINATED BY ',' 
IGNORE 1 LINES;

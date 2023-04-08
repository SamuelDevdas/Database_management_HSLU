###################################################################

#R code
##########################################################


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

#########################################################################
# Create table book_has_genre from genre column in books table after 
#normalising it with R into a new csv file 

CREATE TABLE book_has_genre (
    ISBN_13 VARCHAR(20),
    genre VARCHAR(255)
);

LOAD DATA LOCAL INFILE "C:/Users/samue/Desktop/book_reviews/book_has_genres.csv"
INTO TABLE book_has_genre
FIELDS TERMINATED BY ',' 
IGNORE 1 LINES;

# check
SELECT count(*)
FROM book_has_genre;

# Create a new table genre with the columns genre_id and genre from the book_has_genre

CREATE TABLE genres (
  genre_id INT AUTO_INCREMENT PRIMARY KEY,
  genre VARCHAR(255) UNIQUE NOT NULL
);

# Insert data from book_has_genre into genre table
INSERT INTO genres (genre)
SELECT DISTINCT genre
FROM book_has_genre;

# check
SELECT *
FROM genres;
SELECT count(*)
FROM genres;

# Now add primary and foreign key constraints to existing table book_has_genres
ALTER TABLE book_has_genre
ADD CONSTRAINT pk_book_has_genre PRIMARY KEY (ISBN_13, genre),
ADD CONSTRAINT fk_book_has_genre_books FOREIGN KEY (ISBN_13) REFERENCES Books(ISBN_13),
ADD CONSTRAINT fk_book_has_genre_genres FOREIGN KEY (genre) REFERENCES genres(genre);


#########################################################################################

# Create table book_has_author from Book.Author column in books table after 
#normalising it with R into a new csv file 

CREATE TABLE book_has_author (
    ISBN_13 VARCHAR(20),
    author VARCHAR(255)
);

LOAD DATA LOCAL INFILE "C:/Users/samue/Desktop/book_reviews/book_has_author.csv"
INTO TABLE book_has_author
FIELDS TERMINATED BY ',' 
IGNORE 1 LINES;

# check
SELECT *
FROM book_has_author
WHERE ISBN_13 IS NULL OR author IS NULL;



# Create a new table authors with the columns author_id and author from the book_has_author table

CREATE TABLE authors (
  author_id INT AUTO_INCREMENT PRIMARY KEY,
  author VARCHAR(255) UNIQUE NOT NULL
);

# Insert authors from book_has_author into authors table
INSERT INTO authors (author)
SELECT DISTINCT author
FROM book_has_author;

# check
SELECT *
FROM authors;
SELECT count(*)
FROM authors;


# Now add primary and foreign key constraints to existing table book_has_author
ALTER TABLE book_has_author
ADD CONSTRAINT pk_book_has_author PRIMARY KEY (ISBN_13, author),
ADD CONSTRAINT fk_book_has_author_books FOREIGN KEY (ISBN_13) REFERENCES Books(ISBN_13),
ADD CONSTRAINT fk_book_has_author_genres FOREIGN KEY (author) REFERENCES authors(author);



#########################################################################################

# Create table book_has_setting from setting column in books table after 
#normalising it with R into a new csv file 

CREATE TABLE book_has_setting (
    ISBN_13 VARCHAR(20),
    setting VARCHAR(255)
);

LOAD DATA LOCAL INFILE "C:/Users/samue/Desktop/book_reviews/book_has_setting.csv"
INTO TABLE book_has_setting
FIELDS TERMINATED BY ',' 
IGNORE 1 LINES;

# check
SELECT *
FROM book_has_setting
WHERE ISBN_13 IS NULL OR setting IS NULL;



# Create a new table authors with the columns author_id and author from the book_has_author table

CREATE TABLE settings (
  setting_id INT AUTO_INCREMENT PRIMARY KEY,
  setting VARCHAR(255) UNIQUE NOT NULL
);

# Insert authors from book_has_author into authors table
INSERT INTO settings (setting)
SELECT DISTINCT setting
FROM book_has_setting;

# check
SELECT *
FROM settings;
SELECT count(*)
FROM settings;


# Now add primary and foreign key constraints to existing table book_has_author
ALTER TABLE book_has_setting
ADD CONSTRAINT pk_book_has_setting PRIMARY KEY (ISBN_13, setting),
ADD CONSTRAINT fk_book_has_setting_books FOREIGN KEY (ISBN_13) REFERENCES Books(ISBN_13),
ADD CONSTRAINT fk_book_has_setting_settings FOREIGN KEY (setting) REFERENCES settings(setting);

##################################################################################################

###########################################################################################

# Create users table
# change encoding to utf8
# gives "Error Code: 1300. Invalid utf8mb4 character string: '"1407 k'"
# The line separator was found to be as follows: # user_id, location, age '2', 'stockton, california, usa', '18\"\r\n\"3'

CREATE TABLE users (
  user_id VARCHAR(255),
  location VARCHAR(255),
  age VARCHAR(255)
);

LOAD DATA LOCAL INFILE 'C:/Users/samue/Desktop/book_reviews/users_utf8.csv'
INTO TABLE users
FIELDS TERMINATED BY ';' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

ALTER TABLE users
ADD CONSTRAINT users PRIMARY KEY (user_id);


#########################################################################################
# Create table user_has_rating from csv file 

#CREATE TABLE user_has_rating (
 # user_id VARCHAR(255),
 # ISBN_13 VARCHAR(255),
 # rating VARCHAR(255)
#);

CREATE TABLE user_has_rating (
  user_id VARCHAR(255),
  ISBN_13 VARCHAR(255),
  rating VARCHAR(255),
  PRIMARY KEY (user_id, ISBN_13),
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (ISBN_13) REFERENCES books(ISBN_13)
);

LOAD DATA LOCAL INFILE "C:/Users/samue/Desktop/book_reviews/ratings_updated.csv"
INTO TABLE user_has_rating
FIELDS TERMINATED BY ',' 
IGNORE 1 LINES;

#ALTER TABLE user_has_rating
#ADD CONSTRAINT pk_user_has_rating PRIMARY KEY (user_id, ISBN_13),
#ADD CONSTRAINT fk_user_has_rating_users FOREIGN KEY (user_id) REFERENCES users(user_id),
#ADD CONSTRAINT fk_user_has_rating_books FOREIGN KEY (ISBN_13) REFERENCES books(ISBN_13);

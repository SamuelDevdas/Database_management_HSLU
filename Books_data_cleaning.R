options(scipen = 100 )


# Load the datasets for books 

book_coll <- read.csv('Books.csv', sep = ';')
length(book_coll$ISBN)
length(unique(book_coll$ISBN))
length(unique(book_coll$Book.Title))
#head(book_coll)
str(book_coll)

######################################

book_goodreads <- read.csv('book_goodreads1.csv')
#head(book_goodreads)

length(book_goodreads$isbn)
length(unique(book_goodreads$isbn))
length(unique(book_goodreads$Book.Title))
str(book_goodreads)
#############################

book_bbe <- read.csv('books_1.Best_Books_Ever.csv')
#head(book_goodreads)

length(book_bbe$isbn)
length(unique(book_bbe$isbn))

str(book_bbe)
head(book_bbe)
#################################

#isbn13 added in book_bbe with python

book_bbe_13 <- read.csv('Books_isbn13.csv')
str(book_bbe_13)
head(book_bbe_13) 

##########################################

#merge book_coll with book_bbe_13
merged_df <- merge(book_bbe,book_bbe_13, 
                   by.x = 'isbn', 
                   by.y = 'ISBN.13')

head(merged_df)
str(merged_df)

write.csv(merged_df, "merged_books.csv", row.names = FALSE)

############################################

# load merged_books to inspect columns

merg_books <- read.csv('merged_books.csv')
str(merg_books)
View(merg_books)

sum(is.na(merg_books$author))

########################################

# remove redundant columns 

merged_updated <- subset(x = merg_books, select = -c(bookId, author, coverImg, 
                                                     Book.Title, Publisher, Image.URL.S,
                                                     Image.URL.M, Image.URL.L))

str(merged_updated)
View(merged_updated)




###################################
# inspect ratings
hist(merged_updated$rating, breaks = 40)
summary(merged_updated$rating)
boxplot(merged_updated$rating)



#################################

# Check how many books have no awards
length(merged_updated$awards)
sum(merged_updated$awards =='[]')
sum(merged_updated$awards !='[]')

sum(merged_updated$awards !='[]')+sum(merged_updated$awards =='[]')

sum(is.na(merged_updated$awards))


#############################################
# It makes sense to create a column book_has_award
install.packages("dplyr")
library(dplyr)

merged_updated <- merged_updated %>%
  mutate(has_award = ifelse(awards != "[]", 1, 0))

View(merged_updated)


##################################################

# save the updated table with has_award column to csv

write.csv(merged_updated, "merged_updated.csv", row.names = FALSE)




################################################
##inspect merged_updated

merged_updated <- read.csv('merged_updated.csv')
View(merged_updated)
str(merged_updated)

typeof(merged_updated$isbn)


##############################################

#donot use
# # Convert ISBN13 to character
# merged_updated$isbn_c <- as.character(merged_updated$isbn)
# 
# # Save the updated table with $isbn to chr to CSV
# write.csv(merged_updated, "merged_updated.csv", row.names = FALSE)
# 
# # Read the CSV file back into R
# col_count <- length(names(merged_updated))
# col_classes <- rep(NA, col_count)
# names(col_classes) <- names(merged_updated)
# col_classes["isbn_c"] <- "character"
# merged_updated <- read.csv('merged_updated.csv', colClasses = col_classes)
# 
# # Inspect the data types of the columns
# str(merged_updated)
# typeof(merged_updated$isbn_c)
####################################################

# Inspect Users source file as uploading to users table
# gives "Error Code: 1300. Invalid utf8mb4 character string: '"1407 k'"

########################################################

# Inspect publishers columnn in book to find number of uniques

merged_updated <- read.csv('merged_updated.csv')
View(merged_updated)
str(merged_updated)
length(unique(merged_updated$publisher))

head(merged_updated)

########################################################

# Create a new dataframe with genreId and genres column

# Load the necessary libraries
library(dplyr)
library(tidyr)
library(stringr)

# Parse the genre lists and create a new data frame with unique genre ids and genre names
genres <- merged_updated %>%
  # Extract individual genres from the genre lists
  mutate(genres = str_replace_all(genres, "\\[|\\]|'", "")) %>%
  separate_rows(genres, sep = ", ") %>%
  # Remove duplicates and create genreid
  distinct(genres) %>%
  mutate(genre_id = row_number())  %>%
  select(genre_id, everything())

# View the genres_df data frame
View(genres)

#save as csv
write.csv(genres, "genres.csv", row.names = FALSE)

###############################################################

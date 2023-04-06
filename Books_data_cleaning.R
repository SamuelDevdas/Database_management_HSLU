options(scipen = 100 )


#1. Load the datasets for books 

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

#2. isbn13 added in book_bbe with python

book_bbe_13 <- read.csv('Books_isbn13.csv')
str(book_bbe_13)
head(book_bbe_13) 

##########################################

#3. merge book_coll with book_bbe_13
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

#4.remove redundant columns 

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

#5. Check how many books have no awards
length(merged_updated$awards)
sum(merged_updated$awards =='[]')
sum(merged_updated$awards !='[]')

sum(merged_updated$awards !='[]')+sum(merged_updated$awards =='[]')

sum(is.na(merged_updated$awards))


#############################################
#6. Therefore, It makes sense to create a column book_has_award
install.packages("dplyr")
library(dplyr)

merged_updated <- merged_updated %>%
  mutate(has_award = ifelse(awards != "[]", 1, 0))

View(merged_updated)


##################################################

#7. save the updated table with has_award column to csv

write.csv(merged_updated, "merged_updated.csv", row.names = FALSE)




################################################
##inspect merged_updated

merged_updated <- read.csv('merged_updated.csv')
View(merged_updated)
str(merged_updated)

typeof(merged_updated$isbn)


##############################################
#PENDING
# Inspect Users source file as uploading to users table
# gives "Error Code: 1300. Invalid utf8mb4 character string: '"1407 k'"

########################################################

#8. Inspect publishers columnn in book to find number of uniques

merged_updated <- read.csv('merged_updated.csv')
View(merged_updated)
str(merged_updated)
length(unique(merged_updated$publisher))

head(merged_updated)

########################################################

#9. Create a new dataframe with isbn and genres column, for 
# book_has_genres table

# Load the necessary libraries
library(dplyr)
library(tidyr)
library(stringr)

# Parse the genre lists and create a new data frame with isbn and genre names
book_has_genres <- merged_updated %>%
  # Extract individual genres from the genre lists
  mutate(genres = str_replace_all(genres, "\\[|\\]|'", "")) %>%
  separate_rows(genres, sep = ", ") %>%
  # Remove duplicates and create isbn
  distinct(isbn, genres) %>%
  select(isbn, genres)


# View the book_has_genres data frame
View(book_has_genres)

#Check if all genres are present
length(unique(book_has_genres$genres))

#save as csv to load into sql
write.csv(book_has_genres, "book_has_genres.csv", row.names = FALSE)

###############################################################

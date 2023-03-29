# CODE FOR DATA CLEANING AND PREPARATION
#########################################

options(scipen = FALSE)


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

write.csv(merged_updated, "merged_updated.csv", row.names = FALSE)


###################################

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








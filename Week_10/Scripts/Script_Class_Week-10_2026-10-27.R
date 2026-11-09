### This script is for learning to work with strings in class
###
### Created by: Ellie S Jones
### Created on: 2026-10-27
### Last edited: 2026-10-31
###################################################################

## Load libraries
library(tidyverse)
library(here)
library(praise)
library(tidytext)
library(wordcloud)
library(janeaustenr)

## Practice with manipulation
paste("High temp", "Low pH")               # Paste words together
paste("High temp", "Low pH", sep="-")      # Add a dash between the words
paste0("High temp", "Low pH")              # Remove the space between words

shapes <- c("Square","Circle","Triangle")      # Working with vectors
paste("My favorite shape is a", shapes)
two_cities <- c("best","worst")
paste("It was the", two_cities, "of times.")   # Very useful when making labels for your plots

shapes                              # Pulling a string to work with individual characters
str_length                          # How many letters are in each word?
seq_data <- c("ATCCCGTC")
str_sub(seq_data, start=2, end=4)   # Extract specific characters in a string

str_sub(seq_data, start=3, end=3) <- "A"    # Modify strings by adding an A in the 3rd position
seq_data
str_dup(seq_data, times=c(2,3))             # Duplicate patterns in your strings, by 2 and 3

## Practice with whitespace
badtreatments <- c("High", " High", "High ", "Low", "Low")
badtreatments                                   # Pretend you have columns with some extra spaces that R now thinks are entirely new words
str_trim(badtreatments)                         # Use str_trim to remove the white spaces
str_trim(badtreatments, side = "left")          # Or designate the side you want the spaces removed from
str_pad(badtreatments,5,side="right")           # str_pad adds white space (in this case, to the right side of the 5th character)
str_pad(badtreatments,5,side="right",pad="1")   # Add a character instead of a white space


## Practice with locale sensitive operations
## These will perform differently in different places of the world with different languages, but default is English
x <- "I love R!"
str_to_upper(x)        # Make everything upper case
str_to_lower(x)        # Make everything lower case
str_to_title(x)        # Make the first letter of each word title case (caps)

## Practice with pattern matching
data <- c("AAA", "TATA", "CTAG", "GCTT")
str_view(data,pattern="A")                # View a specific pattern in a vector of strings
str_detect(data, pattern="A")             # Detect a specific pattern
str_detect(data, pattern="AT")
str_locate(data, pattern = "AT")          # Locate a pattern

## Practice with regular expressions/regex in pattern matching
vals <- c("a.b", "b.c", "c.d")       # Start with a set of strings
str_replace(vals,"\\."," ")          # Replace all the periods with a space using string, pattern, replace

## Practice with finding all characters in strings
vals <- c("a.b.c","b.c.d","c.d.e")
str_replace(vals,"\\."," ")          # Replace first instance of a period with a space using string, pattern, replace
str_replace_all(vals,"\\."," ")      # Replace all instances of periods with a space using string, pattern, replace and ALL

## Practice with sequences
val2 <- c("test 123","test 456","test")
str_subset(val2,"\\d")

## Practice with character classes
str_count(val2,"[aeiou]")     # Count number of lowercase vowels in each string
str_count(val2,"[0-9]")       # Count digits between 0 and 9 in each string

## Practice with quantifiers
strings <- c("550-153-7578","banana","435.114.7586","home: 672-442-6739")     # Make a regex that finds all the strings with phone numbers
phone <- "([2-9][0-9]{2})[- .]([0-9]{3})[- .]([0-9]{4})"                      # Create the specific pattern of 3 numbers, 3 numbers, 4 numbers separated by . or -, first number cannot be a 1
str_detect(strings,phone)                                                     # Which strings contain phone numbers?
test <- str_subset(strings,phone)                                             # Subset only the strings with phone numbers
test                                                                          # View the phone numbers
test |>
  str_replace_all(pattern = "\\.", replacement = "-") |>                      # Replace periods with -
  str_replace_all(pattern = "[a-zA-Z]|\\:", replacement = "") |>              # Remove "home" phone notes (any letters replaced with nothing)
  str_trim()                                                                  # Trim the white space

## Practice with tidytext using Jane Austen book dataset
head(austen_books())       # Explore the data
tail(austen_books())
view(austen_books())       # Oh wow, it really is every word of every Jane Austen book
# Clean the Austen data and add a column for line and chapter
original_books <- austen_books() |>                                         # Get all of the books
  group_by(book) |>
  mutate(line = row_number(),                                               # Find every line
         chapter = cumsum(str_detect(text, regex("^chapter [//divxlc]",     # Count the chapters (starts with word chapter followed by digit or roman numeral)
                                                 ignore_case = TRUE)))) |>  # Ignore lower or upper case
  ungroup()                                                                 # Ungroup so we have a data frame again
head(original_books)
# Clean so there is only one word per row (TIDY!!!)
tidy_books <- original_books |>
  unnest_tokens(output = word,input = text)       # Add a column named "word" with the input as text column, using unnest_tokens to unnest the data so it only has one word per row
head(tidy_books)
# Remove stopwords
head(get_stopwords())
cleaned_books <- tidy_books |>
  anti_join(get_stopwords())     # Dataframe without the stopwords
head(cleaned_books)
cleaned_books |>
  count(word,sort=TRUE)          # Count the most common words across all books

## Practice with sentiment analysis with tidytext
sent_word_counts <- tidy_books |>
  inner_join(get_sentiments()) |>     # Keep only positive or negative words
  count(word,sentiment,sort=TRUE)     # Count the words with sentiments
head(sent_word_counts)[1:3, ]
sent_word_plot <- sent_word_counts |>                                  # Use ggplot to visualize counts of positive and negative words in the books
  filter(n>150) |>                                   # Take only if there are over 150 instances of the books
  mutate(n=ifelse(sentiment=="negative",-n,n)) |>    # Add a column where if the word is negative, it makes the count negative
  mutate(word=reorder(word,n)) |>                    # Sort so it goes from largest to smallest effect
  ggplot(aes(x=n,y=word,fill=sentiment)) +
  geom_col() +
  labs(y="Contribution to Sentiment")

## Practice with wordcloud package
words <- cleaned_books |>
  count(word) |>           # Count all the words
  arrange(desc(n)) |>      # Sort the words
  slice(1:100)             # Take only the top 100 words
JA_wordcloud <- wordcloud(words=words$word,freq=words$n,colors=brewer.pal(8,"Dark2"))

## Save plots to GitHub
ggsave("Week_10/Outputs/JaneAusten_words_plot.png", plot=sent_word_plot)
ggsave("Week_10/Outputs/JaneAusten_wordcloud.png",plot=JA_wordcloud)

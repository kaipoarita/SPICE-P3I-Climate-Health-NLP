# install.packages("syuzhet")
# install.packages("textdata")
# install.packages("ggplot2")
# install.packages("jsonlite")

library(syuzhet) # sentiment analysis functions
library(ggplot2) # ggplot functions
library(jsonlite) # allows us to read json files
library(dplyr)

 
# import dataset
climate_fever_data <- stream_in(file("data/climate-fever-dataset-r1.jsonl"))
View(climate_fever_data)

# create lexicon
nrc_lexicon <- get_sentiments("nrc")
nrc_lexicon

# make a vector
climate_fever_vector <- as.character(climate_fever_data$claim)
climate_fever_vector

# Make sentiment analysis raw
climate_fever_sentiment <- get_nrc_sentiment(climate_fever_vector)
head(climate_fever_sentiment)

#################################################
#ADDITION add claim label
claim_label <- as.character(climate_fever_data$claim_label)
sentiment_and_claim <- cbind(climate_fever_sentiment, claim_label)
sentiment_and_claim

climate_fever_sentiment_score <- data.frame(colSums(climate_fever_sentiment[,]))
climate_fever_sentiment_score

filtered_supports <- sentiment_and_claim %>% filter(claim_label == "SUPPORTS")
filtered_refutes <- sentiment_and_claim %>% filter(claim_label == "REFUTES")
filtered_disputed <- sentiment_and_claim %>% filter(claim_label == "DISPUTED")
filtered_NEI <- sentiment_and_claim %>% filter(claim_label == "NOT_ENOUGH_INFO")

filtered_supports_two <- filtered_supports[,-11]
filtered_supports_two

supports_sentiment_score <- data.frame(colSums(filtered_supports_two[,]))
supports_sentiment_score

# Viz Prep 1
names(supports_sentiment_score) <- 'score'
names(supports_sentiment_score)

# Viz Prep 2
supports_sentiment_score <- cbind("sentiment"=rownames(supports_sentiment_score),
                                       supports_sentiment_score)
names(supports_sentiment_score)

# Viz Prep 3
rownames(supports_sentiment_score) <- NULL
supports_sentiment_score

ggplot(data=supports_sentiment_score, aes(x=sentiment, y=score)) +
  geom_bar(aes(fill=sentiment), stat="identity") +
  theme(legend.position="none") +
  xlab("Sentiments") +
  ylab("Scores") +
  ggtitle("Sentiment Analysis on Climate Fever Data")

###################################

# Make sentiment analysis numbered
climate_fever_sentiment_score <- data.frame(colSums(climate_fever_sentiment[,]))
climate_fever_sentiment_score



# Viz Prep 1
names(climate_fever_sentiment_score) <- 'score'
names(climate_fever_sentiment_score)

# Viz Prep 2
climate_fever_sentiment_score <- cbind("sentiment"=rownames(climate_fever_sentiment_score),
                                       climate_fever_sentiment_score)
names(climate_fever_sentiment_score)

# Viz Prep 3
rownames(climate_fever_sentiment_score) <- NULL
climate_fever_sentiment_score

# Sentiment analysis visualization
ggplot(data=climate_fever_sentiment_score, aes(x=sentiment, y=score)) +
  geom_bar(aes(fill=sentiment), stat="identity") +
  theme(legend.position="none") +
  xlab("Sentiments") +
  ylab("Scores") +
  ggtitle("Sentiment Analysis on Climate Fever Data")

#Remove the positive and negative sentiment results
climate_fever_sentiment_score[,]
climate_fever_sentiment_score_TWO <- climate_fever_sentiment_score[1:8,]

# Rerun sentiment analysis visualization
ggplot(data=climate_fever_sentiment_score_TWO, aes(x=sentiment, y=score))+
  geom_bar(aes(fill=sentiment), stat="identity") +
  theme(legend.position="none")+
  xlab("Sentiments")+
  ylab("Scores")+
  ggtitle("Sentiment Analysis on Climate Fever Data")




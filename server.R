### Data Science Capstone : Course Project
### server.R file for the Shiny app

suppressWarnings(library(tm))
suppressWarnings(library(stringr))
suppressWarnings(library(shiny))

# Load Quadgram,Trigram & Bigram Data frame files

quadgram <- readRDS("fourwords.RData");
trigram <- readRDS("threewords.RData");
bigram <- readRDS("twowords.RData");
mesg <<- ""

# It is needed to clean user input before predicting the next word

NextWord <- function(input_text) {
  
  clean_input <- removePunctuation(tolower(input_text))
  input <- strsplit(clean_input, " ")[[1]]
  
  # Back Off Algorithm
  # Predict the next term of the user input sentence
  # 1. For prediction of the next word, Quadgram is first used (first three words of Quadgram are the last three words of the user provided sentence).
  # 2. If no Quadgram is found, back off to Trigram (first two words of Trigram are the last two words of the sentence).
  # 3. If no Trigram is found, back off to Bigram (first word of Bigram is the last word of the sentence)
  # 4. If no Bigram is found, back off to the most common word with highest frequency 'the' is returned.
  
  if (length(input)>= 3) {
    input <- tail(input,3)
    if (identical(character(0),head(quadgram[quadgram$firstword == input[1] & quadgram$secondword == input[2] & quadgram$thirdword == input[3], 4],1))){
      NextWord(paste(input[2],input[3],sep=" "))
    }
    else {mesg <<- "Next word is predicted using 4-gram."; head(quadgram[quadgram$firstword == input[1] & quadgram$secondword == input[2] & quadgram$thirdword == input[3], 4],1)}
  }
  else if (length(input) == 2){
    input <- tail(input,2)
    if (identical(character(0),head(trigram[trigram$firstword == input[1] & trigram$secondword == input[2], 3],1))) {
      NextWord(input[2])
    }
    else {mesg<<- "Next word is predicted using 3-gram."; head(trigram[trigram$firstword == input[1] & trigram$secondword == input[2], 3],1)}
  }
  else if (length(input) == 1){
    input <- tail(input,1)
    if (identical(character(0),head(bigram[bigram$firstword == input[1], 2],1))) {mesg<<-"No match found. Most common word 'the' is returned."; head("the",1)}
    else {mesg <<- "Next word is predicted using 2-gram."; head(bigram[bigram$firstword == input[1],2],1)}
  }
}


shinyServer(function(input, output) {
  output$prediction <- renderPrint({
    result <- NextWord(input$inputString)
    output$text2 <- renderText({mesg})
    result
  });
  
  output$text1 <- renderText({
    input$inputString});
}
)
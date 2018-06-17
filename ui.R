### Data Science Capstone : Course Project
### ui.R file for the Shiny app
suppressWarnings(library(shiny))
suppressWarnings(library(markdown))
shinyUI(navbarPage("Capstone: Course Project",
                   tabPanel("Next Word prediction application",
                            img(src = "./headers.png"),
                            # Sidebar
                            sidebarLayout(
                              sidebarPanel(
                                helpText("This Shiny App aims at predicting the next word based on the input text."),
                                textInput("inputString", "Please enter here your word and/or phrase",value = ""),
                                br(),
                                br()
                              ),
                              mainPanel(
                                h2("Predicted Next Word"),
                                verbatimTextOutput("prediction"),
                                strong("n-gram used:"),
                                tags$style(type='text/css', '#text2 {background-color: rgba(255,255,0,0.40); color: black;}'),
                                textOutput('text2')
                              )
                            )
                            
                   ),
                   tabPanel("About",
                            mainPanel(
                              img(src = "./headers.png"),
                              includeMarkdown("about.md")
                            )
                   )
)
)

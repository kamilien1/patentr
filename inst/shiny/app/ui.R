## yang yao 
## motivation: R Shiny gallery and look at urls below
library(shiny)

fluidPage(
  titlePanel("Uploading Files"),
  sidebarLayout(
    sidebarPanel(
      # http://shiny.rstudio.com/gallery/file-upload.html
      # https://shiny.rstudio.com/reference/shiny/latest/fileInput.html
      # http://stackoverflow.com/questions/29201155/how-to-validate-the-file-type-of-a-file-uploaded-by-the-user-in-a-shiny-app
      # http://stackoverflow.com/questions/30624201/read-excel-in-a-shiny-app
      fileInput('file1', 'Choose a File',
                accept=c('text/csv', 
                         'text/comma-separated-values,text/plain', 
                         '.csv',
                         '.xls',
                         '.xlsx')),
      tags$hr(),
      checkboxInput('header', 'Header', TRUE),
      radioButtons('sep', 'Separator',
                   c(Comma=',',
                     Semicolon=';',
                     Tab='\t'),
                   ','),
      radioButtons('quote', 'Quote',
                   c(None='',
                     'Double Quote'='"',
                     'Single Quote'="'"),
                   '"'),
      actionButton('cleanDataButton',"Clean Data"),
      p("Click this button to clean the raw data"),
      downloadButton('downloadData',"Download Clean Data")
    ),
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Data Table",tableOutput("contents"), tableOutput("cleanContents")),
                  tabPanel("Score Count Plot",plotOutput("outplot1"))
      )
    )
  )
)

## yang yao 
## motivation: R Shiny gallery and look at urls below
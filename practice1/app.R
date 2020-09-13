library(shiny)
library(ggplot2)
library(vroom)


ui <- fluidPage(
    fileInput("file", NULL, accept = c(".csv", ".tsv")),
    numericInput("n", "Rows", value = 5, min = 1, step = 1),
    tableOutput("head"),
    plotOutput("histo1"),
    plotOutput("histo2")
)

server <- function(input, output, session) {
    data <- reactive({
        req(input$file)
        
        ext <- tools::file_ext(input$file$name)
        switch(ext,
               csv = vroom::vroom(input$file$datapath, delim = ","),
               tsv = vroom::vroom(input$file$datapath, delim = "\t"),
               validate("Invalid file; Please upload a .csv or .tsv file")
        )
    })
    
    output$head <- renderTable({
        head(data(), input$n)
    })
    
    output$histo1 <- renderPlot({
        hist(data()$Value)
    })
    
    output$histo2 <- renderPlot({
        hist(data()$Value)
    })
}

shinyApp(ui, server)
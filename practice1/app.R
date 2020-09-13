library(shiny)
library(ggplot2)
library(vroom)
library(plyr)


ui <- fluidPage(
    titlePanel("Simple Histogram Plot"),
    fileInput("file", NULL, accept = c(".csv", ".tsv")),
    numericInput("n", "Rows", value = 5, min = 1, step = 1),
    tableOutput("head"),
    plotOutput("histo1"),
    tableOutput("stats"),
    plotOutput("histo2"),
    textOutput("instructions"),
    
    
    sidebarLayout(
        sidebarPanel(),
        mainPanel(
            h1("Select .csv file with the following format:")
            # cbind(c("ABCD", "ABCD", "ABCD", "CDEF", "CDEF", "CDEF"), c(0.98, 0.12,	0.36, 1.47, 0.18, 0.54))
        )
    )
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
    
    output$stats <- renderTable({
        ddply(data(), .(Study), summarize, N = length(Study), Mean = mean(Value),
              Median = median(Value), SD = sd(Value))
    })
    
    output$head <- renderTable({
        head(data(), input$n)
    })
    
    output$histo1 <- renderPlot({
        hist(data()$Value)
    })
    
    
    output$histo2 <- renderPlot({
        ggplot(data(), aes(x=Value, fill = Study)) + 
            geom_histogram(binwidth = .2, alpha = .7, position = "identity", aes(y=..density..)) +
            labs(title = "Simulated ISCP data", 
                 x = "S:N")
    }, res = 96)
    

    
}

shinyApp(ui, server)
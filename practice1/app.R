library(shiny)
library(ggplot2)
library(vroom)
library(plyr)


ui <- fluidPage(

    titlePanel("Simple Histogram Plot"),
    fileInput("file", NULL, accept = c(".csv", ".tsv")),
    numericInput("n", "Bin Width", value = 1, min = .01, step = .01),
    tableOutput("stats"),
    plotOutput("histo2"),
    ) 
    
    
#    sidebarLayout(
#        sidebarPanel(),
#        mainPanel()
#    )


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

    output$histo2 <- renderPlot({
        ggplot(data(), aes(x=Value, fill = Study)) + 
            geom_histogram(binwidth = input$n, alpha = .7, position = "identity", aes(y=..density..)) +
            labs(title = "Simulated ISCP data", 
                 x = "S:N")
    }, res = 96)
    

    
}

shinyApp(ui, server)
# app.R
library(shiny)
library(ggplot2)
library(DT)
library(dplyr)
library(readr)

ui <- fluidPage(
  titlePanel("📊 Interactive Data Dashboard"),

  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload a CSV File", accept = ".csv"),
      tags$hr(),
      selectInput("preset_data", "Select Preset Datasets", c("None", "iris", "mtcars", "diamonds"), selected = "None"),
      tags$hr(),
      conditionalPanel(
        condition = "input.file != null || input.preset_data != 'None'",
        uiOutput("column_selectors"),
        tags$hr(),
      ),
      selectInput("plot_type", "Plot Type", choices = c("Histogram", "Boxplot", "Scatter")),
      tags$hr(),
      uiOutput("plot_ui")
    ),

    mainPanel(
      tabsetPanel(
        tabPanel("Data Table", DTOutput("data_table")),
        tabPanel("Summary Stats", verbatimTextOutput("summary")),
        tabPanel("Plot", plotOutput("plot"))
      )
    )
  )
)

server <- function(input, output, session) {
  # Load Data
  data <- reactive({
    req(input$file)
    read_csv(input$file$datapath)
  })

  # Generate UI for column selection
  output$column_selectors <- renderUI({
    req(data())
    cols <- names(data())
    tagList(
      selectInput("x_col", "X-axis:", choices = cols),
      selectInput("y_col", "Y-axis:", choices = cols, selected = cols[2]),
      selectInput("color_col", "Color by (optional):", choices = c("None", cols))
    )
  })
  data <- reactive({
    if (input$preset_data != "None") {
      # Load the chosen preset dataset
      if (input$preset_data == "diamonds") {
        # diamonds is from ggplot2
        ggplot2::diamonds
      } else {
        get(input$preset_data)
      }
    } else if (!is.null(input$file)) {
      # Load uploaded CSV file
      readr::read_csv(input$file$datapath)
    } else {
      NULL
    }
  })

  # Show plot-specific inputs
  output$plot_ui <- renderUI({
    req(input$plot_type)

    if (input$plot_type == "Histogram") {
      sliderInput("bins", "Number of bins:", min = 5, max = 50, value = 20)
    } else {
      NULL
    }
  })

  # Render Data Table
  output$data_table <- renderDT({
    req(data())
    datatable(data(), options = list(pageLength = 10))
  })

  # Summary Stats
  output$summary <- renderPrint({
    req(data())
    summary(data())
  })


  # Generate Plot
  output$plot <- renderPlot({
    req(data(), input$x_col)

    df <- data()
    plot_type <- input$plot_type
    x <- input$x_col
    y <- input$y_col
    color <- if (input$color_col != "None") input$color_col else NULL

    # if (plot_type == "Boxplot" || plot_type == "Scatter" && is.numeric(df[[x]])) {
    #   df[[x]] <- factor(df[[x]], nmax = 10)
    # }


    if (plot_type == "Histogram") {
      ggplot(df, aes(x = .data[[x]])) +
        geom_bar(fill = "steelblue", color = "white") +
        theme_minimal()
    } else if (plot_type == "Boxplot") {
      ggplot(df, aes_string(x = x, y = y, color = color)) +
        geom_boxplot() +
        theme_minimal()
    } else if (plot_type == "Scatter") {
      ggplot(df, aes_string(x = x, y = y, color = color)) +
        geom_point(size = 2, alpha = 0.7) +
        theme_minimal()
    }
  })
}

shinyApp(ui, server)

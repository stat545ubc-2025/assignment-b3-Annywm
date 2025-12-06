library(shiny)
library(tidyverse)
library(bslib)
library(bsicons)

data <- read_csv("BCfarm_sensitivity.csv", show_col_types = FALSE)

BC_data <- data %>%
  rename(
    crop = 'Crop Type'
  ) %>%
  group_by(crop) %>%
  filter(n() >5 ) %>% ungroup()


sidebar_content <- sidebar(
  title = "Control Panel",

  popover(
    trigger = actionLink(
      inputId = "help_info",
      label = "About this App",
      icon = icon("circle-info")
    ),
    title = "App Introduction",
    div(
      style = "text-align: justify;",
      markdown("This app analyzes Greenhouse Gas (GHG) Emissions from various crop types in BC farms recorded in the **[Litefarm](https://www.litefarm.org/)** database."),
      markdown("Use the sidebar to filter crops, view their emission density, and download the summary statistics.")
    )
  ),

  selectInput(
  inputId = "crop_select",
  label = "Select Crop Type:",
  choices = unique(BC_data$crop),
  selected = NULL,
  multiple = TRUE
  ),

  checkboxInput(
    inputId = "sort_by_mean",
    label = "Sort Table by Mean value (High to Low)",
    value = FALSE
  ),
  downloadButton(
    outputId = "download_summary",
    label = "Download Summary Table"
  )

)
cards <- list(
  card(
    full_screen = TRUE,
    card_header("Crop Type Emission Variability"),
    plotOutput("crop_plot")
  ),
  card(
    full_screen = TRUE,
    card_header("Summary Statistics"),
    tableOutput("summary_table")
  )
)

#--- UI ---
ui <- page_sidebar(
    theme = bs_theme(
    bootswatch = "zephyr",
    "font-size-base" = "1.2rem",
    "navbar-bg" = "#C7E9B0"
  ),
  title = "BC Farms GHG Emission Dashboard",
  sidebar = sidebar_content,
  !!!cards
)

#--- Server ---
server <- function(input,output){

  data_select <- reactive({
    req(input$crop_select)
    BC_data %>%
      filter(crop %in% input$crop_select)
  })
  output$crop_plot <- renderPlot({
    ggplot(data_select(),aes(x= Total_GHG , fill = crop )) +
      geom_density(alpha = 0.6)+
      facet_wrap(~crop, scales = "free", nrow = 1)+
      theme_minimal(base_size = 14) +
      labs(
        x = "Total GHG emission (CO2e/ha)",
        y = "Density")
  })

  summary_table_reactive <- reactive({
    df <- data_select() %>%
      group_by(crop) %>%
      summarise(
        Mean = round(mean(Total_GHG, na.rm = TRUE),2),
        Median = round(median(Total_GHG, na.rm = TRUE),2),
        Min = round(min(Total_GHG, na.rm = TRUE),2),
        Max = round(max(Total_GHG, na.rm = TRUE),2),
    )
    if (input$sort_by_mean){
      df <- df %>% arrange(desc(Mean))
    }
    return(df)
    })
  output$summary_table <- renderTable({
    summary_table_reactive()
  })
  output$download_summary <- downloadHandler(
    filename = function() { "summary_table.csv" },
    content = function(file) {
      write.csv(summary_table_reactive(), file, row.names = FALSE)
    })
}


# Run the application
shinyApp(ui = ui, server = server)

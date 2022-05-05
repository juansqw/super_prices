# Server

server <- function(input, output, session) {
  observeEvent(
    input$clase,
    updateSelectInput(session, 
                      inputId = "articulo",
                      choices = unique(dbSuper$ipc[dbSuper$clase==input$clase])))
  # Dumbbell
  data_dumbbells <- reactive({
    dbSuper %>% 
      filter(Date >= max(Date) - days(30),
             clase == input$clase,
             ipc == input$articulo) %>% 
      group_by(Store) %>% 
      summarise(last_price = mean(Precio)) %>% 
      mutate(U30D = 0,
             Gap = last_price)
  })
  
  # plot
  output$db_plot <- renderPlotly({
    plot_ly(data_dumbbells(), color = I("gray80")) %>% 
      add_segments(x = ~U30D, xend = ~last_price, y = ~Store, yend = ~Store, showlegend = FALSE) %>% 
      add_markers(x = ~last_price, y = ~Store, name = "Precio actual", color = I("blue")) %>% 
      layout(xaxis = list(title = "Precio en RD$"),
             margin = list(l = 65))
  })
  
  # Evolucion
  data_evolucion <- reactive({
    dbSuper %>% 
      filter(clase == input$clase,
             ipc == input$articulo) %>%
      group_by(Date, Store) %>% 
      summarise(avg_price = mean(Precio)) %>% 
      pivot_wider(everything(),
                  names_from = 'Store',
                  values_from = 'avg_price')
  })
  
  # Plot
  output$articulo_plot <- renderPlotly({
    stores <- names(data_evolucion())[-1]
    p <- plot_ly(data = data_evolucion(), x = ~Date)
    
    for(trace in stores){
      p <- p %>% plotly::add_trace(y = as.formula(paste0("~`", trace, "`")), 
                                   name = trace,
                                   type = 'scatter',
                                   mode = 'markers')
    }
    
    p %>% 
      layout(xaxis = list(title = ""),
             yaxis = list (title = "Precio en RD$"))
  })
  
  # Establecimientos
  output$store_plot <- renderPlotly({
    store_db <- dbSuper %>% 
      filter(Date >= max(Date) - days(30)) %>% 
      group_by(Store, clase) %>% 
      summarise(avg_price = mean(Precio)) %>% 
      pivot_wider(everything(),
                  names_from = 'Store',
                  values_from = 'avg_price')
    
    stores <- names(store_db)[-1]
    p <- plot_ly(data = store_db, x = ~clase)
    
    for(trace in stores){
      p <- p %>% plotly::add_trace(y = as.formula(paste0("~`", trace, "`")), 
                                   name = trace,
                                   type = 'bar')
    }
    
    p %>% 
      layout(xaxis = list(title = ""),
             yaxis = list (title = "Precio en RD$"))
  })
  
}
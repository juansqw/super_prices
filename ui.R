# UI

ui <- dashboardPage(
  dashboardHeader(title = 'Super_price'),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Análisis por artículo", 
               tabName = "articles", 
               icon = icon('money-bill')),
      menuItem("Análisis por establecimiento", 
               tabName = "stores", 
               icon = icon('chart-line'))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = 'articles',
              h2('Análisis por artículos'),
              fluidRow(
                column(width = 6,
                       selectInput('clase',
                                   'Seleccione una categoría',
                                   choices = unique(dbSuper$clase))),
                column(width = 6,
                       selectInput('articulo',
                                   'Seleccione un artículo',
                                   choices = '',
                                   selected = '')),
                h4("Precio promedio de los últimos 30 días"),
                plotlyOutput('db_plot'),
                h4('Evolución del precio de artículo por establecimiento'),
                plotlyOutput('articulo_plot')
              )),
      tabItem(tabName = 'stores',
              h2('Análisis por establecimientos'),
              plotlyOutput('store_plot')
              )
      )
    )
)
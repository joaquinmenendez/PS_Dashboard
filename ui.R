# Importamos los DF
# Asumimos que historico es el dataset  completo con todos los datos.
historico <-  read.csv(file = "D:/Hospital Italiano/Plan de Salud (PS)/datos_calculados_MODIF.csv") # uso mismo archivo por ahora PERO CON NUEVAS COLUMNAS
historico <- as_tibble(historico) # me intersa que sea una tibble?
historico$PERIODO_date <- lubridate::dmy(historico$PERIODO) # convierto las categories a fechas
historico <- historico %>%
  arrange(desc(IMPORTE_EGRESO))# Uso $ por que arrange no me reconoce el string solo.

# Filtramos del historico las bajas de este mes.
# Queremos filtrar por algnún motivo de baja?
bajas_mes <- historico %>% filter(
  between(PERIODO_date,
          lubridate::floor_date(max(historico$PERIODO_date) - month(1),unit = 'month'),
          max(historico$PERIODO_date)
  )) %>%
  arrange(desc(IMPORTE_EGRESO))

# Define UI for application that draws a histogram
ui <- dashboardPage(
  # Titulo Dashboard
  dashboardHeader(title = 'Tablero PS - Bajas'),
  # Sidebar
  dashboardSidebar(   
    sidebarMenu(
      menuItem("Bajas Mes", tabName = "bajas_mes", icon = icon("dashboard")),
      menuItem("Bajas Historico", tabName = "historico", icon = icon("th"))
    )),
  # Cuerpo dashboard
  dashboardBody(
    # Empiezan las tabs
    tabItems(
      # Primera Tab #############
      tabItem(tabName = "bajas_mes",
              fluidPage(
                # Application title
                titlePanel("Bajas del Plan de Salud del último mes"),
                # Mis objetos graficos
                fluidRow(column(width = 10,
                                h3("Datos de los afiliados dados de baja")
                                ),
                         column(width = 2,
                                downloadButton(outputId = 'bajas_del_mes.csv',
                                               label = "Descargar .csv")
                                )
                ),
                fluidRow(column(width = 12,
                                dataTableOutput("tabla_resumen")
                                )
                         ),
                fluidRow(h3("Analisis de afiliado individual")),
                fluidRow(column(3,
                                fluidRow(selectInput(selectize = T,
                                                     multiple = F,
                                                     selected = '',
                                                     inputId = "id_afiliado",
                                                     label = "Numero Afiliado",
                                                     choices = c('Seleccione uno'='',unique(bajas_mes$AFILIADO)))
                                ),
                                fluidRow(dateRangeInput(inputId = 'filtrar_periodo_afiliado',
                                                        label= "Desde - Hasta",
                                                        start = lubridate::floor_date(Sys.Date(), unit = "month") - years(2),
                                                        end = Sys.Date(),
                                                        min = min(historico$PERIODO_date),
                                                        max = Sys.Date())
                                ),
                                fluidRow(verbatimTextOutput(outputId = 'datos_afiliado',
                                                            placeholder = T))
                ),
                column(9,
                       plotOutput(outputId = "gastos_plot")
                )
                )
              )
      ), # Fin de primera Tab
      # Empieza segunda Tab ############
      tabItem(
        tabName='historico',
        fluidPage(
          titlePanel("Datos históricos"),
          fluidRow(column(width=5,
                          h3('Datos de los afiliados dados de baja')
                          ),
                   column(width = 5,
                          dateRangeInput(inputId = 'fechas_historicas',
                                        label= "Fecha: Desde - Hasta",
                                        min = min(historico$PERIODO_date),
                                        max = max(historico$PERIODO_date),
                                        start = min(historico$PERIODO_date),
                                        end = max(historico$PERIODO_date)
                                        )
                          ),
                   column(width = 2,
                          downloadButton(outputId = 'bajas_historico.csv',
                                         label = "Descargar .csv")
                          )
                   ),
          fluidRow(column(width = 12,
                          dataTableOutput("tabla_historico"))
          ),
          fluidRow(h3("Analisis de afiliado individual")),
          fluidRow(column(3,
                          fluidRow(selectInput(selectize = T,
                                               multiple = F,
                                               selected = '',
                                               inputId = "id_afiliado_historico",
                                               label = "Numero Afiliado",
                                               choices = c('Seleccione uno'='',unique(historico$AFILIADO)))
                          ),
                          fluidRow(dateRangeInput(inputId = 'filtrar_periodo_afiliado_historico',
                                                  label= "Desde - Hasta",
                                                  start = min(historico$PERIODO_date),
                                                  end = Sys.Date(),
                                                  min = min(historico$PERIODO_date),
                                                  max = Sys.Date())
                          ),
                          fluidRow(verbatimTextOutput(outputId = 'datos_afiliado_historico',
                                                      placeholder = T))
          ),
          column(9,
                 plotOutput(outputId = "gastos_plot_historico")
          )
          )
        )
      ) # Fin segunda Tab
    ) # Fin Tabs
  ) # Fin Dashboard Body
) # Fin Dashboard
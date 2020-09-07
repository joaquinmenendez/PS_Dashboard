# Importamos los DF
# Asumimos que historico es el dataset  completo con todos los datos.
historico <-  read.csv(file = "D:/Hospital Italiano/Plan de Salud (PS)/datos_calculados_MODIF.csv") # uso mismo archivo por ahora PERO CON NUEVAS COLUMNAS
historico <- as_tibble(historico) # me intersa que sea una tibble?
historico$PERIODO_date <- lubridate::dmy(historico$PERIODO) # convierto las categories a fechas
historico <- historico %>%
  arrange(desc(historico$IMPORTE_EGRESO))# Uso $ por que arrange no me reconoce el string solo.

# Filtramos del historico las bajas de este mes.
# Queremos filtrar por algnún motivo de baja?
bajas_mes <- historico %>% filter(
  between(PERIODO_date,
          lubridate::floor_date(max(historico$PERIODO_date) - month(1),unit = 'month'),
          max(historico$PERIODO_date)
  )
)

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
                titlePanel("Bajas del Plan de Salud del ultimo mes"),
                # Mis objetos graficos
                fluidRow(h3("Bajas del plan de salud")),
                fluidRow(column(width = 5,
                                sliderInput(label = "Numero de socios",
                                            inputId = "top_n",
                                            min = 1,
                                            max = 20,
                                            step = 1,
                                            value = 5
                                            )
                                ),
                         column(2, checkboxGroupInput(inline = TRUE, 
                                                      inputId = 'motivos_mes',
                                                      label = 'Motivos de baja',
                                                      choices = unique(bajas_mes$MOTIVO),
                                                      selected = unique(bajas_mes$MOTIVO)
                                                      )
                                ),
                         column(2, checkboxGroupInput(inline = TRUE, 
                                                      inputId = 'plan_mes',
                                                      label = 'Plan de Salud',
                                                      choices = unique(bajas_mes$PLAN),
                                                      selected = unique(bajas_mes$PLAN)
                                                      )
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
        titlePanel("Bajas del Plan de Salud - datos historicos"),
        fluidRow(column(width = 4,
                        sliderInput(label = "Numero de filas",
                                    inputId = "num_filas",
                                    min = 1,
                                    max = 20,
                                    step = 1,
                                    value = 5)
        ),
        column(width = 4,
               dateRangeInput(inputId = 'fechas_historicas',
                              label= "Fecha: Desde - Hasta",
                              min = min(historico$PERIODO_date),
                              max = max(historico$PERIODO_date),
                              start = min(historico$PERIODO_date),
                              end = max(historico$PERIODO_date)
               )
        ),
        column(width = 2,
               fluidRow(checkboxGroupInput(inline = TRUE, 
                                           inputId = 'motivos',
                                           label = 'Motivos de baja',
                                           choices = unique(historico$MOTIVO),
                                           selected = unique(historico$MOTIVO)
               )
               ),
               fluidRow(checkboxGroupInput(inline = TRUE, 
                                           inputId = 'plan',
                                           label = 'Plan de Salud',
                                           choices = unique(historico$PLAN),
                                           selected = unique(historico$PLAN)
               )
               )
        ),
        column(width = 2,
               downloadButton(outputId = 'bajas_historico.csv',
                              label = "Descargar .csv")
        )
        ),
        fluidRow(column(width = 12,
                        tableOutput("tabla_historico"))
        )
      ) # Fin segunda Tab
    ) # Fin Tabs
  ) # Fin Dashboard Body
) # Fin Dashboard
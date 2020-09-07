
# Importamos librerias
library(shiny)
library(lubridate)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(shinydashboard)
library(sys)

# PRIMERO CALCULOS
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

#SERVER############################################################################################################################
# Define server logic 
server <- function(input, output) {
  require(dplyr)

# Primer tab #####
  #Tabla
output$tabla_resumen <- renderDataTable(expr = bajas_mes %>% 
                                             select(PERIODO:MOTIVO),
                                        options = list(pageLength = 10)
                                         )
                                      
  
  #Boton Descargar # Discutir si seria necesario que filtre el bajas_mes antes de descargar
  output$bajas_del_mes.csv <- downloadHandler(contentType = 'text/csv',
                                              filename = 'Bajas_del_mes.csv',
                                              content = function(file) {
                                                write.csv(bajas_mes %>% 
                                                            select(PERIODO:MOTIVO), file, row.names = FALSE)
                                              }
  )
  
  # Reactive bajas_mes filtrado usado para plotear los datos y las tablas. Por eso es reactivo
  bajas_mes_filter <- reactive({
    x <- historico %>% 
      filter(AFILIADO == input$id_afiliado) %>%
        filter(between(PERIODO_date,
                       input$filtrar_periodo_afiliado[1],
                       input$filtrar_periodo_afiliado[2])
               )
    }) 
  
  
  output$gastos_plot <- renderPlot({
    x <- as_tibble(bajas_mes_filter())
    # Asigna colores segun valores de razon
    x <- x %>%
      mutate(COLOR= ifelse(RAZON_GASTO > .9, 'red',
                           ifelse(RAZON_GASTO > .5, 'yellow','green')
                           )
             )
    
    x$COLOR <- factor(x$COLOR,
                      levels = c("red", "yellow", "green")
                      )  
    
    # Plot #########
    ggplot(data= x) +
      geom_bar(aes(PERIODO_date,RAZON_GASTO, fill=COLOR),
               stat = 'identity') +
      labs(title= 'Razon de gasto por mes') +
      coord_cartesian(ylim = c(0,2)) + 
      scale_fill_manual(values = c("green" = 'green',
                                   'yellow'='yellow',
                                   "red"= 'red'),
                        labels = c('Alto',
                                   'Medio',
                                   'Bajo'),
                        drop = F,
                        name = 'Riesgo') +
      geom_hline(yintercept = mean(x$RAZON_GASTO),
                 linetype= 'dashed',
                 size = 1) +
      theme_light() + 
      theme(axis.text.x=element_text(angle =65, vjust = 0.5))+
      xlab('Periodo') + 
      ylab('Razon') 
  }, res = 96)
  
  # Texto resumen
  output$datos_afiliado <- renderText({
    
    paste(c('Afiliado : ',input$id_afiliado,
            '\nEdad : ', bajas_mes_filter()$EDAD[1],
            '\nPlan : ', as.character(bajas_mes_filter()$PLAN[1]),
            '\nMotivo de baja : ', as.character(bajas_mes_filter()$MOTIVO[1]),
            '\nNum. periodos (seleccionados): ', length(bajas_mes_filter()$PERIODO),
            '\nNum total de periodos : ', dim(historico %>%
                                                filter(AFILIADO == input$id_afiliado) %>%
                                                select(PERIODO))[1],
            '\nPeriodos arriba : ', sum(bajas_mes_filter()$mayor_uno),
            '\nRazon media : ',round(mean(bajas_mes_filter()$RAZON_GASTO),3),
            '\nRazon historica: ', round(historico %>% 
                                           filter(AFILIADO == input$id_afiliado) %>%
                                           select(RAZON_GASTO) %>%
                                           summarise(mean(RAZON_GASTO)),3)
    ))
  })
# Segunda tab ###############
  # Tabla (pestaña datos historicos)
  output$tabla_historico <- renderDataTable(historico %>% 
                                               filter(
                                                 between(PERIODO_date,
                                                         input$fechas_historicas[1],
                                                         input$fechas_historicas[2])
                                                 ),
                                            options = list(pageLength = 10)
                                               )
  # Descargar tabla
  output$bajas_historico.csv <- downloadHandler(contentType = 'text/csv',
                                                filename = 'Bajas_historico.csv',
                                                content = function(file) {
                                                  write.csv(historico %>% 
                                                              filter(between(PERIODO_date,
                                                                             input$fechas_historicas[1],
                                                                             input$fechas_historicas[2]))
                                                            , file, row.names = FALSE)
                                                }
  )
}
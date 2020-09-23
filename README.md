# Shinny Dashboard "Plan de Salud"

## Levantar el Dashboard
- Clonar el repositorio en tu carpeta local
- Dentro del repositorio correr R
```R
library(shiny)
shiny::runApp('./')
```

## Estructura 
```text
~/PS_Dashboard
|-- ui.R
|-- server.R
|-- README.md
```

## Documentacion 
[Draw.io](https://drive.google.com/file/d/1hBPbHkGyVQ68m4H062RDr_Otk1WCx2iW/view?usp=sharing)

## Estado actual del proyecto
- El `importe ingreso` esta compuesto unicamente por el pago mensual de la cuota. El `importe egreso` esta compuesto por la facturación interna (gastos en nivel de consulta practica), no incluye medicamentos,  optica, gastos externos, etc.

- Los sujetos que estamos incluyendo dentro de nuestro dataset solo incluye a los socios independientes (es decir no incluye a socios con dependientes en su plan).

Tareas:

- [ ] Crear la ETL de las distintas tablas de gasto (Este proceso viviria en Pentaho) .
- [ ]  Crear el script que tome estas tablas y aplique los calculos agregados (definir si queremos mas) y devuelva un `.csv` que se almacene localmente en el servidor.
- [x]  Modificar el Dashboard con cambios menores
- [x] Crear documentación compartida en Draw.io

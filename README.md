# Shinny Dashboard "Plan de Salud"

## Levantar el Dashboard
- Clonar el repositorio en tu carpeta local

- Dentro del repositorio correr Docker:
```bash
docker build -t dashboard_ps .
```
- Una vez que la imagen se terminó de construir ingresar
```bash
docker run -p 5024:5024 dashboard_ps
```
- En caso de que el usuario decida correre el dashboard localmente y no quiera usar Docker puede hacerlo corriendo `starter.R`. 

## Estructura 
```text
~/PS_Dashboard
├── Dockerfile
├── README.md
├── server.R
├── starter.R
└── ui.R
```

## Documentacion 
[Draw.io](https://drive.google.com/file/d/1hBPbHkGyVQ68m4H062RDr_Otk1WCx2iW/view?usp=sharing)

## Estado actual del proyecto
- El `importe ingreso` esta compuesto unicamente por el pago mensual de la cuota. El `importe egreso` esta compuesto por la facturación interna (gastos en nivel de consulta practica), no incluye medicamentos,  optica, gastos externos, etc.

- Los sujetos que estamos incluyendo dentro de nuestro dataset solo incluye a los socios independientes (es decir no incluye a socios con dependientes en su plan).

Tareas:

- [ ] Crear la ETL de las restantes tablas de gasto (Este proceso viviria en Pentaho como una actividad mensual).
- [ ] Crear el script que tome estas tablas y aplique los calculos agregados (definir si queremos más) y actualice una tabla en el Datalake .
- [ ] Modificar los scripts `server.R` y `ui.R` para que lean los datos de la tabla en el Datalake en vez del .csv local
- [x] Crear el Dockerfile para montar el dashboard
- [x] Crear documentación compartida en Draw.io


Screenshot del Dashboard
![Dashboard](https://user-images.githubusercontent.com/43391630/94960610-30de3400-04c1-11eb-9a33-b66124948f18.png)

# Documentación de Base de Datos

## Motor de Base de Datos
Microsoft SQL Server (SQLEXPRESS o LocalDB). Se conecta desde Python mediante `pyodbc` y `SQLAlchemy`.

## Esquema Relacional Lógico
La base de datos sirve principalmente como **Catálogo Maestro** de parametrización para el código de Python. Debido a que la información pesada (inventarios/precios) entra y sale de forma efímera en Excels, la BD no almacena los productos en sí, sino las reglas, usuarios e históricos. No se utilizan llaves foráneas estrictas para permitir máxima flexibilidad.

### 1. `Maestro_Asesores`
- **Propósito:** Define a los vendedores y la asociación a sus listas de precios regionales. 
- **Campos Relevantes:**
  - `id` (PK, INT)
  - `nombre_asesor` (VARCHAR 150): Ej: 'BOGOTA - JOHN MILLER'
  - `zona` (VARCHAR 100)
  - `listas_asignadas` (VARCHAR 255): Arreglo lógico en texto separado por comas (Ej: "03, 04, 12"). Python procesa este string durante el ciclo `for`.

### 2. `Maestro_Impuestos`
- **Propósito:** Mapea el código alfanumérico del impuesto proveniente del ERP hacia su porcentaje real.
- **Campos Relevantes:**
  - `codigo_impositivo` (PK, VARCHAR): Ej "016", "V10", "EC".
  - `porcentaje_iva` (DECIMAL 5,2): Ej 0.16. En caso de no haber match, Python asume IVA 0.

### 3. `Maestro_Listas`
- **Propósito:** Funciona para el requerimiento comercial "Dual Header". Traduce un código numérico aburrido del ERP a un nombre comercial legible para la cabecera del reporte final de Excel.
- **Campos Relevantes:**
  - `codigo_lista` (PK, VARCHAR): Ej "03".
  - `nombre_lista` (VARCHAR): Ej "ABASTOS".

### 4. `Items_Manuales`
- **Propósito:** Tabla de "Inmunidad". Contiene códigos de productos VIP que NUNCA deben ser omitidos o borrados por el motor de reglas de negocio, independientemente de que su stock o costo sea cero.
- **Campos Relevantes:**
  - `item` (PK, VARCHAR)
  - `fecha_agregado` (DATETIME)

### 5. `Historico_Generaciones`
- **Propósito:** Log transaccional automático. Se usa para auditoría corporativa y trazabilidad.
- **Campos Relevantes:**
  - `id` (PK, INT)
  - `fecha` (DATETIME)
  - `item`, `descripcion`, `precio_con_impuesto`, `lista`, `asesor_destino`.
- **Procesos Automáticos:** Python inserta masivamente (Bulk Insert) en esta tabla en el bloque final de `motor_precios.py` antes de cerrar la solicitud del usuario.

## Backups y Restauración
Para restaurar la base de datos completa:
1. Ejecutar el script `database.sql` para crear la estructura DDL.
2. Ejecutar el script `datos_maestros.sql` para inyectar la data DML vital.

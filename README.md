# 📊 Gestor de Precios Automático

Este proyecto es una aplicación Full-Stack local diseñada para automatizar el cruce masivo de listas de precios de venta con los niveles de inventario. Incluye validaciones y reglas de negocio dinámicas, permitiendo a la fuerza de ventas exportar de forma instantánea reportes en Excel con un diseño corporativo premium.

---

## 🚀 Características Principales

- **Procesamiento Masivo:** Utiliza **Pandas** para cruzar rápidamente miles de registros y crear tablas dinámicas pivotadas.
- **Flujo de Rescate (Excepciones):** Sistema *stateless* de 2 pasos. En el primer paso, el sistema analiza e informa qué productos se excluyeron por falta de inventario o reglas. En el segundo paso, permite al usuario "rescatar" dichos productos de manera manual mediante un buscador predictivo interactivo.
- **Filtros Avanzados:** Exclusión automática de productos obsoletos (que inician con "NO-") y depuración de listas obsoletas.
- **Diseño Excel Premium:** Exportación vía **openpyxl** implementando:
  - Doble Encabezado (Dual Header) mapeando los códigos comerciales numéricos hacia nombres reales (Ej. *03 -> ABASTOS*).
  - Agrupación por categoría (LINEA) con filas divisorias estilizadas.
  - Formato estricto de celdas financieras (`$X,XXX`) en los precios.
  - Auto-ajuste de columnas de extremo a extremo.
- **Auditoría en Base de Datos:** Guarda un histórico (log) de todos los precios reportados a los asesores comerciales en **SQL Server**.

---

## 🛠️ Tecnologías Utilizadas

- **Backend / API:** Python 3 + FastAPI.
- **Procesamiento de Datos:** Pandas.
- **Base de Datos:** Microsoft SQL Server (LocalDB / SQLEXPRESS) conectado vía SQLAlchemy + `pyodbc`.
- **Exportación Excel:** openpyxl.
- **Frontend:** Vanilla HTML5, CSS3 (Glassmorphism), JavaScript puro con Fetch API.

---

## 📋 Requisitos del Sistema

1. **Python 3.8+** instalado.
2. **Microsoft SQL Server** local instalado (SQLEXPRESS) o LocalDB.
3. **ODBC Driver 17 for SQL Server** instalado en el sistema operativo (Requerido por `pyodbc`).
4. Archivos Excel de insumo estructurados (Lista de Precios e Inventario).

---

## ⚙️ Instalación y Configuración

### 1. Clonar o descargar el repositorio
Ubicarse en la carpeta raíz del proyecto (ej. `Gestor-precios`).

### 2. Configurar la Base de Datos SQL
Debes crear la estructura de datos. Para ello, ejecuta en **SQL Server Management Studio (SSMS)** el script que se encuentra en la raíz del proyecto:
```sql
-- Ejecutar el contenido del archivo database.sql
```
Asegúrate de poblar manualmente las tablas `Maestro_Asesores`, `Maestro_Impuestos` y `Maestro_Listas` para que el sistema tenga contra qué cruzar las asignaciones.

### 3. Instalar Dependencias de Python
Abre tu consola o terminal y ejecuta:
```bash
pip install -r requirements.txt
```

### 4. Variables de Entorno (Opcional)
Puedes crear un archivo `.env` en la raíz si deseas parametrizar la base de datos sin tocar el código de conexión en `motor_precios.py`:
```env
DB_HOST=(localdb)\MSSQLLocalDB  # o .\SQLEXPRESS
DB_NAME=GestorPrecios
```

---

## 🏃 Cómo Ejecutar el Proyecto

1. Inicia el servidor de FastAPI:
```bash
uvicorn main:app --reload
```
2. Abre tu navegador web favorito y accede a:
```
http://localhost:8000
```
*(FastAPI servirá la interfaz gráfica local alojada en la carpeta `static/` directamente sobre esta ruta).*

---

## 📖 Manual de Uso (Interfaz)

1. **Pantalla de Carga:** Sube ambos archivos de Excel generados desde tu ERP (El sistema espera las columnas exactas descritas en tu lógica de negocio).
2. **Botón Analizar:** Al darle clic, los datos viajan a la ruta `/api/analizar`.
3. **Bandeja de Excepciones:** La aplicación arrojará un resumen informándote cuántos productos se omitieron.
   - Utiliza el buscador predictivo para buscar productos faltantes y rescatarlos (se añadirán como *chips* o *tags* azules).
   - Alternativamente, pega los códigos de producto separados por comas en la bandeja de carga rápida.
4. **Procesar:** Haz clic en **Generar Reportes Definitivos**. La UI reenviará los excels originales sumando el arreglo de excepciones.
5. **Descarga:** Aparecerán los enlaces de descarga de Excel, listos para distribuir.

---

## 📁 Arquitectura y Estructura de Directorios

```plaintext
/Gestor-precios
├── main.py              # Enrutador principal de FastAPI y limpieza segura finally.
├── motor_precios.py     # Lógica Core (Pandas + DB Queries + Openpyxl).
├── database.sql         # Script DDL de la BD en SQL Server.
├── requirements.txt     # Dependencias del proyecto.
├── /static
│   └── index.html       # UI Full-Stack moderno en HTML/JS/CSS.
├── /uploads             # Carpeta temporal para los archivos en análisis.
└── /output              # Carpeta de salida de los Excel procesados.
```

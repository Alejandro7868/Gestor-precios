# 📊 Gestor de Precios Automático

## 1. Información General
- **Nombre del proyecto:** Gestor de Precios Automático.
- **Descripción:** Plataforma local con arquitectura web para el cruce, procesamiento y generación de reportes masivos en Excel.
- **Propósito del sistema:** Automatizar la creación de listas de precios categorizadas y formateadas para el equipo de ventas.
- **Problema que resuelve:** Elimina el trabajo manual de cruzar el inventario en bruto (proveniente de ERP SIESA) con las listas de precios, aplicando reglas de negocio estrictas (filtrar productos obsoletos, validar stock/UM) y separando automáticamente los reportes por cada asesor comercial y sus regiones asignadas.
- **Usuarios/Áreas:** Área Comercial, Coordinación de Ventas, Analistas de Inventario.
- **Estado actual:** FUNCIONAL Y ESTABLE (Fase de Producción).
- **Alcance actual:** Cruce de inventario vs precios, motor de reglas automáticas, módulo de "rescate" de productos omitidos (UI stateless), exportación automatizada con formateo corporativo (Openpyxl) y dual-header regional.

## 2. Stack Tecnológico
**Backend & Procesamiento:**
- **Lenguaje:** Python (3.8 a 3.12).
- **Framework API:** FastAPI.
- **Servidor Web:** Uvicorn.
- **Manejo de Datos:** Pandas, Numpy.
- **Generación Excel:** openpyxl.
- **Base de Datos:** Microsoft SQL Server (Express 2022/2025 o LocalDB).
- **Conexión a BD:** SQLAlchemy, pyodbc.

**Frontend:**
- **Lenguaje:** HTML5, CSS3, JavaScript (Vanilla).
- **Consumo de API:** Fetch API nativa y uso de FormData.
- **Diseño:** CSS Custom (Glassmorphism), UI Responsiva.

## 3. Arquitectura y Módulos
*Toda la información profunda sobre arquitectura se encuentra en [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) y [docs/MODULES.md](docs/MODULES.md).*

## 4. Estructura del Proyecto
```text
/Gestor-precios
├── .env                    # (No versionado) Variables de entorno BD.
├── database.sql            # Script DDL para construir la base de datos vacía.
├── datos_maestros.sql      # Script DML con la configuración maestra de asesores, listas e impuestos.
├── dump_db.py              # Script utilitario (creado durante el desarrollo) para extraer datos.
├── main.py                 # Punto de entrada FastAPI, endpoints de carga, análisis y descarga.
├── motor_precios.py        # Core de negocio: Funciones de pandas, merge, reglas y openpyxl.
├── requirements.txt        # Dependencias de Python.
├── README.md               # Este documento principal.
├── HANDOVER.md             # Documento de entrega formal y checklist.
├── /docs                   # Documentación técnica extendida.
│   ├── ARCHITECTURE.md     # Arquitectura, decisiones, integraciones.
│   ├── DATABASE.md         # Esquema de base de datos.
│   ├── MODULES.md          # Especificación de módulos, roles y flujos de negocio.
│   └── TROUBLESHOOTING.md  # Solución de errores (Error 26, TrustServerCertificate, Bugs UI).
├── /output                 # Directorio temporal de Excels finales (se auto-crea).
├── /static                 # Frontend.
│   └── index.html          # Interfaz de usuario SPA.
└── /uploads                # Directorio temporal de archivos subidos (se auto-crea).
```

## 5. Instalación del Proyecto

### Requisitos Previos
- Python 3.8 - 3.12 (Asegurar opción "Add Python to PATH" durante la instalación).
- Microsoft SQL Server (Express o LocalDB).
- ODBC Driver 17 for SQL Server instalado en Windows.

### Configuración de Base de Datos y Variables (`.env`)
1. Abrir **SQL Server Management Studio (SSMS)** y conectarse al servidor local.
2. Ejecutar primero `database.sql` y luego `datos_maestros.sql`.
3. Crear un archivo `.env` en la raíz del proyecto.
   *(Nota de seguridad: Quien instale debe definir la IP/Instancia correcta)*.
```env
DB_HOST=.\SQLEXPRESS
DB_NAME=GestorPrecios
# DB_USER= (PENDIENTE DE VALIDAR si se requiere en entorno red)
# DB_PASSWORD= (PENDIENTE DE VALIDAR)
```

### Comandos de Instalación
Abrir terminal en la carpeta raíz:
```bash
# 1. Instalar dependencias
pip install -r requirements.txt

# 2. Ejecutar servidor de desarrollo/producción local
uvicorn main:app --reload
```
Acceder a la aplicación ingresando a `http://localhost:8000` en el navegador.

## 6. Despliegue, Backups y Mantenimiento

- **Despliegue actual:** El sistema corre como un servicio/script On-Premise en un equipo local de la oficina. Para futuras migraciones a un servidor en la nube (AWS/Azure), se debe empaquetar en Docker o desplegar detrás de un proxy reverso (Nginx) y actualizar el `.env`.
- **Backups (Base de datos):** Programar en SSMS un *Maintenance Plan* para realizar backups (`.bak`) semanales de `GestorPrecios`. 
- **Backups (Código):** Empujar cambios periódicamente a un repositorio Git corporativo.
- **Mantenimiento Técnico:**
  - **Limpieza de Archivos:** Las carpetas `uploads/` se autolimpian mediante bloques `finally`. Los archivos en `output/` son sobreescritos o pueden requerir purga manual periódica o vía Cron Job de Windows.
  - **Librerías:** Monitorear actualizaciones críticas de Pandas o FastAPI anualmente (`pip list --outdated`).

---
**Explora las carpetas `/docs` y el `HANDOVER.md` para el cierre completo.**

# Arquitectura y Decisiones Técnicas

## 1. Arquitectura General
El sistema sigue un patrón Cliente-Servidor bajo una arquitectura tipo "Monolito Modular Local" y **Stateless API (API sin estado)**.
- **Frontend (SPA):** Interfaz estática simple cargada desde `/static/index.html`. Gestiona el estado de la sesión (archivos subidos e items rescatados) directamente en la memoria del navegador usando objetos `FormData`.
- **Backend (FastAPI):** Expone 2 endpoints funcionales principales. No guarda estado ni sesiones (sin cookies o JWT). Utiliza el disco duro de la máquina (`/uploads/`) de forma hiper-efímera durante la vida de la solicitud HTTP.
- **Motor de Datos:** Delegado enteramente a **Pandas** (procesamiento vectorizado) para asegurar tiempos de respuesta de sub-segundos (micro-latencia) incluso cruzando Excels con cientos de miles de celdas.
- **Motor Gráfico:** Delegado a **Openpyxl**, el cual itera dinámicamente y dibuja las estructuras corporativas en el reporte final de salida.

## 2. Decisiones Técnicas y Razonamientos

| Decisión Arquitectónica | Motivo Principal | Impacto / Limitaciones futuras |
|---|---|---|
| **API Stateless para el proceso "Rescate"** | Se consideró usar bases de datos en memoria (Redis/Memcached) para guardar el estado del Excel subido entre los 2 pasos. Se optó por reenviar los archivos desde el Frontend junto al JSON de rescatados. | **Impacto:** Servidor 100% resiliente a caídas. Menor riesgo de *memory leaks*. **Límite:** Consume un poco más de ancho de banda local al re-enviar el archivo. |
| **Dibujado iterativo de Openpyxl** | `pandas.to_excel` es rápido pero no permite formateo celda-a-celda avanzado ni combinación de rangos (`merge_cells`) para cabeceras con lógica estricta (Dual Header). | **Impacto:** Cumplimiento total de la identidad visual corporativa exigida por el negocio. **Límite:** Ligeramente más lento en ejecución que un volcado nativo. |
| **Vectorización estricta por Pandas** | Iterar archivos Excel usando bucles `for` en Python estándar toma minutos. Pandas lo hace en milisegundos gracias a C++. | **Impacto:** Alta escalabilidad de volumen de datos. |
| **Uso de `ws.max_row` en Openpyxl** | Inicialmente se usó una variable contador `current_row` matemática, la cual se desincronizaba internamente al hacer saltos de línea (causando bugs visuales del signo peso en la última celda). | **Impacto:** Exactitud del 100% en el formateo condicional de filas. |

## 3. Integraciones
- **SIESA ERP (Indirecta):**
  - **Finalidad:** Proveer la data cruda y veraz de inventario e impuestos.
  - **Forma de Conexión:** Offline / Manual. El usuario extrae el Excel del SIESA enfocado al C.O. de Funza y lo sube al Gestor.
  - **Autenticación:** N/A.
  - **Posibles fallos:** Si SIESA cambia la nomenclatura de alguna columna en su nueva versión de Excel (Ej: `Desc. item` pasa a llamarse `Descripcion`), el motor de Pandas arrojará un error 500 al no encontrar la Key del DataFrame.

## 4. Historial Cronológico del Proyecto
| Fecha aprox. | Módulo | Cambio | Motivo |
|---|---|---|---|
| Sprint 1 | Core Pandas | Construcción del motor de Merge y filtrado. | Automatizar trabajo manual de ventas. |
| Sprint 1 | Generador Excel | Inclusión "Dual Header" (Nombres Comerciales). | Exigencia corporativa visual. |
| Sprint 2 | Backend / UI | Refactor a arquitectura Stateless de 2 Pasos. | Implementación de pantalla interactiva de Rescate de productos. |
| Sprint 2 | Backend | Refactor a `ws.max_row`. | Fix crítico en Bug de formateo numérico. |
| Sprint 2 | Backend SQL | Configuración `TrustServerCertificate=yes`. | Bypass a error silencioso en conexión con SQL 2025. |

## 5. Seguridad y Riesgos Identificados
- **Autenticación:** El sistema NO posee un sistema de Login / Passwords porque está desplegado en un entorno `localhost` corporativo y su naturaleza es de herramienta de escritorio en un entorno seguro.
- **Riesgo Físico:** Si el puerto 8000 se expone a la red WiFi corporativa (`0.0.0.0`), cualquier empleado conectado a la misma red podría acceder al sistema. *(PENDIENTE DE VALIDAR si esto es deseado o se debe enjaular por Firewall).*
- **Sanitización:** Las inyecciones SQL están altamente controladas porque no se usan strings crudos para búsquedas (se usa el ORM paramétrico de SQLAlchemy/pyodbc para cruces en Pandas).
- **Manejo de Archivos:** Las vías de subida están aseguradas por bloques `try/finally` haciendo `os.remove()`, protegiendo el almacenamiento local de acumulación y ejecución de código malicioso oculto.

# Documento Formal de Handover (Entrega Técnica)

## Resumen de la Entrega
Este documento certifica la entrega técnica del proyecto **Gestor de Precios Automático**. El sistema fue construido, validado y estabilizado operativamente. Se entrega toda la lógica de negocio, arquitectura web y motor de procesamiento de Pandas.

## Estado Actual del Proyecto
- **FUNCIONAL Y ESTABLE:** Extracción de datos SIESA (vía Excel), Cruce Pandas, Filtros por "NO-", Exclusiones automáticas por Stock/Costo/UM, Módulo de Rescate Interactivo (Chips), Formatting Openpyxl (Dual-Header, Moneda, Tamaños dinámicos), Exportación Multi-Asesor, e inserción de registros de Auditoría en SQL Server.
- **PENDIENTE / FUTURAS MEJORAS:** Integración directa por API a SIESA (evitando subida manual de Excels). Implementación de un sistema de login/usuarios si la red se expone a internet.
- **DEUDA TÉCNICA:** Refactor opcional de `motor_precios.py` implementando Programación Orientada a Objetos. (Actualmente es un enfoque funcional para maximizar la velocidad de MVP).
- **RIESGOS IDENTIFICADOS:** El ERP SIESA no debe alterar el nombre exacto de las columnas de los Excels exportados (Ej. `Desc. item`, `Cant. disponible`), de lo contrario la aplicación lanzará un `KeyError` al intentar procesarlas.

## Credenciales y Accesos Entregados (Inventario)
*NOTA: No se incluyen contraseñas reales. La empresa debe verificar y custodiar esta información.*

| Servicio | Tipo de acceso | Responsable sugerido | Estado |
|---|---|---|---|
| Repositorio de Código | Developer / Admin | Líder Técnico | PENDIENTE DE VALIDAR |
| Base de Datos SQL Server | SA (Sysadmin) / Owner | DBA de la Empresa | Entregado vía Autenticación de Windows local |
| Servidor Windows (Host) | RDP / Local Admin | Área de TI (Infraestructura) | PENDIENTE DE VALIDAR |

## Checklist Final de Entrega

### Código y Funcionalidad
- [x] Código fuente entregado, operativo en la máquina destino.
- [x] Motor de Pandas calibrado (sin redondeos falsos, datos puros SIESA).
- [x] Interfaz Frontend en Vanilla JS operativa.
- [x] Repositorio o rama principal (PENDIENTE DE VALIDAR si se subió a Git).

### Base de Datos
- [x] Estructura creada y documentada (`database.sql`).
- [x] Backups de configuración maestra preservados (`datos_maestros.sql`).
- [x] Tabla de históricos `Historico_Generaciones` inyectando registros correctamente.

### Infraestructura y Accesos
- [x] Servidor Web Uvicorn corriendo localmente (On-premise).
- [x] Accesos de SO identificados.
- [ ] (PENDIENTE DE VALIDAR) Dominio, SSL, o proxy (Nginx) si se desea exponer externamente.

### Documentación
- [x] README principal
- [x] Arquitectura e Integraciones (`docs/ARCHITECTURE.md`)
- [x] Base de datos (`docs/DATABASE.md`)
- [x] Módulos y Reglas (`docs/MODULES.md`)
- [x] Troubleshooting (`docs/TROUBLESHOOTING.md`)
- [x] Documento Handover

### Consideraciones Críticas para el Siguiente Desarrollador
1. **Archivos Críticos:** `motor_precios.py`. Modificar la lista `orden_estricto` sin consultar al área comercial destruirá el formato de las columnas en la salida de Excel.
2. **Estilos de Excel:** La magia gráfica corporativa ocurre en la función `exportar_excel_categorizado`. Si te piden cambiar el color de la cabecera, busca las clases `PatternFill` al inicio de esa función.
3. **Conexiones:** Asegúrate de revisar la bandera `TrustServerCertificate=yes` si se migra de SQL Server 2025 a otra versión, o si se habilitan conexiones SSL estrictas.

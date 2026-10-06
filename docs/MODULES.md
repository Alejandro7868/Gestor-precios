# Módulos y Reglas de Negocio Estrictas

## Roles y Permisos
*NOTA: Dado que la aplicación opera bajo un concepto de "Herramienta de Escritorio Única" (Single-Tenant Local), no se implementó seguridad RBAC. Sin embargo, lógicamente el sistema asume los siguientes permisos si fuese administrado:*

| Rol | Módulo | Ver | Crear | Editar | Eliminar |
|---|---|---|---|---|---|
| Admin / Ventas | Carga de Archivos | ✔️ | ✔️ | ✖️ | ✖️ |
| Admin / Ventas | Rescate de Productos | ✔️ | ✔️ | ✔️ | ✖️ |
| Admin / Ventas | Configuración DB | ✔️ | ✔️ | ✔️ | ✔️ |

---

## Módulo 1: Análisis y Filtro de Exclusiones
- **Objetivo:** Recibir archivos brutos, detectar irregularidades o ausencias de stock, aplicar reglas restrictivas de la empresa y retornar el listado descartado para posible "rescate" manual.
- **Flujo:** Usuario sube archivos (Inventario + Precios) → Backend los convierte a DataFrame Pandas → Aplica Merge → Ejecuta limpieza → Envía JSON (`omitidos`) al Frontend.
- **Endpoints:** `/api/analizar` (POST).
- **Archivos Core:** `motor_precios.py` (Lógica de pandas).
- **Reglas de Negocio Estrictas Aplicadas:**
  1. *Filtro de Descontinuados:* Eliminar inmediatamente cualquier producto cuya descripción (`Desc. item`) inicie por `NO-`.
  2. *Limpieza de Listas Basura:* Excluir las listas internas/pruebas cuyo código sea estrictamente: `'01', '02', '1', '2', '13', '15', '101', '102'`.
  3. *Regla de Stock (A):* Un producto se habilita si y solo si su `Cant. disponible > 0` AND su `Costo prom. unit. > 0`.
  4. *Regla de Gramaje (B):* Si un producto indica en la columna `U.M. Inv.` ser `KILO`, se valida estrictamente que la columna `Peso en KILO` sea `1`.

## Módulo 2: Rescate Interactivo (UI Predictiva)
- **Objetivo:** Interfaz intermedia para el humano. Presenta los productos descartados por el módulo 1 y permite forzar su inclusión mediante un buscador.
- **Flujo:** Usuario escribe código en buscador → UI filtra lista → Selecciona código → UI genera un Chip/Badge visual del producto rescatado → UI anexa los rescatados y vuelve a enviar todo (archivos + rescatados) al backend.
- **Responsabilidad:** Frontend puro (`static/index.html`).

## Módulo 3: Procesador Final y Dibujado
- **Objetivo:** Recibir los datos consolidados y generar Excels listos para imprimir o enviar.
- **Endpoints:** `/api/procesar` (POST).
- **Flujo:** Backend procesa DataFrame Final → Inyecta Rescatados como Inmunes → Ordena Alfabéticamente → Genera `pivot_table` → Exporta Reporte General → Itera Asesores → Filtra Pivot por Asesor → Exporta Asesores → Inserta Logs SQL → Comprime en `.ZIP` → Retorna ZIP.
- **Reglas de Negocio Estrictas:**
  1. *Ordenamiento Alfabético:* Prioridad 1 `LINEA` (Categoría), Prioridad 2 `Desc. item` (Producto).
  2. *Organización de Columnas:* La empresa exige que si existen listas comerciales, siempre se impriman de izquierda a derecha en el siguiente orden sagrado: `['11', '12', '03', '04', '05', '06', '07', '08', '09', '10', '14', '16']`. Las ajenas se deshechan.
  3. *Auditoría:* Se inyecta registro en tabla `Historico_Generaciones` obligatoriamente antes de escupir el Excel.

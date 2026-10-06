# Problemas Frecuentes y Troubleshooting

Durante la vida temprana del proyecto, nos enfrentamos a desafíos técnicos clave relacionados con la base de datos y la exportación matemática de las interfaces gráficas de Excel. Si eres el nuevo desarrollador heredando esto, por favor lee estos escenarios primero antes de buscar bugs fantasma.

---

## 1. Conexión Silenciosa Bloqueada (Solo se genera Reporte GENERAL)
- **Síntoma:** El sistema procesa los archivos Excel con normalidad, devuelve el `.ZIP`, y adentro solo encuentras el `reporte_GENERAL.xlsx`. Los reportes individuales de los asesores (Ej: `BOGOTA - JOHN MILLER.xlsx`) no aparecen. Adicionalmente, las cabeceras numéricas no muestran sus nombres traducidos (Ej: "ABASTOS").
- **Posible Causa (Histórica):** Actualización a SQL Server 2025. El motor de Microsoft introdujo un requerimiento estricto que bloquea conexiones entrantes de aplicaciones si no se especifican certificados de seguridad. Dado que nuestro código Python posee bloques `try/except` envolviendo las consultas a la base de datos (para ser resiliente), el error de certificado se oculta y Pandas simplemente retorna DataFrames vacíos, iterando sobre "nada".
- **Solución (Ya aplicada):** En el archivo `motor_precios.py`, dentro de la variable de configuración de ODBC, se añadió el parámetro `TrustServerCertificate=yes`.
- **Dónde revisar si vuelve a pasar:** Busca advertencias impresas en la consola (Ej: `print(f"Alerta Maestro_Listas: {e}")`). Revisa si el Administrador del servidor removió los permisos de conexión.

---

## 2. Error 26 (SQL Network Interfaces) al arrancar el proyecto
- **Síntoma:** Al arrancar el servidor `uvicorn main:app` o intentar hacer dump, la consola crashea mostrando: *"Error relacionado con la red o específico de la instancia mientras se establecía una conexión con el servidor SQL Server... (Error 26)"*
- **Posible Causa:** Python está apuntando a un nombre de motor de Base de Datos que no existe en el equipo.
- **Solución:**
  1. Revisar el archivo oculto `.env` en la raíz.
  2. Si el cliente usa SQL Express local, la variable debe ser obligatoriamente: `DB_HOST=.\SQLEXPRESS`.
  3. Si el cliente instaló el visual studio o LocalDB, usar: `DB_HOST=(localdb)\MSSQLLocalDB`.

---

## 3. Desfase Visual en el Formato de Moneda ($)
- **Síntoma:** Al observar un reporte de Excel generado, todas las celdas de precios en una categoría (ej. GRANOS Y LEGUMINOSAS) tienen un perfecto formato contable ($1.500,00), pero la **última fila** antes de saltar a la siguiente categoría se muestra como un número plano bruto (1500.0).
- **Posible Causa (Histórica):** El ciclo de formateo condicional iteraba basándose en una variable matemática manual `current_row = current_row + 1`. Al inyectar títulos gruesos (`ws.merge_cells`) o espacios decorativos intermedios, la variable matemática se desincronizaba de la matriz real de memoria en la librería `openpyxl`.
- **Solución (Ya aplicada):** Se eliminaron las lógicas basadas en la variable `current_row - 1`. Ahora el bloque de diseño utiliza el atributo interno `ws.max_row` garantizando que el diseño de moneda se aplique a la fila idéntica que el script acaba de anexar mediante `ws.append()`. 
- **Archivos Relacionados:** `motor_precios.py` (Función `exportar_excel_categorizado`).

---

## 4. Discos duros llenos de basura en producción
- **Síntoma:** El sistema lanza advertencia de límite de almacenamiento (disco local lleno).
- **Dónde revisar:** Carpeta `/uploads`.
- **Solución:** Originalmente los archivos subidos al endpoint `/api/procesar` se borraban al final de la línea. Si el código fallaba en el medio, los Excels se acumulaban. Se reescribió `main.py` utilizando una arquitectura `try / finally` validando `os.path.exists()` para forzar la purga obligatoria de basuras subidas sin importar los crasheos del backend. Si encuentras basura acumulada hoy en día, significa que Uvicorn se cerró abruptamente. Purgar manual.

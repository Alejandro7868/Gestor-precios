from fastapi import FastAPI, File, UploadFile, HTTPException, Form
from fastapi.responses import HTMLResponse, FileResponse
from fastapi.staticfiles import StaticFiles
import shutil
import os
import pandas as pd
from motor_precios import procesar_reportes, analizar_reportes
import uuid
import traceback
import json

app = FastAPI(title="Gestor de Precios Automático")

UPLOAD_DIR = "uploads"
OUTPUT_DIR = "output"
os.makedirs(UPLOAD_DIR, exist_ok=True)
os.makedirs(OUTPUT_DIR, exist_ok=True)

os.makedirs("static", exist_ok=True)
app.mount("/static", StaticFiles(directory="static"), name="static")

@app.get("/", response_class=HTMLResponse)
async def serve_frontend():
    index_path = os.path.join("static", "index.html")
    if os.path.exists(index_path):
        with open(index_path, "r", encoding="utf-8") as f:
            return HTMLResponse(content=f.read())
    return HTMLResponse(content="<h1>Frontend no encontrado</h1>", status_code=404)

@app.post("/api/analizar")
async def analizar_archivos(
    precios: UploadFile = File(...), 
    inventario: UploadFile = File(...)
):
    precios_path = None
    inventario_path = None
    try:
        uid = uuid.uuid4().hex
        precios_path = os.path.join(UPLOAD_DIR, f"precios_ana_{uid}.xlsx")
        inventario_path = os.path.join(UPLOAD_DIR, f"inv_ana_{uid}.xlsx")
        
        with open(precios_path, "wb") as buffer:
            shutil.copyfileobj(precios.file, buffer)
            
        with open(inventario_path, "wb") as buffer:
            shutil.copyfileobj(inventario.file, buffer)
            
        df_precios = pd.read_excel(precios_path)
        df_inventario = pd.read_excel(inventario_path)
        
        resultado_analisis = analizar_reportes(df_precios, df_inventario)
        
        return resultado_analisis
    except Exception as e:
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        if precios_path and os.path.exists(precios_path):
            os.remove(precios_path)
        if inventario_path and os.path.exists(inventario_path):
            os.remove(inventario_path)

@app.post("/api/procesar")
async def procesar_archivos(
    precios: UploadFile = File(...), 
    inventario: UploadFile = File(...),
    items_rescatados: str = Form("[]")
):
    precios_path = None
    inventario_path = None
    try:
        rescatados_list = json.loads(items_rescatados)
        
        uid = uuid.uuid4().hex
        precios_path = os.path.join(UPLOAD_DIR, f"precios_{uid}.xlsx")
        inventario_path = os.path.join(UPLOAD_DIR, f"inventario_{uid}.xlsx")
        
        with open(precios_path, "wb") as buffer:
            shutil.copyfileobj(precios.file, buffer)
            
        with open(inventario_path, "wb") as buffer:
            shutil.copyfileobj(inventario.file, buffer)
            
        df_precios = pd.read_excel(precios_path)
        df_inventario = pd.read_excel(inventario_path)
        
        archivos_generados = procesar_reportes(df_precios, df_inventario, OUTPUT_DIR, rescatados=rescatados_list)
        
        return {
            "mensaje": "Proceso completado exitosamente.",
            "archivos": [os.path.basename(f) for f in archivos_generados]
        }
    except Exception as e:
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        if precios_path and os.path.exists(precios_path):
            os.remove(precios_path)
        if inventario_path and os.path.exists(inventario_path):
            os.remove(inventario_path)

@app.get("/api/descargar/{filename}")
async def descargar_archivo(filename: str):
    file_path = os.path.join(OUTPUT_DIR, filename)
    if os.path.exists(file_path):
        return FileResponse(
            file_path, 
            filename=filename, 
            media_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        )
    raise HTTPException(status_code=404, detail="Archivo no encontrado")

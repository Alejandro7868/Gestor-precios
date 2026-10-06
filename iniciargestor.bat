@echo off
title Servidor - Gestor de Precios
echo ===================================================
echo     Iniciando Servidor del Gestor de Precios...
echo ===================================================
echo.
echo Por favor, NO cierre esta ventana negra. 
echo Si la cierra, el sistema dejara de funcionar.
echo.

:: 1. Activar el entorno virtual
call venv\Scripts\activate

:: 2. Iniciar FastAPI con Uvicorn en segundo plano
start /B uvicorn main:app --host 127.0.0.1 --port 8000

:: 3. Esperar 3 segundos para dar tiempo a que el servidor encienda
timeout /t 3 /nobreak > NUL

:: 4. Abrir automaticamente el navegador web
start http://127.0.0.1:8000

echo Servidor en linea. El navegador se ha abierto correctamente.
echo (Puede minimizar esta ventana)
import pandas as pd
from sqlalchemy import create_engine
import urllib.parse
import os
from dotenv import load_dotenv

load_dotenv()
DB_HOST = os.getenv("DB_HOST", "(localdb)\\MSSQLLocalDB")
DB_NAME = os.getenv("DB_NAME", "GestorPrecios")

params = urllib.parse.quote_plus(
    f"DRIVER={{ODBC Driver 17 for SQL Server}};"
    f"SERVER={DB_HOST};"
    f"DATABASE={DB_NAME};"
    f"Trusted_Connection=yes;"
)
engine = create_engine(f"mssql+pyodbc:///?odbc_connect={params}")

tablas = ['Maestro_Asesores', 'Maestro_Impuestos', 'Maestro_Listas', 'Items_Manuales']
output_file = 'datos_maestros.sql'

with open(output_file, 'w', encoding='utf-8') as f:
    f.write(f"USE {DB_NAME};\nGO\n\n")
    for tabla in tablas:
        try:
            df = pd.read_sql(f"SELECT * FROM {tabla}", engine)
            if df.empty:
                continue
            
            f.write(f"-- Datos para {tabla}\n")
            if tabla == 'Maestro_Asesores' or tabla == 'Historico_Generaciones':
                f.write(f"SET IDENTITY_INSERT {tabla} ON;\n")
                
            for _, row in df.iterrows():
                cols = ', '.join([f"[{c}]" for c in df.columns])
                
                vals = []
                for val in row:
                    if pd.isna(val):
                        vals.append("NULL")
                    elif isinstance(val, (int, float)):
                        vals.append(str(val))
                    else:
                        clean_val = str(val).replace("'", "''")
                        vals.append(f"'{clean_val}'")
                        
                vals_str = ', '.join(vals)
                f.write(f"INSERT INTO {tabla} ({cols}) VALUES ({vals_str});\n")
                
            if tabla == 'Maestro_Asesores' or tabla == 'Historico_Generaciones':
                f.write(f"SET IDENTITY_INSERT {tabla} OFF;\n")
            f.write("GO\n\n")
        except Exception as e:
            print(f"Error procesando {tabla}: {e}")

print(f"Archivo {output_file} generado con éxito.")

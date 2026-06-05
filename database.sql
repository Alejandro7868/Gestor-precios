-- Creación de la base de datos (Opcional, pero recomendado para aislar las tablas)
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'GestorPrecios')
BEGIN
    CREATE DATABASE GestorPrecios;
END
GO

USE GestorPrecios;
GO

-- 1. Maestro_Asesores
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Maestro_Asesores]') AND type in (N'U'))
BEGIN
    CREATE TABLE Maestro_Asesores (
        id INT IDENTITY(1,1) PRIMARY KEY,
        nombre_asesor VARCHAR(150) NOT NULL,
        zona VARCHAR(100),
        listas_asignadas VARCHAR(255) -- Ej: "03, 04, 12"
    );
END
GO

-- 2. Maestro_Impuestos
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Maestro_Impuestos]') AND type in (N'U'))
BEGIN
    CREATE TABLE Maestro_Impuestos (
        codigo_impositivo VARCHAR(50) PRIMARY KEY,
        porcentaje_iva DECIMAL(5,2) NOT NULL
    );
END
GO

-- 3. Items_Manuales (Excepciones de Inmunidad)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Items_Manuales]') AND type in (N'U'))
BEGIN
    CREATE TABLE Items_Manuales (
        item VARCHAR(100) PRIMARY KEY,
        fecha_agregado DATETIME DEFAULT GETDATE()
    );
END
GO

-- 4. Historico_Generaciones
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Historico_Generaciones]') AND type in (N'U'))
BEGIN
    CREATE TABLE Historico_Generaciones (
        id INT IDENTITY(1,1) PRIMARY KEY,
        fecha DATETIME NOT NULL DEFAULT GETDATE(),
        item VARCHAR(100) NOT NULL,
        descripcion VARCHAR(255),
        precio_con_impuesto DECIMAL(18,4),
        lista VARCHAR(50) NOT NULL,
        asesor_destino VARCHAR(150) NOT NULL
    );
END
GO

-- 5. Maestro_Listas (Dual Header)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Maestro_Listas]') AND type in (N'U'))
BEGIN
    CREATE TABLE Maestro_Listas (
        codigo_lista VARCHAR(50) PRIMARY KEY,
        nombre_lista VARCHAR(150) NOT NULL
    );
END
GO

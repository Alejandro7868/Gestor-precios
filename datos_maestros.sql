USE GestorPrecios;
GO

-- Datos para Maestro_Asesores
SET IDENTITY_INSERT Maestro_Asesores ON;
INSERT INTO Maestro_Asesores ([id], [nombre_asesor], [zona], [listas_asignadas]) VALUES (1, 'BOGOTA - JOHN MILLER', 'BOGOTA', '03, 04, 12');
INSERT INTO Maestro_Asesores ([id], [nombre_asesor], [zona], [listas_asignadas]) VALUES (2, 'BOYACA - ISABEL BENITEZ', 'BOYACA', '05, 06, 10, 12');
INSERT INTO Maestro_Asesores ([id], [nombre_asesor], [zona], [listas_asignadas]) VALUES (3, 'CASANARE - EFRAIN SALAMANCA', 'CASANARE', '09, 16, 08, 12');
INSERT INTO Maestro_Asesores ([id], [nombre_asesor], [zona], [listas_asignadas]) VALUES (4, 'CUNDINAMARCA - ALEJANDRA VANEGAS', 'CUNDINAMARCA', '06, 05, 12');
INSERT INTO Maestro_Asesores ([id], [nombre_asesor], [zona], [listas_asignadas]) VALUES (5, 'VILLAVICENCIO - DIANA - YINED', 'VILLAVICENCIO', '07, 08, 14, 10, 04, 12');
INSERT INTO Maestro_Asesores ([id], [nombre_asesor], [zona], [listas_asignadas]) VALUES (6, 'YOPAL - ALEXANDER', 'YOPAL', '09, 08, 12');
SET IDENTITY_INSERT Maestro_Asesores OFF;
GO

-- Datos para Maestro_Impuestos
INSERT INTO Maestro_Impuestos ([codigo_impositivo], [porcentaje_iva]) VALUES ('016', 0.16);
INSERT INTO Maestro_Impuestos ([codigo_impositivo], [porcentaje_iva]) VALUES ('027', 0.27);
INSERT INTO Maestro_Impuestos ([codigo_impositivo], [porcentaje_iva]) VALUES ('028', 0.28);
INSERT INTO Maestro_Impuestos ([codigo_impositivo], [porcentaje_iva]) VALUES ('033', 0.33);
INSERT INTO Maestro_Impuestos ([codigo_impositivo], [porcentaje_iva]) VALUES ('EC', 0.0);
INSERT INTO Maestro_Impuestos ([codigo_impositivo], [porcentaje_iva]) VALUES ('V02', 0.02);
INSERT INTO Maestro_Impuestos ([codigo_impositivo], [porcentaje_iva]) VALUES ('V04', 0.04);
INSERT INTO Maestro_Impuestos ([codigo_impositivo], [porcentaje_iva]) VALUES ('V05', 0.05);
INSERT INTO Maestro_Impuestos ([codigo_impositivo], [porcentaje_iva]) VALUES ('V10', 0.1);
INSERT INTO Maestro_Impuestos ([codigo_impositivo], [porcentaje_iva]) VALUES ('V16', 0.16);
INSERT INTO Maestro_Impuestos ([codigo_impositivo], [porcentaje_iva]) VALUES ('V20', 0.2);
GO

-- Datos para Maestro_Listas
INSERT INTO Maestro_Listas ([codigo_lista], [nombre_lista]) VALUES ('03', 'ABASTOS');
INSERT INTO Maestro_Listas ([codigo_lista], [nombre_lista]) VALUES ('04', 'BOGOTA');
INSERT INTO Maestro_Listas ([codigo_lista], [nombre_lista]) VALUES ('05', 'SABANA');
INSERT INTO Maestro_Listas ([codigo_lista], [nombre_lista]) VALUES ('06', 'BOYACA');
INSERT INTO Maestro_Listas ([codigo_lista], [nombre_lista]) VALUES ('07', 'VILLAVICENCIO');
INSERT INTO Maestro_Listas ([codigo_lista], [nombre_lista]) VALUES ('08', 'META');
INSERT INTO Maestro_Listas ([codigo_lista], [nombre_lista]) VALUES ('09', 'CASANARE');
INSERT INTO Maestro_Listas ([codigo_lista], [nombre_lista]) VALUES ('10', 'SANTANDER');
INSERT INTO Maestro_Listas ([codigo_lista], [nombre_lista]) VALUES ('11', 'BODEGA');
INSERT INTO Maestro_Listas ([codigo_lista], [nombre_lista]) VALUES ('12', 'VENTANILLA');
INSERT INTO Maestro_Listas ([codigo_lista], [nombre_lista]) VALUES ('14', 'PTO GAITAN');
INSERT INTO Maestro_Listas ([codigo_lista], [nombre_lista]) VALUES ('16', 'OROCUE');
GO


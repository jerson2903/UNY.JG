--  BASE DE DATOS UNY
DROP DATABASE IF EXISTS UNY;
CREATE DATABASE UNY;
USE UNY;

-- 1- Tabla de ALUMNO
DROP TABLE IF EXISTS ALUMNO;
CREATE TABLE ALUMNO (
  ID INT(5) NOT NULL AUTO_INCREMENT,
  Nombre VARCHAR(30) NOT NULL,
  Apellido VARCHAR(35) NOT NULL,
  Direccion VARCHAR(75) NOT NULL,
  Email VARCHAR(45) DEFAULT NULL,
  Fecha_Nacimiento DATE,
  Estado VARCHAR(70) NOT NULL,
  Municipio VARCHAR(15) DEFAULT NULL,
  PRIMARY KEY (ID)
);

-- 2- Tabla de Historico de Alumnos
DROP TABLE IF EXISTS HISTORICO_ALUMNO;
CREATE TABLE HISTORICO_ALUMNO (
  ID_ALUM INT(5) NOT NULL,
  Nombre VARCHAR(30) NOT NULL,
  Apellido VARCHAR(35) NOT NULL,
  Estado VARCHAR(70) NOT NULL,
  Usuario_Activo VARCHAR(40),
  Fecha_Ingreso DATE,
  Hora_Registro TIME,
  PRIMARY KEY (ID_ALUM)
);

-- 3- Tabla de historico de operaciones
DROP TABLE IF EXISTS HISTORICO_OPERACIONES;
CREATE TABLE HISTORICO_OPERACIONES (
  ID_BORRADO INT(5) NOT NULL,
  Nombre_BORRADO VARCHAR(30) NOT NULL,
  Apellido_BORRADO VARCHAR(35) NOT NULL,
  Usuario_Activo VARCHAR(40),
  Fecha_BORRADO DATE,
  Hora_BORRADO TIME,
  PRIMARY KEY (ID_BORRADO)
);

-- 4 Disparador despues de la inserción de ALUMNO
CREATE TRIGGER trg_ALUMNO AFTER INSERT ON ALUMNO
FOR EACH ROW
  INSERT INTO HISTORICO_ALUMNO (ID_ALUM, Nombre, Apellido, Estado, Usuario_Activo, Fecha_Ingreso, Hora_Registro)
  VALUES (NEW.ID, NEW.Nombre, NEW.Apellido, NEW.Estado, CURRENT_USER(), CURDATE(), CURTIME());
  
-- 5- Procedimiento para ingresar alumno
DROP PROCEDURE IF EXISTS ingresarAlumno;
DELIMITER //
CREATE PROCEDURE ingresarAlumno(
  IN p_nombre VARCHAR(30),
  IN p_apellido VARCHAR(35),
  IN p_direccion VARCHAR(75),
  IN p_email VARCHAR(45),
  IN p_fecha_nacimiento DATE,
  IN p_estado VARCHAR(70),
  IN p_municipio VARCHAR(15)
)
BEGIN
  INSERT INTO ALUMNO (Nombre, Apellido, Direccion, Email, Fecha_Nacimiento, Estado, Municipio)
  VALUES (p_nombre, p_apellido, p_direccion, p_email, p_fecha_nacimiento, p_estado, p_municipio);
END 
// 
DELIMITER ;

-- 6- Agregar 10 registros en la tabla ALUMNO con el procedimiento desarrollado

CALL ingresarAlumno('Juan', 'Pérez', 'Calle 1', 'juan@example.com', '1990-01-01', 'Activo', 'Ciudad 1');
CALL ingresarAlumno('María', 'García', 'Calle 2', 'maria@example.com', '1991-01-01', 'Activo', 'Ciudad 2');
CALL ingresarAlumno('Pedro', 'Martínez', 'Calle 3', 'pedro@example.com', '1992-01-01', 'Activo', 'Ciudad 3');
CALL ingresarAlumno('Ana', 'Rodríguez', 'Calle 4', 'ana@example.com', '1993-01-01', 'Activo', 'Ciudad 4');
CALL ingresarAlumno('Carlos', 'González', 'Calle 5', 'carlos@example.com', '1994-01-01', 'Activo', 'Ciudad 5');
CALL ingresarAlumno('Eva', 'Díaz', 'Calle 6', 'eva@example.com', '1995-01-01', 'Activo', 'Ciudad 6');
CALL ingresarAlumno('Luis', 'Sánchez', 'Calle 7', 'luis@example.com', '1996-01-01', 'Activo', 'Ciudad 7');
CALL ingresarAlumno('Isabel', 'Martín', 'Calle 8', 'isabel@example.com', '1997-01-01', 'Activo', 'Ciudad 8');
CALL ingresarAlumno('Francisco', 'Gómez', 'Calle 9', 'francisco@example.com', '1998-01-01', 'Activo', 'Ciudad 9');
CALL ingresarAlumno('Cristina', 'López', 'Calle 10', 'cristina@example.com', '1998-01-01', 'Activo', 'Ciudad 9');

-- 7- Sentencia Select
SELECT * FROM ALUMNO;
SELECT * FROM HISTORICO_ALUMNO;

-- 8- Disparador antes de eliminacion
CREATE TRIGGER Elimina_ALUM AFTER DELETE ON ALUMNO
FOR EACH ROW
	INSERT INTO HISTORICO_OPERACIONES(ID_BORRADO, Nombre_BORRADO, Apellido_BORRADO, Usuario_Activo, Fecha_BORRADO, Hora_BORRADO)
   	VALUES(OLD.ID, OLD.Nombre, OLD.Apellido, CURRENT_USER(), CURDATE(), CURTIME());
    
-- 9- Eliminar 3 Alummnos

DELETE FROM ALUMNO WHERE ID IN (2, 6, 10);

-- 10- Sentencia Select

SELECT * FROM ALUMNO;
SELECT * FROM HISTORICO_OPERACIONES;

-- 11- Procedimiento Buscar Alumno
DROP PROCEDURE IF EXISTS BuscarAlumno;
DELIMITER //
CREATE PROCEDURE BuscarAlumno(
  IN ID_CONSULTA int,
  OUT nombreA VARCHAR(50),
  OUT apellidoA VARCHAR(50),
  OUT fecha_nacimientoA DATE
)
BEGIN
  SELECT Nombre, Apellido, Fecha_Nacimiento
  INTO nombreA, apellidoA, fecha_nacimientoA
  FROM ALUMNO
  WHERE ID = ID_CONSULTA;
END // 
DELIMITER ;

-- 12  13 Buscar Alumno
CALL BuscarAlumno(5, @nombreA, @apellidoA, @fecha_nacimientoA);
SELECT @nombreA, @apellidoA, @fecha_nacimientoA;

-- 14 Vista reporte
CREATE VIEW ReporteAlumnos AS
SELECT 
  ID_ALUM AS ID_ALUM1,
  Nombre AS Nombre1,
  Apellido AS Apellido1,
  Estado AS Estado1,
  Fecha_Ingreso AS Fecha_Ingreso1
  
FROM HISTORICO_ALUMNO ;
  
  SELECT * FROM ReporteAlumnos;
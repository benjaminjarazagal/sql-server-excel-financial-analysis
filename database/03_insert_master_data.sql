USE FinDataChile;
GO

INSERT INTO Regiones (nombre)
VALUES
    ('Arica y Parinacota'),
    ('Tarapacá'),
    ('Antofagasta'),
    ('Atacama'),
    ('Coquimbo'),
    ('Valparaíso'),
    ('Metropolitana de Santiago'),
    ('O''Higgins'),
    ('Maule'),
    ('Ñuble'),
    ('Biobío'),
    ('La Araucanía'),
    ('Los Ríos'),
    ('Los Lagos'),
    ('Aysén'),
    ('Magallanes y de la Antártica Chilena');
GO

INSERT INTO EstadosCliente (descripcion)
VALUES
    ('Activo'),
    ('Inactivo');
GO

INSERT INTO EstadosOperacion (descripcion)
VALUES
    ('Pendiente'),
    ('Aprobada'),
    ('Rechazada');
GO

INSERT INTO TiposOperacion (nombre, descripcion)
VALUES
    ('Aporte', 'Ingreso de fondos'),
    ('Retiro', 'Retiro de fondos'),
    ('Transferencia', 'Transferencia de fondos'),
    ('Ajuste', 'Ajuste administrativo'),
    ('Devolución', 'Devolución de fondos');
GO
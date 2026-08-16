USE FinDataChile;
GO

CREATE TABLE Regiones (
    id_region INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);
GO

CREATE TABLE EstadosCliente (
    id_estado INT IDENTITY(1,1) PRIMARY KEY,
    descripcion VARCHAR(20) NOT NULL UNIQUE
);
GO

CREATE TABLE EstadosOperacion (
    id_estado INT IDENTITY(1,1) PRIMARY KEY,
    descripcion VARCHAR(20) NOT NULL UNIQUE
);
GO

CREATE TABLE TiposOperacion (
    id_tipo_operacion INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(150)
);
GO

CREATE TABLE Clientes (
    id_cliente INT IDENTITY(1,1) PRIMARY KEY,
    rut VARCHAR(8) NOT NULL,
    dv CHAR(1) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido_paterno VARCHAR(100) NOT NULL,
    apellido_materno VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE,
    id_region INT NOT NULL,
    id_estado INT NOT NULL,
    fecha_registro DATE NOT NULL,

    CONSTRAINT UQ_Clientes_RUT_DV
        UNIQUE (rut, dv),

    CONSTRAINT FK_Clientes_Regiones
        FOREIGN KEY (id_region)
        REFERENCES Regiones(id_region),

    CONSTRAINT FK_Clientes_Estados
        FOREIGN KEY (id_estado)
        REFERENCES EstadosCliente(id_estado)
);
GO

CREATE TABLE Operaciones (
    id_operacion INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_tipo_operacion INT NOT NULL,
    id_estado INT NOT NULL,
    fecha_operacion DATE NOT NULL,
    monto DECIMAL(15,2) NOT NULL,

    CONSTRAINT FK_Operaciones_Clientes
        FOREIGN KEY (id_cliente)
        REFERENCES Clientes(id_cliente),

    CONSTRAINT FK_Operaciones_Tipos
        FOREIGN KEY (id_tipo_operacion)
        REFERENCES TiposOperacion(id_tipo_operacion),

    CONSTRAINT FK_Operaciones_Estados
        FOREIGN KEY (id_estado)
        REFERENCES EstadosOperacion(id_estado),

    CONSTRAINT CK_Operaciones_Monto
        CHECK (monto > 0)
);
GO
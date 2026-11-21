-- =========================================================
-- Base de datos: taller_motos_db  (PostgreSQL)
-- Taller de motos: repuestos, clientes, mecánicos y órdenes de servicio
-- Script 1 de 2: creación de las 5 tablas (ejecutar primero)
-- =========================================================

-- CREATE DATABASE taller_motos_db;
-- \c taller_motos_db

DROP TABLE IF EXISTS ordenes;
DROP TABLE IF EXISTS repuestos;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS mecanicos;

-- Categorías de repuestos (frenos, motor, eléctrico...)
CREATE TABLE categorias (
    id_categoria     SERIAL PRIMARY KEY,
    nombre_categoria VARCHAR(60)  NOT NULL UNIQUE,
    descripcion      VARCHAR(200)
);

-- Repuestos que vende e instala el taller. Cada repuesto pertenece a una categoría.
CREATE TABLE repuestos (
    id_repuesto     SERIAL PRIMARY KEY,
    nombre_repuesto VARCHAR(100)  NOT NULL,
    id_categoria    INTEGER       NOT NULL,
    precio_lista    NUMERIC(12,2) NOT NULL CHECK (precio_lista > 0),
    stock           INTEGER       NOT NULL DEFAULT 0 CHECK (stock >= 0),
    CONSTRAINT fk_repuestos_categoria
        FOREIGN KEY (id_categoria) REFERENCES categorias (id_categoria)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Clientes: dueños de las motos
CREATE TABLE clientes (
    id_cliente     SERIAL PRIMARY KEY,
    nombre_cliente VARCHAR(100) NOT NULL,
    ciudad         VARCHAR(60)  NOT NULL,
    segmento       VARCHAR(30)  NOT NULL
        CHECK (segmento IN ('Persona natural', 'Pyme', 'Corporativo')),
    email          VARCHAR(120) UNIQUE
);

-- Mecánicos del taller
CREATE TABLE mecanicos (
    id_mecanico     SERIAL PRIMARY KEY,
    nombre_mecanico VARCHAR(100)  NOT NULL,
    especialidad    VARCHAR(30)   NOT NULL,
    meta_mensual    NUMERIC(14,2) NOT NULL CHECK (meta_mensual >= 0)
);

-- Órdenes de servicio: qué repuesto se le instaló a qué cliente y qué mecánico lo hizo.
-- Es la tabla con 3 llaves foráneas.
CREATE TABLE ordenes (
    id_orden        SERIAL PRIMARY KEY,
    fecha           DATE          NOT NULL,
    id_cliente      INTEGER       NOT NULL,
    id_repuesto     INTEGER       NOT NULL,
    id_mecanico     INTEGER       NOT NULL,
    cantidad        INTEGER       NOT NULL CHECK (cantidad > 0),
    precio_unitario NUMERIC(12,2) NOT NULL CHECK (precio_unitario > 0),
    descuento       NUMERIC(4,2)  NOT NULL DEFAULT 0
        CHECK (descuento >= 0 AND descuento <= 1),   -- fracción: 0.10 = 10 %
    CONSTRAINT fk_ordenes_cliente
        FOREIGN KEY (id_cliente)  REFERENCES clientes (id_cliente)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_ordenes_repuesto
        FOREIGN KEY (id_repuesto) REFERENCES repuestos (id_repuesto)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_ordenes_mecanico
        FOREIGN KEY (id_mecanico) REFERENCES mecanicos (id_mecanico)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE INDEX idx_repuestos_categoria ON repuestos (id_categoria);
CREATE INDEX idx_ordenes_cliente     ON ordenes (id_cliente);
CREATE INDEX idx_ordenes_repuesto    ON ordenes (id_repuesto);
CREATE INDEX idx_ordenes_mecanico    ON ordenes (id_mecanico);
CREATE INDEX idx_ordenes_fecha       ON ordenes (fecha);

-- =========================================================
-- Base de datos: taller_motos_db
-- Script 2 de 2: carga de datos (10 registros por tabla)
-- Ejecutar después de 01_creacion.sql
-- =========================================================

INSERT INTO categorias (nombre_categoria, descripcion) VALUES
('Frenos',             'Pastillas, bandas, discos y líquido de frenos'),
('Motor',              'Pistones, anillos, empaques y válvulas'),
('Sistema eléctrico',  'Baterías, bujías, reguladores y cableado'),
('Llantas',            'Llantas y neumáticos delanteros y traseros'),
('Lubricantes',        'Aceites de motor y de transmisión'),
('Transmisión',        'Kits de arrastre, cadenas, piñones y coronas'),
('Suspensión',         'Amortiguadores, barras y retenedores'),
('Iluminación',        'Farolas, direccionales y bombillos LED'),
('Accesorios',         'Cascos, guantes, espejos y protectores'),
('Escapes',            'Silenciadores y tubos de escape');

INSERT INTO repuestos (nombre_repuesto, id_categoria, precio_lista, stock) VALUES
('Pastillas de freno delanteras',         1,  45000.00, 30),
('Kit de pistón y anillos 125 cc',        2, 120000.00, 12),
('Batería 12 V 5 Ah',                     3,  95000.00, 20),
('Llanta trasera 90/90-18',               4, 160000.00, 15),
('Aceite 20W-50 4T de 1 litro',           5,  32000.00, 60),
('Kit de arrastre 428',                   6, 135000.00, 18),
('Amortiguadores traseros (par)',         7, 210000.00,  8),
('Bombillo LED para farola',              8,  38000.00, 40),
('Casco abatible certificado',            9, 280000.00, 10),
('Silenciador de escape deportivo',      10, 250000.00,  5);

INSERT INTO clientes (nombre_cliente, ciudad, segmento, email) VALUES
('Juan David Rojas',               'Neiva',     'Persona natural', 'juan.rojas@mail.com'),
('Mensajería Rápida del Huila',    'Neiva',     'Pyme',            'flota@mensajeriarapida.co'),
('Luisa Fernanda Muñoz',           'Pitalito',  'Persona natural', 'luisa.munoz@mail.com'),
('Domicilios Express S.A.S.',      'Neiva',     'Pyme',            'operaciones@domiexpress.co'),
('Electrificadora del Sur',        'Garzón',    'Corporativo',     'transporte@electrosur.com.co'),
('Andrés Felipe Tovar',            'La Plata',  'Persona natural', 'andres.tovar@mail.com'),
('Alcaldía de Campoalegre',        'Campoalegre','Corporativo',    'parqueautomotor@campoalegre.gov.co'),
('Carolina Perdomo Silva',         'Neiva',     'Persona natural', 'carolina.perdomo@mail.com'),
('Distribuidora La Esquina',       'Gigante',   'Pyme',            'pedidos@laesquina.co'),
('Policía Departamental del Huila','Neiva',     'Corporativo',     'logistica@policiahuila.gov.co');

INSERT INTO mecanicos (nombre_mecanico, especialidad, meta_mensual) VALUES
('Óscar Javier Cuéllar',   'Motor',                 6000000.00),
('Wilson Andrés Trujillo', 'Frenos',                4500000.00),
('Fabián Ramírez Osorio',  'Sistema eléctrico',     5000000.00),
('Edwin Alexis Polanía',   'Suspensión',            4000000.00),
('Jhon Fredy Medina',      'Mantenimiento general', 5500000.00),
('Diego Armando Vargas',   'Motor',                 6500000.00),
('Yeison Camilo Losada',   'Frenos',                4200000.00),
('Sandra Milena Charry',   'Sistema eléctrico',     4800000.00),
('Luis Eduardo Quintero',  'Mantenimiento general', 5200000.00),
('Brayan Steven Ortiz',    'Suspensión',            3900000.00);

INSERT INTO ordenes (fecha, id_cliente, id_repuesto, id_mecanico, cantidad, precio_unitario, descuento) VALUES
('2026-11-02',  1,  1,  2, 1,  45000.00, 0.00),
('2026-11-03',  2,  5,  5, 6,  32000.00, 0.10),
('2026-11-05',  4,  6,  1, 3, 135000.00, 0.05),
('2026-11-07',  3,  3,  3, 1,  95000.00, 0.00),
('2026-11-09',  5,  4,  5, 4, 160000.00, 0.12),
('2026-11-11',  6,  7,  4, 1, 210000.00, 0.00),
('2026-11-13', 10,  2,  6, 2, 120000.00, 0.15),
('2026-11-15',  8,  8,  8, 2,  38000.00, 0.00),
('2026-11-17',  9,  9,  9, 1, 280000.00, 0.05),
('2026-11-19',  7, 10, 10, 1, 250000.00, 0.00);

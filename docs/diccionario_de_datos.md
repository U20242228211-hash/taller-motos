# Diccionario de datos · `taller_motos_db`

Todas las tablas usan PostgreSQL. PK = llave primaria · FK = llave foránea · UQ = único · CK = restricción CHECK.

## categorias

| Campo | Tipo | Nulo | Llave / restricción | Descripción |
|---|---|---|---|---|
| id_categoria | SERIAL | No | PK | Identificador de la categoría |
| nombre_categoria | VARCHAR(60) | No | UQ | Nombre de la categoría (Frenos, Motor…) |
| descripcion | VARCHAR(200) | Sí | — | Qué tipo de repuestos incluye |

## repuestos

| Campo | Tipo | Nulo | Llave / restricción | Descripción |
|---|---|---|---|---|
| id_repuesto | SERIAL | No | PK | Identificador del repuesto |
| nombre_repuesto | VARCHAR(100) | No | — | Nombre del repuesto |
| id_categoria | INTEGER | No | FK → categorias | Categoría a la que pertenece |
| precio_lista | NUMERIC(12,2) | No | CK > 0 | Precio de venta actual, en pesos |
| stock | INTEGER | No | CK ≥ 0, por defecto 0 | Unidades disponibles |

## clientes

| Campo | Tipo | Nulo | Llave / restricción | Descripción |
|---|---|---|---|---|
| id_cliente | SERIAL | No | PK | Identificador del cliente |
| nombre_cliente | VARCHAR(100) | No | — | Nombre de la persona o empresa |
| ciudad | VARCHAR(60) | No | — | Ciudad del cliente |
| segmento | VARCHAR(30) | No | CK en ('Persona natural', 'Pyme', 'Corporativo') | Tipo de cliente |
| email | VARCHAR(120) | Sí | UQ | Correo de contacto |

## mecanicos

| Campo | Tipo | Nulo | Llave / restricción | Descripción |
|---|---|---|---|---|
| id_mecanico | SERIAL | No | PK | Identificador del mecánico |
| nombre_mecanico | VARCHAR(100) | No | — | Nombre completo |
| especialidad | VARCHAR(30) | No | — | Motor, Frenos, Sistema eléctrico, Suspensión o Mantenimiento general |
| meta_mensual | NUMERIC(14,2) | No | CK ≥ 0 | Meta de facturación mensual, en pesos |

## ordenes

| Campo | Tipo | Nulo | Llave / restricción | Descripción |
|---|---|---|---|---|
| id_orden | SERIAL | No | PK | Número de la orden de servicio |
| fecha | DATE | No | — | Día de la orden |
| id_cliente | INTEGER | No | FK → clientes | Dueño de la moto |
| id_repuesto | INTEGER | No | FK → repuestos | Repuesto instalado |
| id_mecanico | INTEGER | No | FK → mecanicos | Mecánico que hizo el trabajo |
| cantidad | INTEGER | No | CK > 0 | Unidades del repuesto |
| precio_unitario | NUMERIC(12,2) | No | CK > 0 | Precio cobrado ese día por unidad |
| descuento | NUMERIC(4,2) | No | CK entre 0 y 1, por defecto 0 | Descuento como fracción (0.10 = 10 %) |

El total de cada orden no se guarda: se calcula al listar como `cantidad × precio_unitario × (1 − descuento)`.

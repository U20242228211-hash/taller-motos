--
-- PostgreSQL database dump
--


-- Dumped from database version 17.11
-- Dumped by pg_dump version 17.11

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: categorias; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categorias (
    id_categoria integer NOT NULL,
    nombre_categoria character varying(60) NOT NULL,
    descripcion character varying(200)
);


--
-- Name: categorias_id_categoria_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categorias_id_categoria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categorias_id_categoria_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categorias_id_categoria_seq OWNED BY public.categorias.id_categoria;


--
-- Name: clientes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clientes (
    id_cliente integer NOT NULL,
    nombre_cliente character varying(100) NOT NULL,
    ciudad character varying(60) NOT NULL,
    segmento character varying(30) NOT NULL,
    email character varying(120),
    CONSTRAINT clientes_segmento_check CHECK (((segmento)::text = ANY ((ARRAY['Persona natural'::character varying, 'Pyme'::character varying, 'Corporativo'::character varying])::text[])))
);


--
-- Name: clientes_id_cliente_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clientes_id_cliente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clientes_id_cliente_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.clientes_id_cliente_seq OWNED BY public.clientes.id_cliente;


--
-- Name: mecanicos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mecanicos (
    id_mecanico integer NOT NULL,
    nombre_mecanico character varying(100) NOT NULL,
    especialidad character varying(30) NOT NULL,
    meta_mensual numeric(14,2) NOT NULL,
    CONSTRAINT mecanicos_meta_mensual_check CHECK ((meta_mensual >= (0)::numeric))
);


--
-- Name: mecanicos_id_mecanico_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mecanicos_id_mecanico_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mecanicos_id_mecanico_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mecanicos_id_mecanico_seq OWNED BY public.mecanicos.id_mecanico;


--
-- Name: ordenes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ordenes (
    id_orden integer NOT NULL,
    fecha date NOT NULL,
    id_cliente integer NOT NULL,
    id_repuesto integer NOT NULL,
    id_mecanico integer NOT NULL,
    cantidad integer NOT NULL,
    precio_unitario numeric(12,2) NOT NULL,
    descuento numeric(4,2) DEFAULT 0 NOT NULL,
    CONSTRAINT ordenes_cantidad_check CHECK ((cantidad > 0)),
    CONSTRAINT ordenes_descuento_check CHECK (((descuento >= (0)::numeric) AND (descuento <= (1)::numeric))),
    CONSTRAINT ordenes_precio_unitario_check CHECK ((precio_unitario > (0)::numeric))
);


--
-- Name: ordenes_id_orden_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ordenes_id_orden_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ordenes_id_orden_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ordenes_id_orden_seq OWNED BY public.ordenes.id_orden;


--
-- Name: repuestos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.repuestos (
    id_repuesto integer NOT NULL,
    nombre_repuesto character varying(100) NOT NULL,
    id_categoria integer NOT NULL,
    precio_lista numeric(12,2) NOT NULL,
    stock integer DEFAULT 0 NOT NULL,
    CONSTRAINT repuestos_precio_lista_check CHECK ((precio_lista > (0)::numeric)),
    CONSTRAINT repuestos_stock_check CHECK ((stock >= 0))
);


--
-- Name: repuestos_id_repuesto_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.repuestos_id_repuesto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: repuestos_id_repuesto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.repuestos_id_repuesto_seq OWNED BY public.repuestos.id_repuesto;


--
-- Name: categorias id_categoria; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorias ALTER COLUMN id_categoria SET DEFAULT nextval('public.categorias_id_categoria_seq'::regclass);


--
-- Name: clientes id_cliente; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clientes ALTER COLUMN id_cliente SET DEFAULT nextval('public.clientes_id_cliente_seq'::regclass);


--
-- Name: mecanicos id_mecanico; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mecanicos ALTER COLUMN id_mecanico SET DEFAULT nextval('public.mecanicos_id_mecanico_seq'::regclass);


--
-- Name: ordenes id_orden; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ordenes ALTER COLUMN id_orden SET DEFAULT nextval('public.ordenes_id_orden_seq'::regclass);


--
-- Name: repuestos id_repuesto; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repuestos ALTER COLUMN id_repuesto SET DEFAULT nextval('public.repuestos_id_repuesto_seq'::regclass);


--
-- Data for Name: categorias; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.categorias (id_categoria, nombre_categoria, descripcion) FROM stdin;
1	Frenos	Pastillas, bandas, discos y líquido de frenos
2	Motor	Pistones, anillos, empaques y válvulas
3	Sistema eléctrico	Baterías, bujías, reguladores y cableado
4	Llantas	Llantas y neumáticos delanteros y traseros
5	Lubricantes	Aceites de motor y de transmisión
6	Transmisión	Kits de arrastre, cadenas, piñones y coronas
7	Suspensión	Amortiguadores, barras y retenedores
8	Iluminación	Farolas, direccionales y bombillos LED
9	Accesorios	Cascos, guantes, espejos y protectores
10	Escapes	Silenciadores y tubos de escape
\.


--
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.clientes (id_cliente, nombre_cliente, ciudad, segmento, email) FROM stdin;
1	Juan David Rojas	Neiva	Persona natural	juan.rojas@mail.com
2	Mensajería Rápida del Huila	Neiva	Pyme	flota@mensajeriarapida.co
3	Luisa Fernanda Muñoz	Pitalito	Persona natural	luisa.munoz@mail.com
4	Domicilios Express S.A.S.	Neiva	Pyme	operaciones@domiexpress.co
5	Electrificadora del Sur	Garzón	Corporativo	transporte@electrosur.com.co
6	Andrés Felipe Tovar	La Plata	Persona natural	andres.tovar@mail.com
7	Alcaldía de Campoalegre	Campoalegre	Corporativo	parqueautomotor@campoalegre.gov.co
8	Carolina Perdomo Silva	Neiva	Persona natural	carolina.perdomo@mail.com
9	Distribuidora La Esquina	Gigante	Pyme	pedidos@laesquina.co
10	Policía Departamental del Huila	Neiva	Corporativo	logistica@policiahuila.gov.co
\.


--
-- Data for Name: mecanicos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.mecanicos (id_mecanico, nombre_mecanico, especialidad, meta_mensual) FROM stdin;
1	Óscar Javier Cuéllar	Motor	6000000.00
2	Wilson Andrés Trujillo	Frenos	4500000.00
3	Fabián Ramírez Osorio	Sistema eléctrico	5000000.00
4	Edwin Alexis Polanía	Suspensión	4000000.00
5	Jhon Fredy Medina	Mantenimiento general	5500000.00
6	Diego Armando Vargas	Motor	6500000.00
7	Yeison Camilo Losada	Frenos	4200000.00
8	Sandra Milena Charry	Sistema eléctrico	4800000.00
9	Luis Eduardo Quintero	Mantenimiento general	5200000.00
10	Brayan Steven Ortiz	Suspensión	3900000.00
\.


--
-- Data for Name: ordenes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ordenes (id_orden, fecha, id_cliente, id_repuesto, id_mecanico, cantidad, precio_unitario, descuento) FROM stdin;
1	2026-11-02	1	1	2	1	45000.00	0.00
2	2026-11-03	2	5	5	6	32000.00	0.10
3	2026-11-05	4	6	1	3	135000.00	0.05
4	2026-11-07	3	3	3	1	95000.00	0.00
5	2026-11-09	5	4	5	4	160000.00	0.12
6	2026-11-11	6	7	4	1	210000.00	0.00
7	2026-11-13	10	2	6	2	120000.00	0.15
8	2026-11-15	8	8	8	2	38000.00	0.00
9	2026-11-17	9	9	9	1	280000.00	0.05
10	2026-11-19	7	10	10	1	250000.00	0.00
\.


--
-- Data for Name: repuestos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.repuestos (id_repuesto, nombre_repuesto, id_categoria, precio_lista, stock) FROM stdin;
1	Pastillas de freno delanteras	1	45000.00	30
2	Kit de pistón y anillos 125 cc	2	120000.00	12
3	Batería 12 V 5 Ah	3	95000.00	20
4	Llanta trasera 90/90-18	4	160000.00	15
5	Aceite 20W-50 4T de 1 litro	5	32000.00	60
6	Kit de arrastre 428	6	135000.00	18
7	Amortiguadores traseros (par)	7	210000.00	8
8	Bombillo LED para farola	8	38000.00	40
9	Casco abatible certificado	9	280000.00	10
10	Silenciador de escape deportivo	10	250000.00	5
\.


--
-- Name: categorias_id_categoria_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.categorias_id_categoria_seq', 12, true);


--
-- Name: clientes_id_cliente_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.clientes_id_cliente_seq', 12, true);


--
-- Name: mecanicos_id_mecanico_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.mecanicos_id_mecanico_seq', 11, true);


--
-- Name: ordenes_id_orden_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ordenes_id_orden_seq', 11, true);


--
-- Name: repuestos_id_repuesto_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.repuestos_id_repuesto_seq', 12, true);


--
-- Name: categorias categorias_nombre_categoria_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categorias_nombre_categoria_key UNIQUE (nombre_categoria);


--
-- Name: categorias categorias_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categorias_pkey PRIMARY KEY (id_categoria);


--
-- Name: clientes clientes_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_email_key UNIQUE (email);


--
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id_cliente);


--
-- Name: mecanicos mecanicos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mecanicos
    ADD CONSTRAINT mecanicos_pkey PRIMARY KEY (id_mecanico);


--
-- Name: ordenes ordenes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ordenes
    ADD CONSTRAINT ordenes_pkey PRIMARY KEY (id_orden);


--
-- Name: repuestos repuestos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repuestos
    ADD CONSTRAINT repuestos_pkey PRIMARY KEY (id_repuesto);


--
-- Name: idx_ordenes_cliente; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ordenes_cliente ON public.ordenes USING btree (id_cliente);


--
-- Name: idx_ordenes_fecha; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ordenes_fecha ON public.ordenes USING btree (fecha);


--
-- Name: idx_ordenes_mecanico; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ordenes_mecanico ON public.ordenes USING btree (id_mecanico);


--
-- Name: idx_ordenes_repuesto; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ordenes_repuesto ON public.ordenes USING btree (id_repuesto);


--
-- Name: idx_repuestos_categoria; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_repuestos_categoria ON public.repuestos USING btree (id_categoria);


--
-- Name: ordenes fk_ordenes_cliente; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ordenes
    ADD CONSTRAINT fk_ordenes_cliente FOREIGN KEY (id_cliente) REFERENCES public.clientes(id_cliente) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ordenes fk_ordenes_mecanico; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ordenes
    ADD CONSTRAINT fk_ordenes_mecanico FOREIGN KEY (id_mecanico) REFERENCES public.mecanicos(id_mecanico) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ordenes fk_ordenes_repuesto; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ordenes
    ADD CONSTRAINT fk_ordenes_repuesto FOREIGN KEY (id_repuesto) REFERENCES public.repuestos(id_repuesto) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: repuestos fk_repuestos_categoria; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repuestos
    ADD CONSTRAINT fk_repuestos_categoria FOREIGN KEY (id_categoria) REFERENCES public.categorias(id_categoria) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--



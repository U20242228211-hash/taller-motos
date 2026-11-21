"""Pruebas de punta a punta del CRUD contra la base taller_motos_db real.

Cada prueba crea sus propios registros y los elimina al final,
así que los 10 registros originales de cada tabla no se modifican.

Ejecutar con:  python -m pytest -v
"""
import psycopg2
import pytest

from app import create_app
from config import Config

PREFIJO = "ZZ_TEST_"


@pytest.fixture()
def client():
    app = create_app()
    app.config["TESTING"] = True
    with app.test_client() as c:
        yield c


def sql(consulta, params=()):
    conn = psycopg2.connect(host=Config.DB_HOST, port=Config.DB_PORT, dbname=Config.DB_NAME,
                            user=Config.DB_USER, password=Config.DB_PASSWORD)
    with conn, conn.cursor() as cur:
        cur.execute(consulta, params)
        resultado = cur.fetchone() if cur.description else None
    conn.close()
    return resultado


def contar(tabla):
    return sql(f"SELECT COUNT(*) FROM {tabla}")[0]


# ---------------------------------------------------------------- páginas

@pytest.mark.parametrize("ruta", ["/", "/categorias/", "/repuestos/", "/clientes/",
                                  "/mecanicos/", "/ordenes/", "/categorias/nuevo",
                                  "/repuestos/nuevo", "/clientes/nuevo", "/mecanicos/nuevo",
                                  "/ordenes/nuevo", "/categorias/1/editar", "/repuestos/1/editar",
                                  "/clientes/1/editar", "/mecanicos/1/editar",
                                  "/ordenes/1/editar"])
def test_paginas_cargan(client, ruta):
    assert client.get(ruta).status_code == 200


def test_registro_inexistente_da_404(client):
    assert client.get("/repuestos/999999/editar").status_code == 404


def test_listados_muestran_datos(client):
    assert "Pastillas de freno delanteras" in client.get("/repuestos/").get_data(as_text=True)
    assert "Juan David Rojas" in client.get("/ordenes/").get_data(as_text=True)


# ---------------------------------------------------------------- categorias

def test_crud_categorias(client):
    antes = contar("categorias")
    r = client.post("/categorias/nuevo", data={"nombre_categoria": PREFIJO + "Cat",
                                               "descripcion": "prueba"}, follow_redirects=True)
    assert "Categoría creada" in r.get_data(as_text=True)
    id_ = sql("SELECT id_categoria FROM categorias WHERE nombre_categoria=%s", (PREFIJO + "Cat",))[0]

    r = client.post(f"/categorias/{id_}/editar", data={"nombre_categoria": PREFIJO + "Cat2",
                                                       "descripcion": ""}, follow_redirects=True)
    assert "actualizada" in r.get_data(as_text=True)
    assert sql("SELECT nombre_categoria, descripcion FROM categorias WHERE id_categoria=%s",
               (id_,)) == (PREFIJO + "Cat2", None)

    r = client.post(f"/categorias/{id_}/eliminar", follow_redirects=True)
    assert "eliminada" in r.get_data(as_text=True)
    assert contar("categorias") == antes


def test_categoria_duplicada_y_vacia(client):
    r = client.post("/categorias/nuevo", data={"nombre_categoria": "Frenos"})
    assert "Ya existe un registro" in r.get_data(as_text=True)
    r = client.post("/categorias/nuevo", data={"nombre_categoria": "  "})
    assert "es obligatorio" in r.get_data(as_text=True)


def test_no_elimina_categoria_con_productos(client):
    r = client.post("/categorias/1/eliminar", follow_redirects=True)
    assert "relacionado" in r.get_data(as_text=True)
    assert sql("SELECT COUNT(*) FROM categorias WHERE id_categoria=1")[0] == 1


# ---------------------------------------------------------------- repuestos

def test_crud_productos(client):
    datos = {"nombre_repuesto": PREFIJO + "Prod", "id_categoria": "3",
             "precio_lista": "12345.50", "stock": "7"}
    r = client.post("/repuestos/nuevo", data=datos, follow_redirects=True)
    assert "Repuesto creado" in r.get_data(as_text=True)
    id_ = sql("SELECT id_repuesto FROM repuestos WHERE nombre_repuesto=%s", (PREFIJO + "Prod",))[0]

    r = client.post(f"/repuestos/{id_}/editar",
                    data={**datos, "precio_lista": "999", "stock": "0"}, follow_redirects=True)
    assert "actualizado" in r.get_data(as_text=True)
    precio, stock = sql("SELECT precio_lista, stock FROM repuestos WHERE id_repuesto=%s", (id_,))
    assert float(precio) == 999 and stock == 0

    client.post(f"/repuestos/{id_}/eliminar")
    assert sql("SELECT COUNT(*) FROM repuestos WHERE id_repuesto=%s", (id_,))[0] == 0


def test_producto_valores_invalidos(client):
    r = client.post("/repuestos/nuevo", data={"nombre_repuesto": "X", "id_categoria": "",
                                              "precio_lista": "-5", "stock": "abc"})
    html = r.get_data(as_text=True)
    assert "Categoría" in html and "mayor que 0" in html and "número entero" in html


def test_producto_con_categoria_inexistente(client):
    r = client.post("/repuestos/nuevo", data={"nombre_repuesto": PREFIJO + "X",
                                              "id_categoria": "999999", "precio_lista": "1",
                                              "stock": "1"})
    assert "relacionado" in r.get_data(as_text=True)


# ---------------------------------------------------------------- clientes

def test_crud_clientes(client):
    datos = {"nombre_cliente": PREFIJO + "Cli", "ciudad": "Neiva", "segmento": "Pyme",
             "email": "zz_test@ejemplo.co"}
    r = client.post("/clientes/nuevo", data=datos, follow_redirects=True)
    assert "Cliente creado" in r.get_data(as_text=True)
    id_ = sql("SELECT id_cliente FROM clientes WHERE nombre_cliente=%s", (PREFIJO + "Cli",))[0]

    r = client.post(f"/clientes/{id_}/editar",
                    data={**datos, "segmento": "Corporativo", "email": ""}, follow_redirects=True)
    assert "actualizado" in r.get_data(as_text=True)
    assert sql("SELECT segmento, email FROM clientes WHERE id_cliente=%s",
               (id_,)) == ("Corporativo", None)

    client.post(f"/clientes/{id_}/eliminar")
    assert sql("SELECT COUNT(*) FROM clientes WHERE id_cliente=%s", (id_,))[0] == 0


def test_cliente_email_duplicado_y_segmento_invalido(client):
    r = client.post("/clientes/nuevo", data={"nombre_cliente": "X", "ciudad": "Neiva",
                                             "segmento": "Pyme",
                                             "email": "juan.rojas@mail.com"})
    assert "Ya existe un registro" in r.get_data(as_text=True)
    r = client.post("/clientes/nuevo", data={"nombre_cliente": "X", "ciudad": "Neiva",
                                             "segmento": "Otro", "email": "malo"})
    html = r.get_data(as_text=True)
    assert "Segmento no válido" in html and "formato válido" in html


def test_no_elimina_cliente_con_ventas(client):
    r = client.post("/clientes/1/eliminar", follow_redirects=True)
    assert "relacionado" in r.get_data(as_text=True)


# ---------------------------------------------------------------- mecanicos

def test_crud_vendedores(client):
    datos = {"nombre_mecanico": PREFIJO + "Ven", "especialidad": "Frenos", "meta_mensual": "1500000"}
    r = client.post("/mecanicos/nuevo", data=datos, follow_redirects=True)
    assert "Mecánico creado" in r.get_data(as_text=True)
    id_ = sql("SELECT id_mecanico FROM mecanicos WHERE nombre_mecanico=%s", (PREFIJO + "Ven",))[0]

    r = client.post(f"/mecanicos/{id_}/editar", data={**datos, "especialidad": "Motor"},
                    follow_redirects=True)
    assert "actualizado" in r.get_data(as_text=True)
    assert sql("SELECT especialidad FROM mecanicos WHERE id_mecanico=%s", (id_,))[0] == "Motor"

    client.post(f"/mecanicos/{id_}/eliminar")
    assert sql("SELECT COUNT(*) FROM mecanicos WHERE id_mecanico=%s", (id_,))[0] == 0


# ---------------------------------------------------------------- ordenes

def test_crud_ventas(client):
    antes = contar("ordenes")
    datos = {"fecha": "2026-10-23", "id_cliente": "2", "id_repuesto": "4", "id_mecanico": "3",
             "cantidad": "3", "precio_unitario": "980000", "descuento": "10"}
    r = client.post("/ordenes/nuevo", data=datos, follow_redirects=True)
    assert "Orden registrada" in r.get_data(as_text=True)
    id_, desc = sql("SELECT id_orden, descuento FROM ordenes ORDER BY id_orden DESC LIMIT 1")
    assert float(desc) == 0.10  # 10 % se guarda como 0.10

    # el formulario de edición muestra el descuento como porcentaje
    assert 'value="10"' in client.get(f"/ordenes/{id_}/editar").get_data(as_text=True)

    r = client.post(f"/ordenes/{id_}/editar", data={**datos, "cantidad": "5", "descuento": "15"},
                    follow_redirects=True)
    assert "actualizada" in r.get_data(as_text=True)
    cant, desc = sql("SELECT cantidad, descuento FROM ordenes WHERE id_orden=%s", (id_,))
    assert cant == 5 and float(desc) == 0.15

    # 12.5 % no cabe en NUMERIC(4,2): se rechaza en lugar de redondearse en silencio
    r = client.post(f"/ordenes/{id_}/editar", data={**datos, "descuento": "12.5"})
    assert "número entero" in r.get_data(as_text=True)

    client.post(f"/ordenes/{id_}/eliminar")
    assert contar("ordenes") == antes


def test_venta_invalida(client):
    r = client.post("/ordenes/nuevo", data={"fecha": "", "id_cliente": "1", "id_repuesto": "1",
                                           "id_mecanico": "1", "cantidad": "0",
                                           "precio_unitario": "100", "descuento": "150"})
    html = r.get_data(as_text=True)
    assert "«Fecha» es obligatorio" in html and "mayor o igual a 1" in html and "menor o igual a 100" in html


def test_eliminar_inexistente(client):
    r = client.post("/ordenes/999999/eliminar", follow_redirects=True)
    assert "no existe" in r.get_data(as_text=True)


# ---------------------------------------------------------------- integridad final

def test_datos_originales_intactos():
    for tabla in ["categorias", "repuestos", "clientes", "mecanicos", "ordenes"]:
        assert contar(tabla) == 10, tabla

"""CRUD de la tabla ordenes (FK a clientes, repuestos y mecanicos).

En la base de datos el descuento se guarda como fracción (0.10 = 10 %).
En el formulario se captura como porcentaje (10) para que sea más natural.
"""
from decimal import Decimal

from flask import Blueprint, abort, flash, redirect, render_template, request, url_for

import validators as v
from db import DatabaseError, error_message, execute, query

bp = Blueprint("ordenes", __name__, url_prefix="/ordenes")


def _leer_formulario(form):
    errores = []
    datos = {
        "fecha": v.fecha(form, "fecha", "Fecha", errores),
        "id_cliente": v.entero(form, "id_cliente", "Cliente", errores, minimo=1),
        "id_repuesto": v.entero(form, "id_repuesto", "Repuesto", errores, minimo=1),
        "id_mecanico": v.entero(form, "id_mecanico", "Mecánico", errores, minimo=1),
        "cantidad": v.entero(form, "cantidad", "Cantidad", errores, minimo=1),
        "precio_unitario": v.decimal(form, "precio_unitario", "Precio unitario", errores,
                                     mayor_que=0),
        # La columna es NUMERIC(4,2): solo admite porcentajes enteros (0.10, 0.15...)
        "descuento": v.entero(form, "descuento", "Descuento (%)", errores, minimo=0),
    }
    if datos["descuento"] is not None and datos["descuento"] > 100:
        errores.append("«Descuento (%)» debe ser menor o igual a 100.")
    if datos["descuento"] is not None:
        datos["descuento"] = datos["descuento"] / Decimal(100)  # % -> fracción
    return datos, errores


def _render_form(item, titulo):
    return render_template(
        "ordenes/form.html", item=item, titulo=titulo,
        clientes=query("SELECT id_cliente, nombre_cliente FROM clientes ORDER BY nombre_cliente"),
        repuestos=query("SELECT id_repuesto, nombre_repuesto, precio_lista "
                        "FROM repuestos ORDER BY nombre_repuesto"),
        mecanicos=query("SELECT id_mecanico, nombre_mecanico FROM mecanicos "
                         "ORDER BY nombre_mecanico"),
    )


@bp.route("/")
def listar():
    items = query("""
        SELECT v.*, c.nombre_cliente, p.nombre_repuesto, ve.nombre_mecanico,
               v.cantidad * v.precio_unitario * (1 - v.descuento) AS total
          FROM ordenes v
          JOIN clientes   c  ON c.id_cliente   = v.id_cliente
          JOIN repuestos  p  ON p.id_repuesto  = v.id_repuesto
          JOIN mecanicos ve ON ve.id_mecanico = v.id_mecanico
         ORDER BY v.fecha DESC, v.id_orden DESC
    """)
    return render_template("ordenes/list.html", items=items)


@bp.route("/nuevo", methods=["GET", "POST"])
def crear():
    item = {"descuento": 0, "cantidad": 1}
    if request.method == "POST":
        item = request.form.to_dict()
        datos, errores = _leer_formulario(request.form)
        if not errores:
            try:
                execute("""INSERT INTO ordenes (fecha, id_cliente, id_repuesto, id_mecanico,
                                               cantidad, precio_unitario, descuento)
                           VALUES (%(fecha)s, %(id_cliente)s, %(id_repuesto)s, %(id_mecanico)s,
                                   %(cantidad)s, %(precio_unitario)s, %(descuento)s)""",
                        datos)
                flash("Orden registrada correctamente.", "success")
                return redirect(url_for(".listar"))
            except DatabaseError as exc:
                errores.append(error_message(exc))
        for e in errores:
            flash(e, "danger")
    return _render_form(item, "Nueva orden")


@bp.route("/<int:id>/editar", methods=["GET", "POST"])
def editar(id):
    item = query("SELECT * FROM ordenes WHERE id_orden = %s", (id,), one=True)
    if item is None:
        abort(404)
    item["descuento"] = int(round(item["descuento"] * 100))  # fracción -> %
    if request.method == "POST":
        item = {**item, **request.form.to_dict()}
        datos, errores = _leer_formulario(request.form)
        if not errores:
            try:
                execute("""UPDATE ordenes
                              SET fecha           = %(fecha)s,
                                  id_cliente      = %(id_cliente)s,
                                  id_repuesto     = %(id_repuesto)s,
                                  id_mecanico     = %(id_mecanico)s,
                                  cantidad        = %(cantidad)s,
                                  precio_unitario = %(precio_unitario)s,
                                  descuento       = %(descuento)s
                            WHERE id_orden = %(id)s""",
                        {**datos, "id": id})
                flash("Orden actualizada correctamente.", "success")
                return redirect(url_for(".listar"))
            except DatabaseError as exc:
                errores.append(error_message(exc))
        for e in errores:
            flash(e, "danger")
    return _render_form(item, "Editar orden")


@bp.route("/<int:id>/eliminar", methods=["POST"])
def eliminar(id):
    try:
        if execute("DELETE FROM ordenes WHERE id_orden = %s", (id,)):
            flash("Orden eliminada.", "success")
        else:
            flash("La orden no existe.", "warning")
    except DatabaseError as exc:
        flash(error_message(exc), "danger")
    return redirect(url_for(".listar"))

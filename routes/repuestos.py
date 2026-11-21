"""CRUD de la tabla repuestos (FK a categorias)."""
from flask import Blueprint, abort, flash, redirect, render_template, request, url_for

import validators as v
from db import DatabaseError, error_message, execute, query

bp = Blueprint("repuestos", __name__, url_prefix="/repuestos")


def _leer_formulario(form):
    errores = []
    datos = {
        "nombre_repuesto": v.texto(form, "nombre_repuesto", "Nombre", errores, max_len=100),
        "id_categoria": v.entero(form, "id_categoria", "Categoría", errores, minimo=1),
        "precio_lista": v.decimal(form, "precio_lista", "Precio de lista", errores, mayor_que=0),
        "stock": v.entero(form, "stock", "Stock", errores, minimo=0),
    }
    return datos, errores


def _categorias():
    return query("SELECT id_categoria, nombre_categoria FROM categorias ORDER BY nombre_categoria")


def _render_form(item, titulo):
    return render_template("repuestos/form.html", item=item, titulo=titulo,
                           categorias=_categorias())


@bp.route("/")
def listar():
    items = query("""
        SELECT p.*, c.nombre_categoria
          FROM repuestos p
          JOIN categorias c ON c.id_categoria = p.id_categoria
         ORDER BY p.id_repuesto
    """)
    return render_template("repuestos/list.html", items=items)


@bp.route("/nuevo", methods=["GET", "POST"])
def crear():
    item = {}
    if request.method == "POST":
        item = request.form.to_dict()
        datos, errores = _leer_formulario(request.form)
        if not errores:
            try:
                execute("""INSERT INTO repuestos (nombre_repuesto, id_categoria, precio_lista, stock)
                           VALUES (%(nombre_repuesto)s, %(id_categoria)s, %(precio_lista)s, %(stock)s)""",
                        datos)
                flash("Repuesto creado correctamente.", "success")
                return redirect(url_for(".listar"))
            except DatabaseError as exc:
                errores.append(error_message(exc))
        for e in errores:
            flash(e, "danger")
    return _render_form(item, "Nuevo repuesto")


@bp.route("/<int:id>/editar", methods=["GET", "POST"])
def editar(id):
    item = query("SELECT * FROM repuestos WHERE id_repuesto = %s", (id,), one=True)
    if item is None:
        abort(404)
    if request.method == "POST":
        item = {**item, **request.form.to_dict()}
        datos, errores = _leer_formulario(request.form)
        if not errores:
            try:
                execute("""UPDATE repuestos
                              SET nombre_repuesto = %(nombre_repuesto)s,
                                  id_categoria    = %(id_categoria)s,
                                  precio_lista    = %(precio_lista)s,
                                  stock           = %(stock)s
                            WHERE id_repuesto = %(id)s""",
                        {**datos, "id": id})
                flash("Repuesto actualizado correctamente.", "success")
                return redirect(url_for(".listar"))
            except DatabaseError as exc:
                errores.append(error_message(exc))
        for e in errores:
            flash(e, "danger")
    return _render_form(item, "Editar repuesto")


@bp.route("/<int:id>/eliminar", methods=["POST"])
def eliminar(id):
    try:
        if execute("DELETE FROM repuestos WHERE id_repuesto = %s", (id,)):
            flash("Repuesto eliminado.", "success")
        else:
            flash("El repuesto no existe.", "warning")
    except DatabaseError as exc:
        flash(error_message(exc), "danger")
    return redirect(url_for(".listar"))

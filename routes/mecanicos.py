"""CRUD de la tabla mecanicos (mecánicos del taller)."""
from flask import Blueprint, abort, flash, redirect, render_template, request, url_for

import validators as v
from db import DatabaseError, error_message, execute, query

bp = Blueprint("mecanicos", __name__, url_prefix="/mecanicos")

ESPECIALIDADES = ["Motor", "Frenos", "Sistema eléctrico", "Suspensión", "Mantenimiento general"]


def _leer_formulario(form):
    errores = []
    datos = {
        "nombre_mecanico": v.texto(form, "nombre_mecanico", "Nombre", errores, max_len=100),
        "especialidad": v.texto(form, "especialidad", "Especialidad", errores, max_len=30),
        "meta_mensual": v.decimal(form, "meta_mensual", "Meta mensual", errores, minimo=0),
    }
    return datos, errores


def _render_form(item, titulo):
    return render_template("mecanicos/form.html", item=item, titulo=titulo, especialidades=ESPECIALIDADES)


@bp.route("/")
def listar():
    items = query("""
        SELECT ve.*,
               COALESCE(SUM(v.cantidad * v.precio_unitario * (1 - v.descuento)), 0) AS total_vendido
          FROM mecanicos ve
          LEFT JOIN ordenes v ON v.id_mecanico = ve.id_mecanico
         GROUP BY ve.id_mecanico
         ORDER BY ve.id_mecanico
    """)
    return render_template("mecanicos/list.html", items=items)


@bp.route("/nuevo", methods=["GET", "POST"])
def crear():
    item = {}
    if request.method == "POST":
        item = request.form.to_dict()
        datos, errores = _leer_formulario(request.form)
        if not errores:
            try:
                execute("""INSERT INTO mecanicos (nombre_mecanico, especialidad, meta_mensual)
                           VALUES (%(nombre_mecanico)s, %(especialidad)s, %(meta_mensual)s)""",
                        datos)
                flash("Mecánico creado correctamente.", "success")
                return redirect(url_for(".listar"))
            except DatabaseError as exc:
                errores.append(error_message(exc))
        for e in errores:
            flash(e, "danger")
    return _render_form(item, "Nuevo mecánico")


@bp.route("/<int:id>/editar", methods=["GET", "POST"])
def editar(id):
    item = query("SELECT * FROM mecanicos WHERE id_mecanico = %s", (id,), one=True)
    if item is None:
        abort(404)
    if request.method == "POST":
        item = {**item, **request.form.to_dict()}
        datos, errores = _leer_formulario(request.form)
        if not errores:
            try:
                execute("""UPDATE mecanicos
                              SET nombre_mecanico = %(nombre_mecanico)s,
                                  especialidad            = %(especialidad)s,
                                  meta_mensual    = %(meta_mensual)s
                            WHERE id_mecanico = %(id)s""",
                        {**datos, "id": id})
                flash("Mecánico actualizado correctamente.", "success")
                return redirect(url_for(".listar"))
            except DatabaseError as exc:
                errores.append(error_message(exc))
        for e in errores:
            flash(e, "danger")
    return _render_form(item, "Editar mecánico")


@bp.route("/<int:id>/eliminar", methods=["POST"])
def eliminar(id):
    try:
        if execute("DELETE FROM mecanicos WHERE id_mecanico = %s", (id,)):
            flash("Mecánico eliminado.", "success")
        else:
            flash("El mecánico no existe.", "warning")
    except DatabaseError as exc:
        flash(error_message(exc), "danger")
    return redirect(url_for(".listar"))

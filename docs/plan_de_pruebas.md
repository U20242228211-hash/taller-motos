# Plan de pruebas · 15 casos

Cada caso se ejecutó sobre la aplicación corriendo con la base `taller_motos_db` (10 registros por tabla).
La captura de cada uno está en `docs/capturas/`. Después de las pruebas la base quedó otra vez con 10 registros por
tabla. Además, `tests/test_crud.py` tiene **32 pruebas automáticas con pytest** (`python -m pytest -v`): todas pasan.

| N.º | Qué se prueba | Datos / pasos | Resultado esperado | Resultado | Captura |
|---|---|---|---|---|---|
| 1 | Panel de inicio | Abrir `/` | Muestra las 5 tablas con 10 registros y el total facturado | ✅ Cumple | [01](capturas/01-inicio.png) |
| 2 | Listar repuestos | Abrir `/repuestos/` | Se ve el **nombre** de la categoría, no su ID; precio en pesos | ✅ Cumple | [02](capturas/02-listar-repuestos.png) |
| 3 | Crear categoría válida | Nombre «Herramientas» y descripción | Mensaje «Categoría creada correctamente» y aparece en la lista | ✅ Cumple | [03](capturas/03-crear-categoria.png) |
| 4 | Categoría duplicada | Nombre «Frenos», que ya existe | Mensaje «Ya existe un registro con ese valor» (error 23505) | ✅ Cumple | [04](capturas/04-categoria-duplicada.png) |
| 5 | Repuesto con datos inválidos | Nombre vacío, sin categoría, precio −5, stock «abc» | Un mensaje por cada campo malo; no se guarda | ✅ Cumple | [05](capturas/05-repuesto-datos-invalidos.png) |
| 6 | Editar: formulario precargado | Abrir `/repuestos/1/editar` | El formulario trae los datos actuales del repuesto 1 | ✅ Cumple | [06](capturas/06-editar-repuesto-precargado.png) |
| 7 | Editar y guardar | Cambiar el stock del repuesto 1 de 30 a 28 | Mensaje «Repuesto actualizado correctamente» | ✅ Cumple | [07](capturas/07-editar-repuesto-guardado.png) |
| 8 | Cliente con datos inválidos | Segmento «Otro» y email «correo-malo» | «Segmento no válido» y «no tiene un formato válido» | ✅ Cumple | [08](capturas/08-cliente-datos-invalidos.png) |
| 9 | Email duplicado | Email «juan.rojas@mail.com», que ya existe | Mensaje «Ya existe un registro con ese valor» | ✅ Cumple | [09](capturas/09-cliente-email-duplicado.png) |
| 10 | Borrar un cliente con órdenes | Eliminar al cliente 1 | No se borra: mensaje de llave foránea (error 23503) | ✅ Cumple | [10](capturas/10-eliminar-cliente-con-ordenes.png) |
| 11 | Crear mecánico | «Cristian Camilo Rojas», Frenos, meta 4 000 000 | Mensaje «Mecánico creado correctamente» | ✅ Cumple | [11](capturas/11-crear-mecanico.png) |
| 12 | Crear orden (3 llaves foráneas) | Cliente 2, repuesto 5, mecánico 5, cantidad 2 | «Orden registrada correctamente»; la lista muestra los nombres de cliente, repuesto y mecánico | ✅ Cumple | [12](capturas/12-crear-orden.png) |
| 13 | Orden con descuento inválido | Descuento 150 % | «Descuento (%) debe ser menor o igual a 100»; no se guarda | ✅ Cumple | [13](capturas/13-orden-descuento-invalido.png) |
| 14 | Eliminar con confirmación | Eliminar la orden creada en el caso 12 (pide confirmar; se envía por POST) | Mensaje «Orden eliminada» | ✅ Cumple | [14](capturas/14-eliminar-orden.png) |
| 15 | Registro que no existe | Abrir `/repuestos/999999/editar` | Página 404 en lugar de un error | ✅ Cumple | [15](capturas/15-registro-inexistente-404.png) |

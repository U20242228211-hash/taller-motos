# Plan de pruebas · 3 casos por tabla (15 en total)

Las pruebas se hicieron sobre la aplicación con la base `taller_motos_db` cargada (10 registros por tabla). Cada caso
tiene su captura en `docs/capturas/`. Al terminar, la base quedó otra vez con 10 registros por tabla.
Como valor agregado, `tests/test_crud.py` tiene **32 pruebas automáticas con pytest** (`python -m pytest -v`) y todas
pasan.

| ID | Tabla | Operación | Datos de entrada | Resultado esperado | Resultado obtenido | Evidencia |
|---|---|---|---|---|---|---|
| CP-01 | categorias | Crear | Nombre «Herramientas» y descripción | Se guarda, sale «Categoría creada correctamente» y aparece en el listado | Cumple ✓ | [captura](capturas/CP-01-categoria-crear.png) |
| CP-02 | categorias | Crear | Nombre «Frenos», que ya existe | Mensaje de valor duplicado (error 23505) | Cumple ✓ | [captura](capturas/CP-02-categoria-duplicada.png) |
| CP-03 | categorias | Eliminar | Categoría «Frenos», que tiene repuestos | Mensaje: no se puede eliminar (error 23503) | Cumple ✓ | [captura](capturas/CP-03-categoria-eliminar-relacionada.png) |
| CP-04 | repuestos | Listar | Abrir `/repuestos/` | Se ve el nombre de la categoría (no el ID) y el precio en pesos | Cumple ✓ | [captura](capturas/CP-04-repuesto-listar.png) |
| CP-05 | repuestos | Crear | Nombre vacío, sin categoría, precio −5, stock «abc» | Un mensaje por cada campo inválido y no se guarda | Cumple ✓ | [captura](capturas/CP-05-repuesto-datos-invalidos.png) |
| CP-06 | repuestos | Editar | Repuesto 1: el formulario sale precargado; se cambia el stock de 30 a 28 | «Repuesto actualizado correctamente» | Cumple ✓ | [precargado](capturas/CP-06-repuesto-editar-precargado.png) · [guardado](capturas/CP-06-repuesto-editar-guardado.png) |
| CP-07 | clientes | Crear | Segmento «Otro» y correo «correo-malo» | «Segmento no válido» y «no tiene un formato válido» | Cumple ✓ | [captura](capturas/CP-07-cliente-datos-invalidos.png) |
| CP-08 | clientes | Crear | Correo «juan.rojas@mail.com», ya registrado | Mensaje de valor duplicado | Cumple ✓ | [captura](capturas/CP-08-cliente-email-duplicado.png) |
| CP-09 | clientes | Eliminar | Cliente 1, que tiene órdenes | Mensaje: no se puede eliminar | Cumple ✓ | [captura](capturas/CP-09-cliente-eliminar-relacionado.png) |
| CP-10 | mecanicos | Crear | «Cristian Camilo Rojas», Frenos, meta 4 000 000 | «Mecánico creado correctamente» y aparece en el listado | Cumple ✓ | [captura](capturas/CP-10-mecanico-crear.png) |
| CP-11 | mecanicos | Editar | Mismo mecánico: especialidad Motor, meta 4 500 000 | «Mecánico actualizado correctamente» | Cumple ✓ | [captura](capturas/CP-11-mecanico-editar.png) |
| CP-12 | mecanicos | Eliminar | Mismo mecánico (sin órdenes), con confirmación | «Mecánico eliminado» | Cumple ✓ | [captura](capturas/CP-12-mecanico-eliminar.png) |
| CP-13 | ordenes | Crear | Cliente 2, repuesto 5, mecánico 5, cantidad 2 (3 llaves foráneas con listas desplegables) | «Orden registrada correctamente»; el listado muestra los nombres | Cumple ✓ | [captura](capturas/CP-13-orden-crear.png) |
| CP-14 | ordenes | Crear | Descuento de 150 % | «Descuento (%) debe ser menor o igual a 100» y no se guarda | Cumple ✓ | [captura](capturas/CP-14-orden-descuento-invalido.png) |
| CP-15 | ordenes | Eliminar | La orden del CP-13, con confirmación | «Orden eliminada» | Cumple ✓ | [captura](capturas/CP-15-orden-eliminar.png) |

Casos adicionales:

| ID | Qué | Resultado esperado | Resultado obtenido | Evidencia |
|---|---|---|---|---|
| CP-16 | Panel de inicio | Las 5 tablas con su número de registros y el total facturado | Cumple ✓ | [captura](capturas/CP-16-panel-inicio.png) |
| CP-17 | Abrir un registro que no existe (`/repuestos/999999/editar`) | Página 404 en lugar de un error | Cumple ✓ | [captura](capturas/CP-17-registro-inexistente-404.png) |

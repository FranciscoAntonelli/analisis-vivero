import pandas as pd
from database import conectar

def extraer_datos():
    conexion = conectar()

    productos = pd.read_sql("SELECT * FROM productos", conexion) # pd.read_sql() es una función de pandas que permite ejecutar una consulta SQL y devolver el resultado como un DataFrame. En este caso, se está ejecutando la consulta "SELECT * FROM productos" para obtener todos los registros de la tabla "productos" de la base de datos conectada mediante la función conectar().
    clientes = pd.read_sql("SELECT * FROM clientes", conexion)
    ventas = pd.read_sql("SELECT * FROM ventas", conexion)
    categorias = pd.read_sql("SELECT * FROM categorias", conexion)
    detalle_ventas = pd.read_sql("SELECT * FROM detalle_ventas", conexion)
    fechas = pd.read_sql("SELECT * FROM fechas", conexion)
    stocks = pd.read_sql("SELECT * FROM stocks", conexion)

    conexion.close()

    return {
        "productos": productos,
        "clientes": clientes,
        "ventas": ventas,
        "categorias": categorias,
        "detalle_ventas": detalle_ventas,
        "fechas": fechas,
        "stocks": stocks
    }
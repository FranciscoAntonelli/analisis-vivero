import psycopg2

def conectar():
    return psycopg2.connect(
        host="localhost",
        database="analisis_vivero",
        user="postgres",
        password="cuvl1234"
    )
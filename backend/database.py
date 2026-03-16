import psycopg2

def get_connection():
    conn=psycopg2.connect(
    host="localhost",
    database="DocForge_Hub",
    user="postgres",
    password="postgres123",
    port="5432"
)
    return conn
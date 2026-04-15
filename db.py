# db.py
import mysql.connector

def get_db_connection():
    """
    Returns a MySQL database connection.
    Update host, user, password, and database according to your setup.
    """
    conn = mysql.connector.connect(
        host="localhost",        # Your MySQL host
        user="root",             # Your MySQL username
        password="",             # Your MySQL password
        database="college_db"    # Your database name
    )
    return conn
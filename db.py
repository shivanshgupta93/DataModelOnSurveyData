import pyodbc
from consts import DB_NAME, SERVER_NAME
import os

class DB:
    __con = None

    def __init__(self): ### constructor of DB class
        if not DB.__con:
            DB.__con = self.create_db_cursor()

    def create_db_cursor(self):
        con = pyodbc.connect("Driver={SQL Server Native Client 11.0};" 
                     "Server="+SERVER_NAME+";" 
                     "Database="+DB_NAME+";" 
                     "Trusted_Connection=yes;")

        return con

    def get_db(self):
        return DB.__con

    def close(self):
        DB.__con.close()
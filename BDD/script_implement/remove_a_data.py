import sys
import psycopg2
from psycopg2.extras import execute_values

"""
    Parameters for database's creation in command line
    ...

    Attributes
    ----------
    user : str
        username of the database owner
    password : str
        password of the database owner
    database : str
        name of the database
    host : str
        hostname of the database (generally localhost)
    port : str
        port of the database (generally 5432)
    tablename : str
        name of the table
    id : int
        id of the data  

    Methods
    -------
    Remove a data with the table name and a id
"""

user      = sys.argv[1] if len(sys.argv) > 1 else None
password  = sys.argv[2] if len(sys.argv) > 2 else None
database  = sys.argv[3] if len(sys.argv) > 3 else None
host      = sys.argv[4] if len(sys.argv) > 4 else None
port      = sys.argv[5] if len(sys.argv) > 5 else None
tablename = sys.argv[6] if len(sys.argv) > 6 else None
id        = sys.argv[7] if len(sys.argv) > 7 else None
debug = False
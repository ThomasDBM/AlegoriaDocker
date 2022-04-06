import pandas as pd
import psycopg2
from psycopg2.extras import execute_values
import sys

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
    csv : str
        name of the csv to import   

    Methods
    -------
    Creation of all the table in the database
"""

user     = sys.argv[1] if len(sys.argv) > 1 else None
password = sys.argv[2] if len(sys.argv) > 2 else None
database = sys.argv[3] if len(sys.argv) > 3 else None
host     = sys.argv[4] if len(sys.argv) > 4 else None
port     = sys.argv[5] if len(sys.argv) > 5 else None
csv      = sys.argv[6] if len(sys.argv) > 6 else None
debug = False

dataframe = pd.read_csv(csv, sep=',')
print(dataframe)

# Database connection block
try:

    # Connection to the database with giving parameters
    connection = psycopg2.connect(
    	user = user,
        password = password,
        host = host,
        port = port,
        database = database
    )

    print("Successful connection.")

    # Database pointer
    cursor = connection.cursor()

    # Execution of each SQL query
    #cursor.execute(create_masks_table)

    # Commit all requests
    #connection.commit()

    #print("The database has been modified according to the queries made.")

except (Exception, psycopg2.Error) as error :
	print('ERROR : '+ str(error))

finally:
	# Closing database connection
	if(connection):
		cursor.close()
		connection.close()


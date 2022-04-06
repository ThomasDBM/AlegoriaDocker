import numpy as np
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

df = pd.read_csv(csv, sep = ',')

df.rename(columns={'photo': 'url', 
                    'nomFichierImg': 'image',
                    'titre': 'tirage',
                    'toponyme': 'ville',
                    'insee': 'insee',
                    'wkt': 'footprint'}, inplace=True)

df = df.dropna()
print(df)

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
    cursor.execute("SELECT id_images FROM images")
    id_images = cursor.fetchall()

    ids = []
    for id in id_images:
        ids.append(id[0])
    i = 0

    cursor.execute("SELECT image FROM images")
    images = cursor.fetchall()
    images_exists = []
    for image in images:
        images_exists.append(image[0])
    print(images_exists)
    verif_images = []
    # Execution of each SQL query
    for index, row in df.iterrows():
        if row['image'] not in verif_images and row['image'] not in images_exists:
            if i not in ids:
                cursor.execute("INSERT INTO images(id_images, t0, t1, image, size_image, id_sources, id_masks) VALUES ("+str(i)+", '2016-06-22 19:10:25-07', '2016-06-22 19:10:25-07', '"+row['image']+"', ST_GeomFromText('POINT(0 0)', 2154), 4, null);")
                i+=1
                verif_images.append(row['image'])
            else:
                while i in ids:
                    i+=1
                cursor.execute("INSERT INTO images(id_images, t0, t1, image, size_image, id_sources, id_masks) VALUES ("+str(i)+", '2016-06-22 19:10:25-07', '2016-06-22 19:10:25-07', '"+row['image']+"', ST_GeomFromText('POINT(0 0)', 2154), 4, null);")
                i+=1
                verif_images.append(row['image'])

    # Commit all requests
    connection.commit()

    print("The database has been modified according to the queries made.")

except (Exception, psycopg2.Error) as error :
	print('ERROR : '+ str(error))

finally:
	# Closing database connection
	if(connection):
		cursor.close()
		connection.close()


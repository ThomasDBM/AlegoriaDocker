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

    # Select all id_sources in database to avoid duplicate id
    cursor.execute("SELECT id_sources FROM sources")
    id_sources = cursor.fetchall()

    ids_sources = []
    for id in id_sources:
        ids_sources.append(id[0])
    i = 0

    # Select all homepage in database to avoid duplicate image due to unique constraint
    cursor.execute("SELECT home FROM sources")
    sources = cursor.fetchall()

    sources_exists = []
    for homepage in sources:
        sources_exists.append(homepage[0])

    cursor.execute("SELECT credit FROM sources")
    s_credit = cursor.fetchall()

    credits_exists = []
    for credit in s_credit:
        credits_exists.append(credit[0])

    verif_sources = []
    verif_credits = []
    for index, row in df.iterrows():
        homepage = (row['url'].split('/id'))[0]
        #credit = (row['url'].split('/'))[4]
        #print(verif_credits, credits_exists)
        #if (homepage not in sources_exists and homepage not in verif_sources) and (credit not in credits_exists and credit not in verif_credits):
        if (homepage not in sources_exists and homepage not in verif_sources):
            if i not in ids_sources:
                cursor.execute("INSERT INTO sources(id_sources, credit, home, url, viewer, thumbnail, lowres, highres, iip, footprint) VALUES ("+str(i)+", '"+(row['url'].split('/'))[4]+"', '"+homepage+"', 'mi4', 'mi4', 'mi4', 'mi4', 'mi4', 'mi4', ST_GeomFromText('MULTIPOLYGON(((1 1,5 1,5 5,1 5,1 1),(2 2,2 3,3 3,3 2,2 2)),((6 3,9 2,9 4,6 3)))', 2154))")
                connection.commit()
                i+=1
                verif_sources.append(homepage)
            else:
                while i in ids_sources:
                    i+=1
                cursor.execute("INSERT INTO sources(id_sources, credit, home, url, viewer, thumbnail, lowres, highres, iip, footprint) VALUES ("+str(i)+", '"+(row['url'].split('/'))[4]+"', '"+homepage+"', 'mi4', 'mi4', 'mi4', 'mi4', 'mi4', 'mi4', ST_GeomFromText('MULTIPOLYGON(((1 1,5 1,5 5,1 5,1 1),(2 2,2 3,3 3,3 2,2 2)),((6 3,9 2,9 4,6 3)))', 2154))")
                connection.commit()
                i+=1
                verif_sources.append(homepage)

    print("Sources succefully added.")

    # Select all id_images in database to avoid duplicate id
    cursor.execute("SELECT id_images FROM images")
    id_images = cursor.fetchall()

    ids = []
    for id in id_images:
        ids.append(id[0])
    i = 0

    # Select all image in database to avoid duplicate image due to unique constraint
    cursor.execute("SELECT image FROM images")
    images = cursor.fetchall()

    images_exists = []
    for image in images:
        images_exists.append(image[0])
    #print(images_exists)
    verif_images = []

    # Execution of SQL queries to add an image
    # Request the sources of the image to add the right id_sources
    for index, row in df.iterrows():
        homepage = (row['url'].split('/id'))[0]
        cursor.execute("SELECT id_sources FROM sources WHERE home='"+homepage+"'")
        id_of_sources = cursor.fetchall()
        if row['image'] not in verif_images and row['image'] not in images_exists:
            if i not in ids:
                cursor.execute("INSERT INTO images(id_images, t0, t1, image, size_image, id_sources, id_masks) VALUES ("+str(i)+", '2016-06-22 19:10:25-07', '2016-06-22 19:10:25-07', '"+row['image']+"', ST_GeomFromText('POINT(0 0)', 2154), "+str(id_of_sources[0][0])+", null);")
                i+=1
                verif_images.append(row['image'])
            else:
                while i in ids:
                    i+=1
                cursor.execute("INSERT INTO images(id_images, t0, t1, image, size_image, id_sources, id_masks) VALUES ("+str(i)+", '2016-06-22 19:10:25-07', '2016-06-22 19:10:25-07', '"+row['image']+"', ST_GeomFromText('POINT(0 0)', 2154), 0, null);")
                i+=1
                verif_images.append(row['image'])

    # Commit all requests
    connection.commit()

    print("Images succefully added to images table.")

except (Exception, psycopg2.Error) as error :
	print('ERROR : '+ str(error))

finally:
	# Closing database connection
	if(connection):
		cursor.close()
		connection.close()


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

# Import of the csv file
df = pd.read_csv(csv, sep = ',')

# Rename the columns to better understand what they correspond to in the database
df.rename(columns={'photo': 'url', 
                    'nomFichierImg': 'image',
                    'titre': 'tirage',
                    'date': 'date',
                    'toponyme': 'ville',
                    'insee': 'insee',
                    'wkt': 'footprint'}, inplace=True)
# Delete the columns where image is NAN
df = df.dropna()

# Create a new column to associate each image to an id
if 'id_image' in df:
    print("La colonne existe déjà")
else:
    df = df.assign(id_image=0)
    df = df.drop_duplicates(subset=['image'])

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
    ids_sources = []
    verif_credits = []

    # Loop to add sources in the database
    for index, row in df.iterrows():
        split_url = (row['url'].split('/'))
        homepage = (row['url'].split('/id'))[0] + '/' + split_url[4] + '/' + split_url[5]
        if (homepage not in sources_exists and homepage not in verif_sources):
            print(homepage)
            if i not in ids_sources:
                cursor.execute("INSERT INTO sources(id_sources, credit, home, url, viewer, thumbnail, lowres, highres, iip, footprint) VALUES ("+str(i)+", '"+(row['url'].split('/'))[4]+"', '"+homepage+"', 'url', 'viewer', 'thumbnail', 'lowres', 'highres', 'iip', ST_GeomFromText('MULTIPOLYGON(((1 1,5 1,5 5,1 5,1 1),(2 2,2 3,3 3,3 2,2 2)),((6 3,9 2,9 4,6 3)))', 2154))")
                connection.commit()
                ids_sources.append(i)
                i+=1
                verif_sources.append(homepage)
            else:
                while i in ids_sources:
                    i+=1
                cursor.execute("INSERT INTO sources(id_sources, credit, home, url, viewer, thumbnail, lowres, highres, iip, footprint) VALUES ("+str(i)+", '"+(row['url'].split('/'))[4]+"', '"+homepage+"', 'url', 'viewer', 'thumbnail', 'lowres', 'highres', 'iip', ST_GeomFromText('MULTIPOLYGON(((1 1,5 1,5 5,1 5,1 1),(2 2,2 3,3 3,3 2,2 2)),((6 3,9 2,9 4,6 3)))', 2154))")
                connection.commit()
                ids_sources.append(i)
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
    verif_images = []

    # Execution of SQL queries to add an image
    # Request the sources of the image to add the right id_sources
    for index, row in df.iterrows():
        split_url = (row['url'].split('/'))
        homepage = (row['url'].split('/id'))[0] + '/' + split_url[4] + '/' + split_url[5]
        cursor.execute("SELECT id_sources FROM sources WHERE home='"+homepage+"'")
        id_of_sources = cursor.fetchall()
        if row['image'] not in verif_images and row['image'] not in images_exists:
 
            if len(row['date']) == 10 :
                date = row['date']
            elif row['date'][-4:].isdigit():
                #print(row['date'][-4:])
                date = row['date'][-4:] + '-01-01'
            else:
                #print(row['date'])
                date = "1900-01-01"
                
            if i not in ids:
                cursor.execute("INSERT INTO images(id_images, t0, t1, image, size_image, id_sources, id_masks) VALUES ("+str(i)+", '"+date+" 00:00:00-00', '"+date+" 19:10:25-07', '"+row['image']+"', ST_GeomFromText('POINT(0 0)', 2154), "+str(id_of_sources[0][0])+", null);")
                df.loc[index, 'id_image'] = i
                i+=1
                verif_images.append(row['image'])
            else:
                while i in ids:
                    i+=1
                cursor.execute("INSERT INTO images(id_images, t0, t1, image, size_image, id_sources, id_masks) VALUES ("+str(i)+", '"+date+" 00:00:00-00', '"+date+"19:10:25-07', '"+row['image']+"', ST_GeomFromText('POINT(0 0)', 2154), 0, null);")
                df.loc[index, 'id_image'] = i
                i+=1
                verif_images.append(row['image'])

    # Commit all requests
    connection.commit()

    # Register the csv with all id in case of the user used the file several time
    df.to_csv(csv, sep = ',')

    print("Images succefully added to images table.")

    # Select all id_externe/interne/transfo2d in database to avoid duplicate id
    cursor.execute("SELECT id_interne FROM interne")
    id_interne = cursor.fetchall()
    cursor.execute("SELECT id_externe FROM externe")
    id_externe = cursor.fetchall()
    cursor.execute("SELECT id_transfo2d FROM transfo2d")
    id_transfo2d = cursor.fetchall()
    cursor.execute("SELECT id_georefs FROM georefs")
    id_georefs = cursor.fetchall()

    ids_interne = []
    for id in id_interne:
        ids_interne.append(id[0])
    k = 0
    ids_externe = []
    for id in id_externe:
        ids_externe.append(id[0])
    l = 0
    ids_transfo2d= []
    for id in id_transfo2d:
        ids_transfo2d.append(id[0])
    m = 0
    ids_georefs = []
    for id in id_georefs:
        ids_georefs.append(id[0])
    n = 0


    # Execution of SQL queries to add parameters tables
    # Request the georefs table to know if at least one georefs exists
    # Then add a georeferencement if it doesn't exist
    for index, row in df.iterrows():
        cursor.execute("SELECT EXISTS (SELECT 1 FROM georefs WHERE id_images = "+str(row['id_image'])+")")
        exist = cursor.fetchall()
        if exist[0][0] == False:
            if n not in ids_georefs:
                if k not in ids_interne and l not in ids_externe and m not in ids_transfo2d:
                    cursor.execute("INSERT INTO interne(id_interne, pp, focal, skew, distorsion) VALUES ("+str(k)+", ST_GeomFromText('POINTZ(0 0 0)', 2154), 50, 0, '{0, 0}');")
                    cursor.execute("INSERT INTO externe(id_externe, point, quaternion, srid) VALUES ("+str(l)+", ST_GeomFromText('POINTZ(0 0 0)', 2154), ST_GeomFromText('POINTZM(0 0 0 0)', 2154), 2154);")
                    cursor.execute("INSERT INTO transfo2d(id_transfo2d, image_matrix) VALUES ("+str(m)+", '{0, 0}');")
                    # Commit all requests
                    connection.commit()
                else:
                    while k in ids_interne:
                        k+=1
                    while l in ids_externe:
                        l+=1
                    while m in ids_transfo2d:
                        m+=1
                    cursor.execute("INSERT INTO interne(id_interne, pp, focal, skew, distorsion) VALUES ("+str(k)+", ST_GeomFromText('POINTZ(0 0 0)', 2154), 50, 0, '{0, 0}');")
                    cursor.execute("INSERT INTO externe(id_externe, point, quaternion, srid) VALUES ("+str(l)+", ST_GeomFromText('POINTZ(0 0 0)', 2154), ST_GeomFromText('POINTZM(0 0 0 0)', 2154), 2154);")
                    cursor.execute("INSERT INTO transfo2d(id_transfo2d, image_matrix) VALUES ("+str(m)+", '{0, 0}');")
                    # Commit all requests
                    connection.commit()
                cursor.execute("INSERT INTO georefs(id_georefs, user_georef, date, georef_principal, footprint, near, far, id_transfo2d, id_interne, id_externe, id_images) VALUES ("+str(n)+", 'ama4', '2022-04-20 00:00:00-00', TRUE, ST_GeomFromText('"+row['footprint']+"', 2154), ST_GeomFromText('POLYGON((50.6373 3.0750,50.6374 3.0750,50.6374 3.0749,50.63 3.07491,50.6373 3.0750))', 2154), ST_GeomFromText('POLYGON((50.6373 3.0750,50.6374 3.0750,50.6374 3.0749,50.63 3.07491,50.6373 3.0750))', 2154), "+str(m)+", "+str(k)+", "+str(l)+", "+str(row['id_image'])+");")
                # Commit all requests
                connection.commit()
                n+=1
                k+=1
                l+=1
                m+=1
            else:
                while n in ids_georefs:
                    n+=1
                if k not in ids_interne and l not in ids_externe and m not in ids_transfo2d:
                    cursor.execute("INSERT INTO interne(id_interne, pp, focal, skew, distorsion) VALUES ("+str(k)+", ST_GeomFromText('POINTZ(0 0 0)', 2154), 50, 0, '{0, 0}');")
                    cursor.execute("INSERT INTO externe(id_externe, point, quaternion, srid) VALUES ("+str(l)+", ST_GeomFromText('POINTZ(0 0 0)', 2154), ST_GeomFromText('POINTZM(0 0 0 0)', 2154), 2154);")
                    cursor.execute("INSERT INTO transfo2d(id_transfo2d, image_matrix) VALUES ("+str(m)+", '{0, 0}');")
                    # Commit all requests
                    connection.commit()
                else:
                    while k in ids_interne:
                        k+=1
                    while l in ids_externe:
                        l+=1
                    while m in ids_transfo2d:
                        m+=1
                    cursor.execute("INSERT INTO interne(id_interne, pp, focal, skew, distorsion) VALUES ("+str(k)+", ST_GeomFromText('POINTZ(0 0 0)', 2154), 50, 0, '{0, 0}');")
                    cursor.execute("INSERT INTO externe(id_externe, point, quaternion, srid) VALUES ("+str(l)+", ST_GeomFromText('POINTZ(0 0 0)', 2154), ST_GeomFromText('POINTZM(0 0 0 0)', 2154), 2154);")
                    cursor.execute("INSERT INTO transfo2d(id_transfo2d, image_matrix) VALUES ("+str(m)+", '{0, 0}');")
                    # Commit all requests
                    connection.commit()
                cursor.execute("INSERT INTO georefs(id_georefs, user_georef, date, georef_principal, footprint, near, far, id_transfo2d, id_interne, id_externe, id_images) VALUES ("+str(n)+", 'ama4', '2022-04-20 00:00:00-00', TRUE, ST_GeomFromText('"+row['footprint']+"', 2154), ST_GeomFromText('POLYGON((50.6373 3.0750,50.6374 3.0750,50.6374 3.0749,50.63 3.07491,50.6373 3.0750))', 2154), ST_GeomFromText('POLYGON((50.6373 3.0750,50.6374 3.0750,50.6374 3.0749,50.63 3.07491,50.6373 3.0750))', 2154), "+str(m)+", "+str(k)+", "+str(l)+", "+str(row['id_image'])+");")
                # Commit all requests
                connection.commit()
                n+=1
                k+=1
                l+=1
                m+=1
    
    print("Georeferencement succefully added.")
    
    ## Add the footprint of the sources thanks to all associated images
    for source in ids_sources:
        print(source)
        cursor.execute("SELECT ST_AsText(ST_UNION(georefs.footprint)) \
                        FROM georefs \
                        INNER JOIN images ON georefs.id_images = images.id_images \
                        INNER JOIN sources ON sources.id_sources = images.id_sources \
                        WHERE images.id_sources = "+str(source)+";")
        geom = cursor.fetchall()
        cursor.execute("UPDATE sources SET footprint = ST_GeomFromText('"+geom[0][0]+"', 2154) WHERE id_sources = "+str(source)+";")
        connection.commit()
    
except (Exception, psycopg2.Error) as error :
	print('ERROR : '+ str(error))

finally:
	# Closing database connection
	if(connection):
		cursor.close()
		connection.close()

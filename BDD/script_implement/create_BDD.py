import sys
import psycopg2
from psycopg2.extras import execute_values

# Some libraries whose not using currently
# import xml.etree.ElementTree as ET
# import glob

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
    filename : str
        name of the file to import    

    Methods
    -------
    Creation of all the table in the database
    """

user     = sys.argv[1] if len(sys.argv) > 1 else None
password = sys.argv[2] if len(sys.argv) > 2 else None
database = sys.argv[3] if len(sys.argv) > 3 else None
host     = sys.argv[4] if len(sys.argv) > 4 else None
port     = sys.argv[5] if len(sys.argv) > 5 else None
# filename = sys.argv[6] if len(sys.argv) > 6 else "*.xml" UNUSED CURRENTLY
debug = False

# requete de creation de la table masks
create_masks_table = """
CREATE TABLE IF NOT EXISTS masks(
    id_masks SERIAL PRIMARY KEY,
    url VARCHAR NOT NULL,
    UNIQUE(url)
);
"""

# requete de creation de la table sources avec ajout de l'extension postgis
create_sources_table = """
CREATE EXTENSION IF NOT EXISTS postgis;

CREATE TABLE IF NOT EXISTS sources(
    id_sources SERIAL PRIMARY KEY,
    credit VARCHAR NOT NULL,
    home VARCHAR,
    url VARCHAR NOT NULL,
    viewer VARCHAR,
    thumbnail VARCHAR,
    lowres VARCHAR,
    highres VARCHAR,
    iip VARCHAR,
    footprint geometry(MultiPolygon,0) NOT NULL
);
"""

# requete de creation de la table interne
create_interne_table = """
CREATE TABLE IF NOT EXISTS interne(
    id_interne SERIAL PRIMARY KEY,
    pp geometry(PointZ,0) NOT NULL,
    focal geometry(PointZ,0) NOT NULL,
    skew FLOAT NOT NULL,
    near_frustum_camera geometry(PointZ, 0) NOT NULL,
    distorsion integer ARRAY
);
"""

# requete de creation de la table externe
create_externe_table = """
CREATE TABLE IF NOT EXISTS externe(
    id_externe SERIAL PRIMARY KEY,
    point geometry(PointZ, 0) NOT NULL,
    quaternion geometry(PointZ, 0) NOT NULL,
    SRID INT NOT NULL
);
"""

# requete de creation de la table transfo2D
create_transfo2D_table = """
CREATE TABLE IF NOT EXISTS transfo2D(
    id_transfo2D SERIAL PRIMARY KEY,
    image_matrix integer ARRAY
);
"""

# requete de creation de la table transfo3D
create_transfo3D_table = """
CREATE TABLE IF NOT EXISTS transfo3D(
    id_transfo3D SERIAL PRIMARY KEY,
    image_matrix integer ARRAY
);
"""

# requete de creation de la table georefs
create_georefs_table = """
CREATE TABLE IF NOT EXISTS georefs(
    id_georefs SERIAL PRIMARY KEY,
    user_georef VARCHAR NOT NULL,
    date timestamp NOT NULL,
    georef_principal BOOL NOT NULL,
    id_transfo3D INT NOT NULL,
    id_transfo2D INT NOT NULL,
    id_interne INT NOT NULL,
    id_externe INT NOT NULL,
    FOREIGN KEY(id_transfo3D) REFERENCES transfo3D(id_transfo3D),
    FOREIGN KEY(id_transfo2D) REFERENCES transfo2D(id_transfo2D),
    FOREIGN KEY(id_interne) REFERENCES interne(id_interne),
    FOREIGN KEY(id_externe) REFERENCES externe(id_externe)
);
"""

# requete de creation de la table images
create_images_table = """
CREATE TABLE IF NOT EXISTS images(
    id_images SERIAL PRIMARY KEY,
    t0 timestamp NOT NULL,
    t1 timestamp NOT NULL,
    image VARCHAR NOT NULL,
    origine VARCHAR NOT NULL,
    qualite BIGINT,
    resolution_min FLOAT,
    resolution_moy FLOAT,
    resolution_max FLOAT,
    footprint geometry(Polygon, 0) NOT NULL,
    size_image geometry(Point, 0) NOT NULL,
    id_sources INT NOT NULL,
    id_georefs INT,
    id_masks INT,
    UNIQUE(image),
    FOREIGN KEY(id_sources) REFERENCES sources(id_sources),
    FOREIGN KEY(id_georefs) REFERENCES georefs(id_georefs),
    FOREIGN KEY(id_masks) REFERENCES masks(id_masks)
);
"""

# requete de creation de la table point_appuis
create_points_appuis_table = """
CREATE TABLE IF NOT EXISTS points_appuis(
    id_points_appuis SERIAL PRIMARY KEY,
    point_2d geometry(Point, 0),
    point_3d geometry(PointZ, 0),
    id_images INT NOT NULL,
    FOREIGN KEY(id_images) REFERENCES images(id_images)
);
"""

# Database connection block
try:

    # print(filename) UNUSED CURRENTLY

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
    cursor.execute(create_masks_table)
    cursor.execute(create_sources_table)
    cursor.execute(create_interne_table)
    cursor.execute(create_externe_table)
    cursor.execute(create_transfo2D_table)
    cursor.execute(create_transfo3D_table)
    cursor.execute(create_georefs_table)
    cursor.execute(create_images_table)
    cursor.execute(create_points_appuis_table)

    # Commit all requests
    connection.commit()

    print("The database has been modified according to the queries made.")

    """ UNUSED CURRENTLY
    # When you add a set of data
    for f in sorted(glob.glob(filename)):
    	print(f,end='', flush=True)
    	try:
    		mydoc = ET.parse(f).getroot()
    	except ET.ParseError as err:
    		print(err, flush=True)
    		continue
	"""

except (Exception, psycopg2.Error) as error :
	print('ERROR : '+ str(error))
finally:
	# Closing database connection
	if(connection):
		cursor.close()
		connection.close()


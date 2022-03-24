import sys
import psycopg2
from psycopg2.extras import execute_values
import xml.etree.ElementTree as ET
import glob


user     = sys.argv[1] if len(sys.argv) > 1 else None
password = sys.argv[2] if len(sys.argv) > 2 else None
database = sys.argv[3] if len(sys.argv) > 3 else None
host     = sys.argv[4] if len(sys.argv) > 4 else None
port     = sys.argv[5] if len(sys.argv) > 5 else None
filename = sys.argv[6] if len(sys.argv) > 6 else "*.xml"
debug = False

# creation de la table masks
create_masks_table = """
CREATE TABLE IF NOT EXISTS masks(
    Id_masks SERIAL PRIMARY KEY,
    url VARCHAR NOT NULL,
    UNIQUE(url)
);
"""

# creation de la table sources
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

# creation de la table interne
create_interne_table = """
CREATE TABLE IF NOT EXISTS interne(
    id_interne SERIAL PRIMARY KEY,
    pp geometry(PointZ,0) NOT NULL,
    focal geometry(PointZ,0) NOT NULL,
    skew FLOAT NOT NULL,
    distorsion integer ARRAY
);
"""

# creation de la table externe
create_externe_table = """
CREATE TABLE IF NOT EXISTS externe(
    id_externe SERIAL PRIMARY KEY,
    point geometry(PointZ, 0) NOT NULL,
    quaternion geometry(PointZ, 0) NOT NULL,
    SRID INT NOT NULL
);
"""

# creation de la table transfo2D
create_transfo2D_table = """
CREATE TABLE IF NOT EXISTS transfo2D(
    id_transfo2D SERIAL PRIMARY KEY,
    image_matrix integer ARRAY
);
"""

# creation de la table transfo3D
create_transfo3D_table = """
CREATE TABLE IF NOT EXISTS transfo3D(
    id_transfo3D SERIAL PRIMARY KEY,
    image_matrix integer ARRAY
);
"""

# creation de la table georefs
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

create_images_table = """
CREATE TABLE IF NOT EXISTS images(
    id SERIAL PRIMARY KEY,
    t0 timestamp NOT NULL,
    t1 timestamp NOT NULL,
    url VARCHAR NOT NULL,
    image VARCHAR NOT NULL,
    origine VARCHAR NOT NULL,
    qualite BIGINT,
    resolution_min FLOAT,
    resolution_moy FLOAT,
    resolution_max FLOAT,
    footprint geometry(Polygon, 0) NOT NULL,
    size_image geometry(Point, 0) NOT NULL,
    near_frustum_camera geometry(PointZ, 0) NOT NULL,
    id_sources INT NOT NULL,
    id_georefs INT,
    Id_masks INT,
    UNIQUE(url),
    UNIQUE(image),
    FOREIGN KEY(id_sources) REFERENCES sources(id_sources),
    FOREIGN KEY(id_georefs) REFERENCES georefs(id_georefs),
    FOREIGN KEY(Id_masks) REFERENCES masks(Id_masks)
);
"""

create_points_appuis_table = """
CREATE TABLE points_appuis(
    id_points_appuis SERIAL PRIMARY KEY,
    point_2d geometry(Point, 0),
    point_3d geometry(PointZ, 0),
    id INT NOT NULL,
    FOREIGN KEY(id) REFERENCES images(id)
);
"""

try:
    print(filename)
    connection = psycopg2.connect(
    	user = user,
        password = password,
        host = host,
        port = port,
        database = database
    )
    cursor = connection.cursor()

    cursor.execute(create_masks_table)
    cursor.execute(create_sources_table)
    cursor.execute(create_interne_table)
    cursor.execute(create_externe_table)
    cursor.execute(create_transfo2D_table)
    cursor.execute(create_transfo3D_table)
    cursor.execute(create_georefs_table)
    cursor.execute(create_images_table)
    cursor.execute(create_points_appuis_table)
    connection.commit()

    for f in sorted(glob.glob(filename)):
    	print(f,end='', flush=True)
    	try:
    		mydoc = ET.parse(f).getroot()
    	except ET.ParseError as err:
    		print(err, flush=True)
    		continue
	
except (Exception, psycopg2.Error) as error :
	print('ERROR[' + filename +'] : '+ str(error))
finally:
	#closing database connection.
	if(connection):
		cursor.close()
		connection.close()


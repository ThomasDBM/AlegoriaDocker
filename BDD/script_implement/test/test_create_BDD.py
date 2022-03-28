import unittest
import psycopg2
from psycopg2.extras import execute_values

class TestCreateMethods(unittest.TestCase):

    def test_check_attribute_type(self):
        try:
            # Connection to the database with giving parameters
            connection = psycopg2.connect(
                user = "formation",
                password = "formation",
                host = "localhost",
                port = "5432",
                database = "postgres"
                )
            
            # Database pointer
            cursor = connection.cursor()

            # Execution of each SQL query
            cursor.execute("SELECT DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'images' AND COLUMN_NAME = 'id_images'")

            type_id_images_table = cursor.fetchall()

            cursor.execute("SELECT type, coord_dimension \
                            FROM geometry_columns \
                            WHERE f_table_schema = 'public' \
                            AND f_table_name = 'interne' \
                            AND f_geometry_column = 'focal'")

            type_focal = cursor.fetchall()

            cursor.execute("SELECT type, coord_dimension \
                            FROM geometry_columns \
                            WHERE f_table_schema = 'public' \
                            AND f_table_name = 'images' \
                            AND f_geometry_column = 'footprint'")

            type_footprint_images = cursor.fetchall()

            cursor.execute("SELECT type, coord_dimension \
                            FROM geometry_columns \
                            WHERE f_table_schema = 'public' \
                            AND f_table_name = 'sources' \
                            AND f_geometry_column = 'footprint'")

            type_footprint_sources = cursor.fetchall()

        except (Exception, psycopg2.Error) as error :
            print('ERROR : '+ str(error))
        finally:
            # Closing database connection
            if(connection):
                cursor.close()
                connection.close()

        self.assertEqual(type_id_images_table[0][0], 'integer')

        # Verify geometry type and dimension
        self.assertEqual(type_focal[0][0], 'POINT')
        self.assertEqual(type_focal[0][1], 3)

        self.assertEqual(type_footprint_images[0][0], 'POLYGON')
        self.assertEqual(type_footprint_images[0][1], 2)

        self.assertEqual(type_footprint_sources[0][0], 'MULTIPOLYGON')
        self.assertEqual(type_footprint_sources[0][1], 2)

    def test_check_existing_tables(self):
        try:
            # Connection to the database with giving parameters
            connection = psycopg2.connect(
                user = "formation",
                password = "formation",
                host = "localhost",
                port = "5432",
                database = "postgres"
                )

            # Database pointer
            cursor = connection.cursor()

            # Execution of each SQL query
            cursor.execute("SELECT EXISTS((SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'masks') \
			                INTERSECT \
			                (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'interne') \
                            INTERSECT \
                            (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'externe') \
                            INTERSECT \
                            (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'transfo2d') \
                            INTERSECT \
                            (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'transfo3d') \
                            INTERSECT \
                            (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'georefs') \
                            INTERSECT \
                            (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'images') \
                            INTERSECT \
                            (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'sources') \
                            INTERSECT \
                            (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'points_appuis'))")

            verif = cursor.fetchall()

        except (Exception, psycopg2.Error) as error :
            print('ERROR[' + filename +'] : '+ str(error))
        finally:
            # Closing database connection
            if(connection):
                cursor.close()
                connection.close()

        self.assertEqual(verif[0][0], True)

    def test_check_primary_key(self):
        try:
            # Connection to the database with giving parameters
            connection = psycopg2.connect(
                user = "formation",
                password = "formation",
                host = "localhost",
                port = "5432",
                database = "postgres"
                )

            # Database pointer
            cursor = connection.cursor()
            # Execution of each SQL query
            cursor.execute("SELECT COUNT(kcu.column_name) as key_column \
                            FROM information_schema.table_constraints tco \
                            JOIN information_schema.key_column_usage kcu \
                            ON kcu.constraint_name = tco.constraint_name \
                            WHERE tco.constraint_type = 'PRIMARY KEY'") 

            primary_keys_count = cursor.fetchall()

            cursor.execute("SELECT kcu.column_name as key_column \
                            FROM information_schema.table_constraints tco \
                            JOIN information_schema.key_column_usage kcu \
                            ON kcu.constraint_name = tco.constraint_name \
                            WHERE tco.constraint_type = 'PRIMARY KEY' \
                            ORDER BY key_column;")    

            primary_keys = cursor.fetchall()         

        except (Exception, psycopg2.Error) as error :
            print('ERROR[' + filename +'] : '+ str(error))
        finally:
            # Closing database connection
            if(connection):
                cursor.close()
                connection.close()

        # 9 tables + la table postgis
        self.assertEqual(primary_keys_count[0][0], 10)

        # Verify the primary keys in the database
        self.assertEqual(primary_keys[0][0], 'id_externe')
        self.assertEqual(primary_keys[1][0], 'id_georefs')
        self.assertEqual(primary_keys[2][0], 'id_images')
        self.assertEqual(primary_keys[3][0], 'id_interne')
        self.assertEqual(primary_keys[4][0], 'id_masks')
        self.assertEqual(primary_keys[5][0], 'id_points_appuis')
        self.assertEqual(primary_keys[6][0], 'id_sources')
        self.assertEqual(primary_keys[7][0], 'id_transfo2d')
        self.assertEqual(primary_keys[8][0], 'id_transfo3d')

    def test_check_foreign_key(self):
        try:
            # Connection to the database with giving parameters
            connection = psycopg2.connect(
                user = "formation",
                password = "formation",
                host = "localhost",
                port = "5432",
                database = "postgres"
                )

            # Database pointer
            cursor = connection.cursor()
            # Execution of each SQL query
            cursor.execute("SELECT ccu.column_name AS foreign_column_name \
                            FROM information_schema.table_constraints AS tc \
                            JOIN information_schema.key_column_usage AS kcu \
                                ON tc.constraint_name = kcu.constraint_name \
                                AND tc.table_schema = kcu.table_schema \
                            JOIN information_schema.constraint_column_usage AS ccu \
                                ON ccu.constraint_name = tc.constraint_name \
                                AND ccu.table_schema = tc.table_schema \
                            WHERE tc.constraint_type = 'FOREIGN KEY' AND tc.table_name='images' \
                            ORDER BY foreign_column_name;") 

            foreign_images_keys = cursor.fetchall()

            cursor.execute("SELECT ccu.column_name AS foreign_column_name \
                            FROM information_schema.table_constraints AS tc \
                            JOIN information_schema.key_column_usage AS kcu \
                                ON tc.constraint_name = kcu.constraint_name \
                                AND tc.table_schema = kcu.table_schema \
                            JOIN information_schema.constraint_column_usage AS ccu \
                                ON ccu.constraint_name = tc.constraint_name \
                                AND ccu.table_schema = tc.table_schema \
                            WHERE tc.constraint_type = 'FOREIGN KEY' AND tc.table_name='georefs' \
                            ORDER BY foreign_column_name;") 

            foreign_georefs_keys = cursor.fetchall()

            cursor.execute("SELECT ccu.column_name AS foreign_column_name \
                            FROM information_schema.table_constraints AS tc \
                            JOIN information_schema.key_column_usage AS kcu \
                                ON tc.constraint_name = kcu.constraint_name \
                                AND tc.table_schema = kcu.table_schema \
                            JOIN information_schema.constraint_column_usage AS ccu \
                                ON ccu.constraint_name = tc.constraint_name \
                                AND ccu.table_schema = tc.table_schema \
                            WHERE tc.constraint_type = 'FOREIGN KEY' AND tc.table_name='points_appuis' \
                            ORDER BY foreign_column_name;") 

            foreign_points_appuis_keys = cursor.fetchall()            

        except (Exception, psycopg2.Error) as error :
            print('ERROR[' + filename +'] : '+ str(error))
        finally:
            # Closing database connection
            if(connection):
                cursor.close()
                connection.close()

        self.assertEqual(foreign_images_keys[0][0], "id_georefs")
        self.assertEqual(foreign_images_keys[1][0], "id_masks")
        self.assertEqual(foreign_images_keys[2][0], "id_sources")
        self.assertEqual(foreign_georefs_keys[0][0], "id_externe")
        self.assertEqual(foreign_georefs_keys[1][0], "id_interne")
        self.assertEqual(foreign_georefs_keys[2][0], "id_transfo2d")
        self.assertEqual(foreign_georefs_keys[3][0], "id_transfo3d")
        self.assertEqual(foreign_points_appuis_keys[0][0], "id_images")

if __name__ == '__main__':
    unittest.main()
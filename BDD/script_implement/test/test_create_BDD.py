import unittest
import psycopg2
from psycopg2.extras import execute_values

class TestCreateMethods(unittest.TestCase):

    def test_test(self):
        self.assertEqual('foo'.upper(), 'FOO')

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

            record_table = cursor.fetchall()

            print(record_table)

        except (Exception, psycopg2.Error) as error :
            print('ERROR[' + filename +'] : '+ str(error))
        finally:
            # Closing database connection
            if(connection):
                cursor.close()
                connection.close()

        self.assertEqual(record_table[0][0], 'integer')

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

            print(verif)

        except (Exception, psycopg2.Error) as error :
            print('ERROR[' + filename +'] : '+ str(error))
        finally:
            # Closing database connection
            if(connection):
                cursor.close()
                connection.close()

        self.assertEqual(verif[0][0], True)

if __name__ == '__main__':
    unittest.main()
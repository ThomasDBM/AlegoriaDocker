# Database Installation and Maintenance Guide #

## Architecture ##

## Install ##

In the following section we will explain how to install the database. First of all, the PostgreSQL library must be installed with the following command :
```
sudo apt install postgresql
```

Next, you need to install the pgAdmin client, an ergonomic interface for handling PostgreSQL databases :
```
sudo curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add

sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'

sudo apt install pgadmin4-dekstop
```

The next step is to ensure that the service is operational, active and running:
```
sudo systemctl is-active postgresql
sudo systemctl is-enabled postgresql
sudo systemctl status postgresql
```

![image](images/InstallPostGre.PNG)

Finally, we must ensure that the postgresql server is ready to accept connections :
```
sudo pg_isready
```

![image](images/InstallPostGre2.PNG)

After the previous steps, we have successfully installed PostgreSQL and its client PgAdmin. However, no database is instantiated and therefore no connection to a server can be established. We will therefore create the database and the server.

```
sudo -u postgres psql
postgres=# CREATE DATABASE alegoria;
postgres=# GRANT ALL PRIVILEGES ON DATABASE alegoria to postgres;
postgres=# \q
```

Since we are handling spatial data, we also need to install the postgis and python extensions for our database :
```
sudo apt-get install postgresql-plpython3-12 postgis postgresql-12-postgis-3
sudo -u postgres psql
postgres=# \c alegoria
alegoria=# CREATE EXTENSION postgis;
alegoria=# CREATE EXTENSION postgis_topology;
alegoria=# CREATE EXTENSION CREATE plpython3u;
alegoria=# \q
```

After that, you need to open the PgAdmin client and establish a connection to the server from the "Add new server" icon. This opens a window with several tabs. In the General tab, give the desired name to the server (ex: localhost). Then, in the Connection tab, connect to the server from the user created above :

![image](images/InstallBDD.PNG)

Now that everything is up and running, we need to fill the database. We must ensure that python is installed with the following packages :
```
python3 --version
sudo apt-get install python3-pip 
pip install psycopg2-binary
pip install pyquaternion
```

Finally, we can complete our database with the following commands :
```
python3 create_BDD.py postgres postgres alegoria localhost 5432
```

To execute the tests of the database creation script, we use the command (the test libraries are already implemented with python3):
```
python3 BDD/script_implement/test/test_create_BDD.py
```

To add the data management functions to our database, we will use the following command :
```
psql postgres -h localhost -d alegoria -f BDD/script_implement/remove_data.sql
```

## Maintenance ##

### Remove a data

The remove_data file contains a function integrated to the database allowing to remove a data in any table, except the source table which corresponds to the deletion by batch of data. The function has two arguments : first the table where the data should be deleted, second the index of the data.

An example of a call to the remove_data function is the following:

```
SELECT remove_data('images', 0);
```

On this example, we are looking to remove the first image (id = 1) from the images table. The function will also remove the dependencies affected by the deletion of the data (e.g. to remove an image, you must first remove its georeferencing).

### Remove a batch of data

The remove_batch_data file contains a function integrated to the database allowing to remove a batch of data. This deletion is done only from the source table. The arguments entered are the same as for the remove_data function, in particular to ensure that the administrator really wants to remove a batch of data using the source table.

An example of a call to the remove_batch_data function is the following:

```
SELECT remove_batch_data('sources', 1);
```

In this example, we want to remove the first source of the database (id = 1) from the source table. The function will also remove the dependencies affected by the deletion of the source. That is, the associated images, the georeferencing with the associated internal/external and transfo2d tables.

### Modify a data

The modify_data file contains a set of 8 functions integrated in the database, each allowing the modification of data on a table:
- modify_georefs allowing the modification of a data of the georeferencing table
- modify_support_points allowing the modification of support points
- modify_images to modify an image
- modify_externe to modify the interne table
- modify_interne to modify the externe table
- modify_transfo2d to modify the transfo2d table
- modify_sources to modify the sources table
- modify_masks to modify the masks table

Each of these functions must be called with an existing id, and take as argument one of the parameters to change on a data. Here is an example:
```
SELECT modify_images(id_images => 4, image => '''UniqueId''');
```

The name of the attribute must be specified, followed by the characters *=>* to allow a specific attribute to take a particular value. Only the attributes that need to be changed must be entered (in this case the image attribute). The attributes to be changed have the same name as those in the table.

The strings must be entered with triple quotes ('''text''') for the functions to work properly. Note that geometries and matrices must be entered as char to be replaced. When a geometry is to be changed, the epsg of the geometry must also be specified as in the following example:
```
SELECT modify_georefs(id_georefs => 4, user_georef => '''AMAAMA''', footprint => '''POLYGON((0 0,0 0,0 0,0 0,0 0))''',
					 epsg => 2154);
```
Except for the externe table which has a SRID attribute:
```
SELECT modify_externe(id_externe => 4, quaternion => '''POINTZM(0 0 0 0)''', srid => 2154);
```
 
# Guide d'installation et d'entretien de la BDD #

## Architecture ##

## Installation ##

Dans un premier temps, il faut installer postgresql:
```
sudo apt install postgresql
```

Dans un second temps, il faut installer le client pgAdmin :
```
sudo curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add

sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'

sudo apt install pgadmin4-dekstop
```

Il faut ensuite s'assurer que le service est actif et en marche :
```
sudo systemctl is-active postgresql
sudo systemctl is-enabled postgresql
sudo systemctl status postgresql
```
![image](images/InstallPostGre.PNG)

Enfin, on doit s'assurer que le serveur postgre est prêt à accepter des connections :
```
sudo pg_isready
```
![image](images/InstallPostGre2.PNG)

Ensuite, il faut créer un utilisateur et une base de donnée :

**A noter que le user et le password doivent être postgres par défaut (choix du commanditaire dans ses fichiers). Le nom de la base doit être alegoria.**
```
sudo -u postgres psql
postgres=# CREATE DATABASE alegoria;
postgres=# GRANT ALL PRIVILEGES ON DATABASE alegoria to postgres;
postgres=# \q
```

Il faut également installer l'extension postgis à notre base de données. Pour cela :
```
sudo apt install postgis postgresql-12-postgis-3
sudo -u postgres psql
postgres=# \c alegoria
alegoria=# CREATE EXTENSION postgis
alegoria=# CREATE EXTENSION postgis_topology;
alegoria=# \q
```

Après cela, il faut ouvrir le client PgAdmin et établir une connexion au serveur à partir de l'icone "Add new server". Ceci ouvre une fenêtre avec plusieurs onglets. Dans l'onglet général, donné le nom souhaité au serveur (ex: localhost). Ensuite, dans l'onglet Connection, il faut se connecter au serveur à partir de l'utilisateur créé plus haut :
![image](images/InstallBDD.PNG)

Il faut ensuite s'assurer que python est bien installé et installer les librairies nécessaires :
```
python3 --version
sudo apt-get install python3-pip 
pip install psycopg2-binary
pip install pyquaternion
```

Puis cloner le dépôt du serveur:
```
git clone https://github.com/mbredif/alegoria.git
git cd alegoria
git checkout TSI/tests
```

Après cela, ouvrir un terminal dans le dossier IGNF et exécuter les lignes suivantes :
```
python3 micmac2pg.py postgres postgres alegoria localhost 5432
python3 ta2pg.py postgres postgres alegoria localhost 5432
bash "Create_views.sh"
bash "Resolutions_scannage.sh"
```

## Entretien ##
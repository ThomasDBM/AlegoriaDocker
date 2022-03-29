# Installation Geoserver et BDD


######        ######
#### Pré-requis ####
######        ######

- Avoir un OpenJDK version 10 min.

Pour cela rentrer la commande :
```
java ---version
```
pour obtenir la version du JDK sur votre machine.
Dans le cas où vous n'avez pas de JDK, entrez la commande :
```
sudo apt install defaut-jre
```


######                    ######
#### Installation de Tomcat ####
######                    ######

Tomcat est un serveur d'applications pour serveur d'applications Java.
Pour installer Tomcat sur votre machine, veuillez taper la commande suivante :
```
sudo apt install tomcat9 tomcat9-admin
```

Vous devez ajouter les packages administrateurs pour tomcat. Pour cela vous devez accéder au fichier `tomcat-users.xml` en rentrant la commande suivante :
```
sudo nano /etc/tomcat9/tomcat-users.xml
```
Une fois le fichier ouvert rajoutez les lignes suivantes :
```
<role rolename="admin-gui"/>
<role rolename="manager-gui"/>
<user username="tomcat" password="pass" roles="admin-gui,manager-gui"/>
```

Le service Tomcat a besoin d'être activé via la commande :
```
sudo systemctl enable tomcat9
```

Pour démarrer le service Tomcat, tapez la commande suivante :
```
sudo service tomcat9 start
```

Verifiez que le service est actif en tapant :
```
sudo service tomcat9 status
```
Si un 'active' est visible, le service fonctionne correctement



######                                     ######
#### Installation de l'application Geoserver ####
######                                     ######

Dans un dossier au choix, téléchargez le dossier compressé de geoserver via la commande :
```
wget https://sourceforge.net/projects/geoserver/files/GeoServer/2.18.0/geoserver-2.18.0-war.zip
```

Attention ! Avant de dézipper, stoppez le service Tomcat (si ce n'est pas fait) avec :
```
sudo service tomcat9 stop
```

Vous pouvez alors dézipper le dossier en utilisant la commande :
```
unzip geoserver-2.18.0-war.zip
```

Faites un `ls` pour vérifier que les dossiers/fichiers suivants sont bien présent :
1. geoserver
2. geoserver-2.18.0-war.zip
3. geoserver.war
4. license
5. NOTICE.md
6. README.txt
7. ROOT
8. target

Enfin, vous pouvez supprimer le .zip en faisant :
```
rm geoserver-2.18.0-war.zip
```

A noter que parfois le dossier `geoserver` ne se crée pas... L'application tourne cependant correctement sans lui.... va savoir !



######                   ######
#### Application Geoserver ####
######                   ######

Pour accéder à Geoserver rentrer l'adresse suivante : `localhost:8080/geoserver`

Pour vous identifiez, utiliser les identifiants par défaut fournis avec l'installation :

| Utilisateur | admin |
| MDP | geoserver |



######                          ######
#### Lier BDD locale et Geoserver ####
######                          ######

Dans le menu principal, cliquez sur 'Ajouter un entrepôt' ou dans la rubrique 'Données' à gauche, cliquez sur Entrepôts puis 'Ajouter un entrepôt'.
Dans la nouvelle fenêtre 'Nouvelle ressource', choissisez `PostGIS - PostGIS Database`
Remplissez les champs suivants comme il se doit :

| Nom de la source de données| Alegoria |
| ----------- | ----------- |
| database| alegoria |
| ----------- | ----------- |
| user | postgres |
| ----------- | ----------- |
| passwd | postgres |

Laissez les autres champs avec les valeurs par défaut.

Pour si toutes les tables ont été rajouté, aller dans 'couches' puis 'Ajouter une nouvelle ressource', dans le menu déroulant, sélectionnez 'cite:Alegoria'.



######              ######
#### Création Vue SQL ####
######              ######

Une vue est une table virtuelle définie par une requête. Le principal avantage est d’attribuer à une requête longue, une vue avec un nom qui permet de ne pas réécrire l’ensemble de la requête. La vue joue donc le rôle d'une fonction en programmation.

La formulation est la suivante :
```
CREATE VIEW <nom_vue> [<nom_des_colonnes>]
AS <requête> [WITH CHECK OPTION];
```



######                        ######
#### Ajout couche sur Geoserver ####
######                        ######

Pour ajouter une nouvelle couche sur Geoserver, cliquez sur Entrepôts puis sur `Ajouter un nouvel entrepôt`.
Sur cette nouvelle page, sélectionnez le type de données que vous voulez importer. Ici on sélectionnera `Shapefile` dans `Source de données Vecteur`.

Indiquez le nom de la source de données que vous voulez lui donner ainci que l'emplacement du Shapefile en cliquant sur Parcourir à droite.
Pour tout document se trouvant dans vos dossiers sous formation, dans le menu déroulant de la nouvelle fenêtre, choississez `dossier Home`, puis cliquez sur `home/formation/`.

Une fois sauvegardé, Geoserver vous demandera quelques informations supplémentaires notamment dans la partie Système de Référence de Coordonnées.
Si le SRC natif reste inconnu, vous pouvez le choisir manuellement avec le bouton "Rechercher".

Renseigner les emprises natives (si elles ne l'étaient pas déjà) ainsi que les emprises géographiques. (Les 2 emprises doivent être similaires.)

Cliquez sur sauvegarder en bas de page.

### Afficher la donnée sur Geoserver

Dans le menu à gauche de la page, sélectionnez `Prévisualisation de la couche` puis cliquez sur la donnée que vous voulez visualiser avec OpenLayers.



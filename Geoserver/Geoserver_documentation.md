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



######                                        ######
#### Création de carte de chaleur sur Geoserver ####
######                                        ######

# Méthode de travail

Geoserver ne crée pas directement de carte de chaleur, c'est le développeur qui va créer un style "heatmap" qui pourra s'appliquer à n'importe quelle couche il voudra.

Voici comment nous allons procéder pour créer une carte de chaleur :

1. Création fonction sur SQL qui permet de créer une grille de point dans une géométrie passée en paramètre.
2. Création d'une vue sur Geoserver à partir de la fonction SQL.
3. On applique un style 'carte de chaleur' à la vue.


# 1. Création fonction SQL

Dans la BDD `alegoria` sur pgAdmin, vérifier si la fonction `I_Grid_Point_Distance` existe. Dans le cas contraire, ouvrez une Query tool et tapez :

```
CREATE OR REPLACE FUNCTION public.I_Grid_Point_Distance(geom public.geometry, x_side decimal, y_side decimal)
RETURNS public.geometry AS $BODY$
DECLARE
x_min decimal;
x_max decimal;
y_max decimal;
x decimal;
y decimal;
returnGeom public.geometry[];
i integer := -1;
srid integer := 4326;
input_srid integer;
BEGIN
CASE st_srid(geom) WHEN 0 THEN
    geom := ST_SetSRID(geom, srid);
        ----RAISE NOTICE 'No SRID Found.';
    ELSE
        ----RAISE NOTICE 'SRID Found.';
END CASE;
    input_srid:=st_srid(geom);
    geom := st_transform(geom, srid);
    x_min := ST_XMin(geom);
    x_max := ST_XMax(geom);
    y_max := ST_YMax(geom);
    y := ST_YMin(geom);
    x := x_min;
    i := i + 1;
    returnGeom[i] := st_setsrid(ST_MakePoint(x, y), srid);
<<yloop>>
LOOP
IF (y > y_max) THEN
    EXIT;
END IF;

CASE i WHEN 0 THEN 
    y := ST_Y(returnGeom[0]);
ELSE 
    y := ST_Y(ST_Project(st_setsrid(ST_MakePoint(x, y), srid), y_side, radians(0))::geometry);
END CASE;

x := x_min;
<<xloop>>
LOOP
  IF (x > x_max) THEN
      EXIT;
  END IF;
    i := i + 1;
    returnGeom[i] := st_setsrid(ST_MakePoint(x, y), srid);
    x := ST_X(ST_Project(st_setsrid(ST_MakePoint(x, y), srid), x_side, radians(90))::geometry);
END LOOP xloop;
END LOOP yloop;
RETURN
ST_CollectionExtract(st_transform(ST_Intersection(st_collect(returnGeom), geom), input_srid), 1);
END;
$BODY$ LANGUAGE plpgsql IMMUTABLE;
```

# 2. Création vue Geoserver

Créez une vue dans Geoserver que vous appelerez `PointGridView`à partir de la BDD alegoria.
Dans la partie SQL, entrez :
```
SELECT I_Grid_Point_Distance(footprint, 1000, 1000) from cliches
```
N'oubliez pas de renseigner les emprises dans la rubrique Publication.

# 3. Création style Heatmap et application du style sur la vue

Créez un style dans Geoserver avec un style par défaut de point que vous appelerez `Heatmap`.
Dans la partie code, renseignez le code suivant : 

```
<?xml version="1.0" encoding="ISO-8859-1"?>
     <StyledLayerDescriptor version="1.0.0"
         xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd"
         xmlns="http://www.opengis.net/sld"
         xmlns:ogc="http://www.opengis.net/ogc"
         xmlns:xlink="http://www.w3.org/1999/xlink"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
       <NamedLayer>
         <Name>Heatmap</Name>
        <UserStyle>
          <Title>Heatmap</Title>
          <Abstract>A heatmap surface showing population density</Abstract>
          <FeatureTypeStyle>
            <Transformation>
              <ogc:Function name="vec:Heatmap">
                <ogc:Function name="parameter">
                  <ogc:Literal>data</ogc:Literal>
                </ogc:Function>
                <ogc:Function name="parameter">
                  <ogc:Literal>weightAttr</ogc:Literal>
                  <ogc:Literal>pop2000</ogc:Literal>
                </ogc:Function>
                <ogc:Function name="parameter">
                  <ogc:Literal>radiusPixels</ogc:Literal>
                  <ogc:Function name="env">
                    <ogc:Literal>radius</ogc:Literal>
                    <ogc:Literal>100</ogc:Literal>
                  </ogc:Function>
                </ogc:Function>
                <ogc:Function name="parameter">
                  <ogc:Literal>pixelsPerCell</ogc:Literal>
                  <ogc:Literal>10</ogc:Literal>
                </ogc:Function>
                <ogc:Function name="parameter">
                  <ogc:Literal>outputBBOX</ogc:Literal>
                  <ogc:Function name="env">
                    <ogc:Literal>wms_bbox</ogc:Literal>
                  </ogc:Function>
                </ogc:Function>
                <ogc:Function name="parameter">
                  <ogc:Literal>outputWidth</ogc:Literal>
                  <ogc:Function name="env">
                    <ogc:Literal>wms_width</ogc:Literal>
                  </ogc:Function>
                </ogc:Function>
                <ogc:Function name="parameter">
                  <ogc:Literal>outputHeight</ogc:Literal>
                  <ogc:Function name="env">
                    <ogc:Literal>wms_height</ogc:Literal>
                  </ogc:Function>
                </ogc:Function>
              </ogc:Function>
            </Transformation>
           <Rule>
             <RasterSymbolizer>
             <!-- specify geometry attribute to pass validation -->
               <Geometry>
                 <ogc:PropertyName>the_geom</ogc:PropertyName></Geometry>
               <!-- <Opacity>0.6</Opacity> -->
               <ColorMap type="ramp" >
                 <ColorMapEntry color="#FFFFFF" quantity="0" label="nodata"/>
                 <ColorMapEntry color="#fee0d2" quantity="0.02" label="nodata"/>
                 <!-- <ColorMapEntry color="#fcbba1" quantity="0.05" label="nodata"/> -->
                 <ColorMapEntry color="#fc9272" quantity=".2" label="values" />
                 <!-- <ColorMapEntry color="#fb6a4a" quantity=".4" label="values" /> -->
                 <ColorMapEntry color="#ef3b2c" quantity=".6" label="nodata"/>
                 <!-- <ColorMapEntry color="#cb181d" quantity=".8" label="values" /> -->
                 <ColorMapEntry color="#67000d" quantity="1.0" label="values" />
               </ColorMap>
             </RasterSymbolizer>
            </Rule>
          </FeatureTypeStyle>
        </UserStyle>
      </NamedLayer>
     </StyledLayerDescriptor>
```

Retournez dans la vue que vous avez créé via l'onglet couches. 
Dans la rubrique Publication, cherchez `Configuration du WMS`, sélectionnez dans Style par défaut ; Heatmap (ou le nom de votre style).
Sauvegardez et prévisualisez le résultat via l'onglet `Prévisualisation de la couche`.
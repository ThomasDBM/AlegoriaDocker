# API MicMac

## "aspro" command
---
### MicMac command short description :

Init External orientation of calibrated camera from GCP. ([MicMac documentation](https://micmac.ensg.eu/index.php/Aspro))

Mandatory unnamed args :
* string :: {Name File for images} (1)
* string :: {Name File for input calibration} (2)
* string :: {Name File for GCP} (3)
* string :: {Name File for Image Measures} (4)

**return ????**

Example :
```
mm3d aspro 1957_DUR_452_0018.jpg Ori-CalInit gcp_1957_DUR_452_0018.xml appuis_1957_DUR_452_0018.xml "1957_DUR_452_0018.jpg"
```

### Route :
#### Method : GET
#### Route : `/aspro/{imgURL}/{coordPoint3d}/{coordPoint2d}`
#### Mandatory parameters :
- **{imgURL}** : (string) url to dowload original image
- **{coordPoint3d}** : (list(Float)) coordinates of points d'appui in EPSG:4978 (type [[x1,y1,z1],..,[xn,yn,zn]])
- **{coordPoint2d}** : (list(Float)) coordinates of points d'appui on the image in pixel (type [[x1,y1,z1],..,[xn,yn,zn]])
#### Do :
1. Create calibration file ( cf : [createCalibrationFile.js](https://github.com/ThomasDBM/alegoria/blob/clean2/js/createCalibrationFile.js) -> build xml data, [createCalibrationFile.php](https://github.com/ThomasDBM/alegoria/blob/clean2/php/createCalibrationFile.php) -> save xml data in a file)
2. Create GCP file ( cf : [scene3dv2.js](https://github.com/ThomasDBM/alegoria/blob/clean2/js/scene3dv2.js) -> function export3dCoord() : build xml data, [fetch3dcoord.php](https://github.com/ThomasDBM/alegoria/blob/clean2/php/fetch3dcoord.php) -> save xml data in a file)
3. Create appuie file ( cf : [scene2d.js](https://github.com/ThomasDBM/alegoria/blob/clean2/js/scene2d.js) -> function export2dCoord() ou getImgCoordOnClick (to check) : build xml data, [fetch2dcoord.php](https://github.com/ThomasDBM/alegoria/blob/clean2/php/fetch2dcoord.php)-> save xml data in a file)
4. Lauch command MicMac 
#### Return :
## "Apero" command
---
### MicMac command short description :

Example :
```
"/var/www/micmac/bin/mm3d" Apero  /var/www/micmac/include/XML_MicMac/Apero-GCP-Init.xml  DirectoryChantier=./ +PatternAllIm=1957_DUR_452_0018.jpg +CalibIn=CalInit +AeroOut=Aspro +DicoApp=gcp_1957_DUR_452_0018.xml +SaisieIm=appuis_1957_DUR_452_0018.xml
```

### Route :

#### Method : ?
#### Route : `/apero/{imgURL}/{coordPoint3d}/{coordPoint2d}`
#### Mandatory parameters :
- **{imgURL}** : (string) url to dowload original image
- **{coordPoint3d}** : (list(Float)) coordinates of points d'appui in EPSG:4978 (type [[x1,y1,z1],..,[xn,yn,zn]])
- **{coordPoint2d}** : (list(Float)) coordinates of points d'appui on the image in pixel (type [[x1,y1,z1],..,[xn,yn,zn]])
#### Do :  
#### Return :
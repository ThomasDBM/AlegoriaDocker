# API MicMac

## Routes :
### Route : `/calib/{imgURL}/{PP}/{F}/{SzIm}/{Cdist}`
### Method : **GET**
### Return : AutoCal_imgname.xml
### Mandatory parameters :
- **{imgURL}** : (string) url to dowload original image
- **{PP}** : (list(Int)) principal (type [x1,y1])
- **{F}** : (Int) Focal 
- **{SzIm}** : (list(Int)) image size in pixel (type [x1,y1])
- **{Cdist}** : (list(Int)) distortion coefficient (type [x1,y1])
### Do :
Create calibration file ( cf : [createCalibrationFile.js](https://github.com/ThomasDBM/alegoria/blob/clean2/js/createCalibrationFile.js) -> build xml data, [createCalibrationFile.php](https://github.com/ThomasDBM/alegoria/blob/clean2/php/createCalibrationFile.php) -> save xml data in a file)
- - - 
### Route : `/point2d/{imgURL}/{coordPoint2d}`
### Method : **GET**
### Return : appui_imgname.xml
### Mandatory parameters :
- **{imgURL}** : (string) url to dowload original image
- **{coordPoint2d}** : (list(Float)) coordinates of points d'appui on the image in pixel (type [[x1,y1,z1],..,[xn,yn,zn]])
### Do :
Create appuie file ( cf : [scene2d.js](https://github.com/ThomasDBM/alegoria/blob/clean2/js/scene2d.js) -> function export2dCoord() ou getImgCoordOnClick (to check) : build xml data, [fetch2dcoord.php](https://github.com/ThomasDBM/alegoria/blob/clean2/php/fetch2dcoord.php)-> save xml data in a file)
- - - 
### Route : `/point3d/{imgURL}/{coordPoint3d}`
### Method : **GET**
### Return : gcp_imgname.xml
### Mandatory parameters :
- **{imgURL}** : (string) url to dowload original image
- **{coordPoint3d}** : (list(Float)) coordinates of points d'appui in EPSG:4978 (type [[x1,y1,z1],..,[xn,yn,zn]])
### Do :
Create GCP file ( cf : [scene3dv2.js](https://github.com/ThomasDBM/alegoria/blob/clean2/js/scene3dv2.js) -> function export3dCoord() : build xml data, [fetch3dcoord.php](https://github.com/ThomasDBM/alegoria/blob/clean2/php/fetch3dcoord.php) -> save xml data in a file) 
- - -    
### Route : `/aspro/{imgURL}/{AutoCal}/{appui}/{gcp}`
### Method : **POST**
### Return : orientation_imgname.xml
### Mandatory parameters :
- **{imgURL}** : (string) url to dowload original image
- **{AutoCal}** : (file) calibration file
- **{appui}** : (file) file of 2d point of appuis
- **{gcp}** : (file) file of 3d point of appui
### Do :
Lauch command MicMac : aspro.

**MicMac command short description :**

Init External orientation of calibrated camera from GCP. ([MicMac documentation](https://micmac.ensg.eu/index.php/Aspro))

Mandatory unnamed args :
* string :: {Name File for images} (1)
* string :: {Name File for input calibration} (2)
* string :: {Name File for GCP} (3)
* string :: {Name File for Image Measures} (4)

Create 3 files :
- Ori-Aspro/AutoCal_Foc-50000_Cam-{imgname}.xml
- Ori-Aspro/Densite_AutoCal_Foc-50000_Cam-{imgname}.tif
- Ori-Aspro/Orientation-{imgname}.jpg.xml


Example :
```
mm3d aspro 1957_DUR_452_0018.jpg Ori-CalInit gcp_1957_DUR_452_0018.xml appuis_1957_DUR_452_0018.xml "1957_DUR_452_0018.jpg"
```

cf : computeResection() in [index.html](https://github.com/ThomasDBM/alegoria/blob/clean2/index.html) and [lauchMicMac.php](https://github.com/ThomasDBM/alegoria/blob/clean2/php/launchMicMac.php)
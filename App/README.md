# Application Directory

Put in this directory the needed files to run tha alegoria App : 
- alegoria repository : https://github.com/ThomasDBM/alegoria
- itowns repository : https://github.com/itowns/itowns
- photogrammetric-camera : https://github.com/ThomasDBM/photogrammetric-camera

## Set-up
Pour itowns 2 possibilités :
1) Après avoir cloner le depot itowns, dans la dernière release (https://github.com/iTowns/itowns/releases/tag/v2.37.0) télécharger le bundle au format zip. Le deziper puis le renommer "dist". Copier coller le dossier dans le dossier itowns.

2) Télécharger le code source de la dernière release d'itowns puis compiler le projet :
A la racine vérifier la version de node soit v15.x
- Si ce n'est pas la bonne changer de version avec nvm :
`nvm use v15`
- Installer les paquets :
`npm ci`
- Preparer avant le build :
`npm run prepare`
- Verifier Linter :
`npm run lint -- --max-warnings=0`
- npm run buildBuild le bundle (dossier dist):
`npm run build`

Dans le dossier photogrammetric-camera:
- Supprimer le fichier package-lock.json
```
sudo rm package-lock.json
```
- Créer à nouveau ce fichier
```
npm install 
```
- Lancer le build
```
npm run build
```


Pour le dossier alegoria, passer sur la branche clean2. 
Donner tout les droits à certains fichiers :

```
chmod 777 data/SauvApero.xml data/test/SauvApero.xml data/test/MicMac-LocalChantierDescripteur.xml data/test/MicMac-LocalChantierDescripteurSAVE.xml
```
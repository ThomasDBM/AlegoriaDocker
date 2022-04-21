cd App
echo "install App"

git clone https://github.com/ThomasDBM/alegoria.git
git clone https://github.com/iTowns/itowns.git
git clone https://github.com/ThomasDBM/photogrammetric-camera.git

cd itowns
echo "get itowns"
wget https://github.com/iTowns/itowns/releases/download/v2.38.1/bundles.zip
unzip bundles.zip -d dist
rm bundles.zip
cd ..

cd photogrammetric-camera
echo "build photogrammetric camera"
rm package-lock.json
npm install
npm run build
cd ..

cd ..
cd API_MicMac
echo "install api"

git clone https://github.com/ThomasDBM/MicMac-API.git

cd MicMac-API

./build.sh

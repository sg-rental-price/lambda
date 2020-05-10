BASE=$(dirname "$0")/..
TMP=$BASE/tmp
TAR=$TMP/nodejs
mkdir -p $TAR
cd $TMP
cp -r ../node_modules ./nodejs
cp ../package.json ./nodejs
zip -r ./node_modules.zip ./nodejs

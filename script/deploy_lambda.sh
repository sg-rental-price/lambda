BASE=$(dirname "$0")/..
TAR=$BASE/src/$FUNC
TMP=$BASE/tmp/lambda

mkdir -p $TMP/$FUNC
cd $BASE
rm -f ./tmp/lambda/$FUNC.zip
rm -f ./tmp/lambda/$FUNC/*
cp -r ./src/$FUNC/* ./tmp/lambda/$FUNC/
cd ./tmp/lambda/$FUNC
zip -r ../$FUNC.zip .
cd ..
aws2 lambda update-function-code --function-name ${FUNC} --zip-file fileb://${FUNC}.zip

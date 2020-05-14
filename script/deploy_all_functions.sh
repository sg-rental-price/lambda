#!/usr/bin/env bash
echo "Deploy all functions"

# Prepare
mkdir -p ./tmp/lambda
rm -rf ./tmp/lambda/*

cd ./tmp/lambda

for path in ../../src/*; do
  FUNC=$(basename $path)
  if [ "$FUNC" != "common" ]; then
    echo ">Processing function $FUNC";
    mkdir -p ./$FUNC
    cp -r ../../src/$FUNC ./$FUNC/
    cp -r ../../src/common ./$FUNC/
    echo "exports.handler=require('./$FUNC/index').handler" > ./$FUNC/index.js

    echo ">>Compact"
    cd $FUNC
    zip -r ../$FUNC.zip .

    cd ..
    echo ">>Update function"
    aws lambda update-function-code --function-name ${FUNC} --zip-file fileb://${FUNC}.zip
  fi
done


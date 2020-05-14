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


    FUNC_ALIAS=''
    case "$BRANCH" in
        production)
            FUNC_ALIAS="prod"
            ;;
        staging)
            FUNC_ALIAS="staging"
            ;;
    esac

    echo ">Deploying to alias ${FUNC_ALIAS:-LATEST}"

    DESCRIPTION="Auto deploy commit $GITHUB_SHA to ${FUNC_ALIAS:-LATEST} alias"

    VERSION=$(aws lambda publish-version --function-name=$FUNC --description="$DESCRIPTION" | grep Version | cut -d"\"" -f4)
    echo ">>Created new version $VERSION"

    if [ "$FUNC_ALIAS" = "" ]; then
      continue
    fi

    aws lambda update-alias --function-name=$FUNC --function-version=$VERSION --name=$FUNC_ALIAS

    echo ">>Updated alias"
  fi
done


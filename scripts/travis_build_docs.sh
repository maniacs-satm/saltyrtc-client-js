#!/bin/bash
# https://github.com/phosphorjs/phosphor/wiki/TypeDoc-Publishing
if [[ $TRAVIS_PULL_REQUEST == false && $TRAVIS_BRANCH == "develop" ]]
then
    echo "-- will build docs --"

    git config --global user.email "travis@travis-ci.com"
    git config --global user.name "Travis Bot"

    # Build docs
    rm -rf docs/
    npm install https://github.com/TypeStrong/typedoc/archive/2e855cf8c62c7813ac62cb1ef911c9a0c5e034c2.tar.gz
    cd node_modules/typedoc/
    tsc
    cd ../..
    node_modules/.bin/typedoc --out docs saltyrtc/

    # Clone gh-pages repo
    git clone https://github.com/saltyrtc/saltyrtc-client-js.git travis_docs_build
    cd travis_docs_build
    git checkout gh-pages

    # Git credentials
    echo "https://${GHTOKEN}:@github.com" > .git/credentials
    git config credential.helper "store --file=.git/credentials"

    # Commit docs
    rm -rf ./*
    cp -r ../docs/* ./.
    git add -A
    git commit -m "autocommit docs"
    git push origin gh-pages
else
    echo "-- will only build docs from develop --"
fi

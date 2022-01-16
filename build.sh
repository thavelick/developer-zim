#!/bin/bash
set -e

function genrate_zim() {
    doc_root=$build_root/$doc_name

    [ -d "$doc_root" ] && return
    mkdir "$doc_root"
    curl -sfL "$download_url" -o "$doc_root/$archive"
    cd "$doc_root"
    dtrx "$doc_root/$archive" 
    cd "$project_root"
    curl -sfL "$favicon_url" -o "$doc_root"/"$doc_folder"/favicon.ico
    zimwriterfs \
        --welcome=index.html \
        --favicon=favicon.ico \
        --language=eng \
        --title="$formal_name $doc_version Documentation" \
        --description="Developer  Documentation for $formal_name $doc_version" \
        --creator="$creator" \
        --publisher="Tristan Havelick" \
        "$doc_root"/"$doc_folder" \
        "$build_root"/python-"$doc_version".zim
}

project_root=$(pwd)
build_root=$project_root/build
mkdir -p "$build_root"

doc_name=python
formal_name=Python
creator="Python Software Foundation"
doc_version=3.10.2
doc_folder=python-$doc_version-docs-html
archive=$doc_folder.tar.bz2
download_url=https://docs.python.org/3/archives/$archive 
favicon_url=https://python.org/favicon.ico

genrate_zim


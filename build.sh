#!/bin/bash
set -e

function write_zim_file() {
    zim_file="$build_root"/$doc_name-"$doc_version".zim
    [ -f "$zim_file" ] && return
    
    echo "writing $zim_file..."
    zimwriterfs \
        --welcome=index.html \
        --favicon=favicon.ico \
        --language=eng \
        --title="$formal_name $doc_version Documentation" \
        --description="Developer Documentation for $formal_name $doc_version" \
        --creator="$creator" \
        --publisher="Tristan Havelick" \
        "$doc_root"/"$doc_folder" \
        "$zim_file"
}

function fetch_url() {
    archive_file="$doc_root/$archive"
    [ -f "$archive_file" ] && return
    echo "fetching $download_url"
    curl -sfL "$download_url" -o "$archive_file"
}

function unarchive() {
    cd "$doc_root"
    dtrx -n -o "$doc_root/$archive" 
    cd "$project_root"
}

function fetch_favicon() {
    favicon_file="$doc_root"/"$doc_folder"/favicon.ico
    [ -f "$favicon_file" ] && return
    echo "writing favicon to: $favicon_file"
    curl -fLs "$favicon_url" -o "$favicon_file"
}

function make_folder() {
    mkdir -p "$doc_root"
}

function genrate_python_zim() {
    doc_name=python
    formal_name=Python
    creator="Python Software Foundation"
    doc_version=3.10.2
    doc_folder=python-$doc_version-docs-html
    archive=$doc_folder.tar.bz2
    download_url=https://docs.python.org/3/archives/$archive 
    favicon_url=https://python.org/favicon.ico
    doc_root=$build_root/$doc_name

    make_folder
    fetch_url
    unarchive
    fetch_favicon
    write_zim_file
}

function generate_flask_zim() {
    doc_name=flask
    formal_name=Flask
    creator="Pallets"
    doc_version="1.1.x"
    doc_folder=$doc_name-$doc_version
    archive=$doc_folder.zip
    download_url=https://flask.palletsprojects.com/_/downloads/en/$doc_version/htmlzip/
    favicon_url=https://flask.palletsprojects.com/favicon.ico
    doc_root=$build_root/$doc_name

    make_folder
    fetch_url
    unarchive
    fetch_favicon
    write_zim_file
}

function generate_sqlalchemy_zim() {
    doc_name=sqlalchemy
    formal_name=SqlAlchemy
    creator="SQLAlchemy authors and contributors"
    doc_version="1.4"
    doc_version_numbers=$(echo "$doc_version" | tr -d '.')
    doc_folder=$doc_name-$doc_version
    archive=$doc_folder.zip
    download_url=https://docs.sqlalchemy.org/$doc_version_numbers/sqlalchemy_$doc_version_numbers.zip
    favicon_url=https://www.sqlalchemy.org/favicon.ico
    doc_root=$build_root/$doc_name

    make_folder
    fetch_url
    unarchive
    fetch_favicon
    write_zim_file
}



project_root=$(pwd)
build_root=$project_root/build
mkdir -p "$build_root"

genrate_python_zim
generate_flask_zim
generate_sqlalchemy_zim

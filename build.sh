#!/bin/bash
set -e

function write_zim_file() {
    zim_file="$build_root"/$doc_name-"$doc_version".zim
    [ -f $zim_file ] && return
    
    zimwriterfs \
        --welcome=index.html \
        --favicon=favicon.ico \
        --language=eng \
        --title="$formal_name $doc_version Documentation" \
        --description="Developer Documentation for $formal_name $doc_version" \
        --creator="$creator" \
        --publisher="Tristan Havelick" \
        "$doc_root"/"$doc_folder" \
        $zim_file 
}

function fetch_url() {
    archive_file="$doc_root/$archive"
    [ -f "$archive_file" ] && return
    curl -sfL "$download_url" -o "$archive_file"
}

function unarchive() {
    cd "$doc_root"
    dtrx "$doc_root/$archive" 
    cd "$project_root"
}

function fetch_favicon() {
    favicon_file="$doc_root"/"$doc_folder"/favicon.ico
    [ -f $favicon_file ] && return
    curl -sfL "$favicon_url" -o $favicon_file
}

function make_folder() {
    mkdir "$doc_root"
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
    [ -d "$doc_root" ] && return
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


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
    dtrx -o "$doc_root/$archive" 
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

function generate_mdn_zim() {
    doc_name=mdn
    formal_name="MDN Web"
    creator=Mozilla
    doc_version=$(date +%F) # Isn't versioned, so just use the date 
    favicon_url=https://developer.mozilla.org/favicon.ico
    doc_root=$build_root/$doc_name
    git_content_root=$doc_root/content
    git_yari_root=$doc_root/yari
    doc_folder="yari/client/build"

    echo "building zim file for $formal_name..."
    make_folder
    [ ! -d "$git_content_root" ] && echo "cloning content..." && git clone -q --depth 1 https://github.com/mdn/content "$git_content_root"
    [ ! -d "$git_yari_root" ] && echo "cloning yari..." && git clone -q --depth 1 https://github.com/mdn/yari "$git_yari_root"
    cd "$git_yari_root"
    if [ ! -d "$git_yari_root/client/build" ]; then
        echo "building yari..." 
        yarn 
        yarn prepare-build
        CONTENT_ROOT="$git_content_root/files" yarn build
    fi
    cd "$project_root"
    write_zim_file
}

project_root=$(pwd)
build_root=$project_root/build
mkdir -p "$build_root"

genrate_python_zim
generate_mdn_zim

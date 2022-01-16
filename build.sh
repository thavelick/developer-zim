#!/bin/sh
set -e

build_root=build
python_root=$build_root/python
python_version=3.10.2
python_folder=python-$python_version-docs-html
archive=$python_folder.tar.bz2
mkdir -p $build_root

if [ ! -d $python_root ]; then
    mkdir $python_root
    curl -sfL https://docs.python.org/3/archives/$archive -o $python_root/$archive
    tar -xf $python_root/$archive -C $python_root
    curl -sfL https://python.org/favicon.ico -o $python_root/$python_folder/favicon.ico
    zimwriterfs \
        --welcome=index.html \
        --favicon=favicon.ico \
        --language=eng \
        --title="Python $python_version Documentation" \
        --description="Developer  Documentation for Python $python_version" \
        --creator="Python Software Foundation" \
        --publisher="Tristan Havelick" \
        $python_root/$python_folder \
        $build_root/python-$python_version.zim
fi

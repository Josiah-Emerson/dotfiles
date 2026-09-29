#!/bin/bash

# temporary script to remove every file in test
shopt -s extglob
set -e

cd test/

rm -rf !(foo.txt)

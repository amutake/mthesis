#!/bin/bash

sed -i -e 's/。/．/g' ./*.tex
sed -i -e 's/、/，/g' ./*.tex
rm ./*.tex-e

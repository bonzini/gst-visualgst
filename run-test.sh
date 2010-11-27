#! /bin/sh

./make_packages.sh
gst-sunit -p VisualGST

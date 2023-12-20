#!/bin/sh

#install & activate conda env
. ./install-conda-prod.sh

#install bs4 for webscraping
conda install -y beautifulsoup4 bs4

#run scraping script
python3 scrape.py

#install ndcctools from conda
. conda-inst.sh

#run quickstart.py from conda
. run-python.sh &

vine_worker localhost 9123 --single-shot

#!/bin/bash
set -e

# remove the old /output
rm -rf ./output

# build the image from Dockerfile
docker build -t zillow-scraper .

# run the container from image
docker run \
       --rm \
       --name=zillow-scraper \
       --volume="$(pwd)/output:/app/output" \
       zillow-scraper
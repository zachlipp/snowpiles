#!/bin/bash
set -uo pipefail

mkdir maps

BASE_URL="http://www.nohrsc.noaa.gov/snowfall/data/"
PAST=$(date -I -d "${TODAY} - 4 months")
# Snowfall maps start on 09/30
SNOWFALL_START="$(date +%Y -d $PAST)093012"

until [[ $PAST == ${TODAY} ]]; do
  BASENAME="sfav2_CONUS_${SNOWFALL_START}_to_$(date +%Y%m%d -d $PAST)12.tif"
  YEARMON=$(date -d ${PAST} +%Y%m)
  curl \
    -L \
    --silent \
    -o maps/${PAST}.tif \
    ${BASE_URL}/${YEARMON}/${BASENAME}
  echo $BASENAME
  # The NOAA are our friends
  sleep 1
  PAST=$(date -I -d "$PAST + 1 day")
done

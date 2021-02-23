#!/bin/bash
set -uo pipefail

# ---
# Download snowfall maps
# ---
mkdir -p maps

BASE_URL="http://www.nohrsc.noaa.gov/snowfall/data/"
# `ls` outputs files alphabetically
PAST=$(ls maps | tail -n 1)
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

# ---
# Transformations
# ---
mkdir -p albers
for map in maps/*.tif; do
  if [[ ! -f albers/$map ]]; then
    gdalwarp \
      -s_srs "+proj=longlat +datum=WGS84 +no_defs" \
      -t_srs "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m no_defs" \
      -srcnodata "-99999" \
      ${map} \
      albers/$(basename $map);
  fi
done

mkdir -p hillshade
for map in albers/*.tif; do
  if [[ ! -f hillshade/$map ]]; then
    gdaldem hillshade \
      -z 5000 \
      "$map" \
      ./hillshade/$(basename $map);
  fi
done

mkdir -p gifs
for map in hillshade/*.tif; do
  if [[ ! -f gifs/$map ]]; then
    convert $map \
      -crop 1311x850+196+164 \
      +repage \
      -resize '50%' \
      -quiet \
      # Second argument to basename removes a suffix
      ./gifs/$(basename $map .tif).gif;
  fi
done

convert -delay 12 -loop 0 gifs/*.gif animated.gif

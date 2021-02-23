#!/bin/bash
set -exuo pipefail

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

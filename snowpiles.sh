#!/bin/bash
set -exuo pipefail
mkdir warped
for map in maps/*.tif; do
  gdalwarp \
    -s_srs "+proj=longlat +datum=WGS84 +no_defs" \
    -t_srs "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m no_defs" \
    -srcnodata "-99999" \
    ${map} \
    warped/$(basename $map);
done

mkdir hillshade
for warped in warped/*.tif; do
  gdaldem hillshade \
    -z 5000 \
    "$warped" \
    ./hillshade/$(basename $warped);
done

mkdir gifs
for hillshade in hillshade/*.tif; do
  convert $hillshade \
    -crop 1311x850+196+164 \
    +repage \
    -resize '50%' \
    -quiet \
    ./gifs/$(basename $hillshade).gif;
done

convert -delay 12 -loop 0 gifs/*.gif animated.gif

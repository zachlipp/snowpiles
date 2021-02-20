FROM osgeo/gdal:ubuntu-small-3.2.1

RUN apt-get update && \
    apt-get install -y \
      imagemagick \
      curl

COPY download_snow_maps.sh /home

WORKDIR home

RUN ./download_snow_maps.sh

COPY snowpiles.sh .

ENTRYPOINT ./snowpiles.sh

FROM osgeo/gdal:ubuntu-small-3.2.1

RUN apt-get update && \
    apt-get install -y \
      imagemagick \
      curl

COPY download_snow_maps.sh /home

WORKDIR home

ENV TODAY=2021-02-23

RUN ./download_snow_maps.sh

COPY snowpiles.sh .

ENTRYPOINT ./snowpiles.sh

FROM osgeo/gdal:ubuntu-small-3.2.1

RUN apt-get update && \
    apt-get install -y \
      imagemagick \
      curl

ENV TODAY=2021-02-23

WORKDIR home

ENTRYPOINT ./snowpiles.sh

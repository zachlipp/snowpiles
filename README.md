# Snowpiles animated map

## Overview

I love Garret Dash Nelson's [snowpiles](http://viewshed.matinic.us/2018/01/13/1139/) visualization. Given the insane amount of snow the US has gotten this season, I decided to update the map.

The code here is almost entirely copied and pasted from the blog post above, save for:
- `download_snow_maps.sh`, which rewrites the Python data fetch script as a bash script. This was mostly for my own learning.
- My gdal installation wasn't finding the ESPG codes, so I replaced the source and target SRS with the explict definitions of each. (`gdalsrsinfo` is a lifesaver.) I'm sure this is a configuration problem; I'm just not familiar with this tool.
- I added a Dockerfile to simplify reproducing this thing.


## Running

**This Dockerfile fetches data at build time.** This is a little idiosyncratic, but it lets us cache the data easily.

```
docker build -t snowpiles . && \
  docker run --name snowpiles snowpiles && \
  docker cp snowpiles:/home/animated.gif .
```

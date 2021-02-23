# Snowpiles animated map

## Overview

I love Garret Dash Nelson's [snowpiles](http://viewshed.matinic.us/2018/01/13/1139/) visualization. Given the insane amount of snow the US has gotten this season, I decided to update the map.

The code here is almost entirely copied and pasted from the blog post above, save for:
- I moved downloading the maps into bash to learn how to iterate over dates.
- I cache files as I download or create them so I can incrementally update the map.
- My gdal installation wasn't finding the ESPG codes, so I replaced the source and target SRS with the explict definitions of each. (`gdalsrsinfo` is a lifesaver.) I'm sure this is a configuration problem; I'm just not familiar with this tool.
- I added a Dockerfile to simplify reproducing this thing.


## Running

**This will write over 1.5Gb this directory!**

```
docker build -t snowpiles . && \
  docker run --name snowpiles -v $(pwd):/home/ --rm snowpiles
```

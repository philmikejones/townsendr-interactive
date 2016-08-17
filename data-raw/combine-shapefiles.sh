#! /bin/bash

ogr2ogr -update -append -f 'ESRI Shapefile' \
  inst/extdata/lad_2011_gen.shp \
  inst/extdata/wales_lad_2011_gen.shp

ogr2ogr -simplify 100 -f 'ESRI Shapefile' \
  inst/extdata/lad_2011_simp.shp         \
  inst/extdata/lad_2011_gen.shp

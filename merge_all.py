for %f in (*.shp) do (
ogr2ogr -update -append build/merged_shp/merge.shp %f  -f “esri shapefile” -nln merge )


for i in $(ls build/*.shp); do ogr2ogr -f 'ESRI Shapefile' -update -append merged $i -nln contours

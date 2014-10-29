build/250DG.json: build/250D.shp/250D.shp
	ogr2ogr -f GeoJSON build/250DG.json build/250D.shp/250D.shp


build/250D.json: build/250DG.json
	node_modules/.bin/topojson \
	-o $@ \
	-p elevation="ELEVATION" \
	--simplify=0.5 \
	--filter=none \
	-- 250D=$<


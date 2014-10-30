# get map of Canada and widdle down to Nanaimo

build/subunits.json: build/Boundaries/CD_2011.shp
	ogr2ogr -f GeoJSON  -where "CDNAME IN ('Nanaimo')" \
	build/subunits.json \
	build/Boundaries/CD_2011.shp

nanaimo.json: build/subunits.json
	node_modules/.bin/topojson \
		-o $@ \
		-- $<
		# --projection='width = 960, height = 600, d3.geo.albers() \
		# 	.scale(1280) \
		# 	.translate([width / 2, height / 2]) \
		# 	.rotate([96, 0]) \
		# 	.center([-123.99, 49.1])' \

# contour stuff
build/250DG.json: build/250D.shp/250D.shp
	ogr2ogr -f GeoJSON build/250DG.json build/250D.shp/250D.shp


build/250D.json: build/250DG.json
	node_modules/.bin/topojson \
	-o $@ \
	-p elevation="ELEVATION" \
	--simplify=0.5 \
	--filter=none \
	-- 250D=$<



#.center([-122.4183, 37.7750])
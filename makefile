# get map of Canada and widdle down to Nanaimo

build/subunits.json: build/Boundaries/CD_2011.shp
	ogr2ogr -f GeoJSON  -t_srs "+proj=latlong +datum=WGS84" -where "CDNAME IN ('Nanaimo')" \
	build/subunits.json \
	build/Boundaries/CD_2011.shp

nanaimo.json: build/subunits.json
	node_modules/.bin/topojson \
	--projection='width = 1060, height = 1100, d3.geo.conicConformal() \
				.rotate([98, 0]) \
			    .center([-25.9, 49.12]) \
			    .parallels([-75, 80.5]) \
			    .scale(650000) \
			    .translate([width / 2, height / 2])' \
		-o $@ \
		-- $<
			



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
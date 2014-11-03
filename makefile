# get map of Canada and widdle down to Nanaimo

build/subunits.json: build/Boundaries/CD_2011.shp
	ogr2ogr -f GeoJSON  -t_srs "+proj=latlong +datum=WGS84" -where "CDNAME IN ('Nanaimo')" \
	build/subunits.json \
	build/Boundaries/CD_2011.shp

nanaimo.json: build/subunits.json build/250DG.json
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

#250D
build/250DG.json: build/250D.shp/250D.shp
	ogr2ogr -f GeoJSON build/250DG.json -t_srs "+proj=latlong +datum=WGS84" build/250D.shp/250D.shp


build/250D.json: build/250DG.json
	node_modules/.bin/topojson \
	--projection='width = 1060, height = 1100, d3.geo.conicConformal() \
				.rotate([98, 0]) \
			    .center([-25.9, 49.12]) \
			    .parallels([-75, 80.5]) \
			    .scale(650000) \
			    .translate([width / 2, height / 2])' \
	-o $@ \
	-p elevation="ELEVATION" \
	--simplify=0.5 \
	--filter=none \
	-- 250D=$<



# 250B
build/250B.shp: build/250B.shp.zip
	unzip -od $(dir $@) $<
	touch $@

build/250BG.json: build/250B.shp
	ogr2ogr -f GeoJSON build/250BG.json -t_srs "+proj=latlong +datum=WGS84" build/250B.shp

build/E250B.json: build/250BG.json
	node_modules/.bin/topojson \
	--projection='width = 1060, height = 1100, d3.geo.conicConformal() \
				.rotate([98, 0]) \
			    .center([-25.9, 49.12]) \
			    .parallels([-75, 80.5]) \
			    .scale(650000) \
			    .translate([width / 2, height / 2])' \
	-o $@ \
	-p elevation="ELEVATION" \
	-- E250B=$<

# 251A
build/251A.shp: build/251A.shp.zip
	unzip -od $(dir $@) $<
	touch $@

build/251AG.json: build/251A.shp
	ogr2ogr -f GeoJSON build/251AG.json -t_srs "+proj=latlong +datum=WGS84" build/251A.shp

build/E251A.json: build/251AG.json
	node_modules/.bin/topojson \
	--projection='width = 1060, height = 1100, d3.geo.conicConformal() \
				.rotate([98, 0]) \
			    .center([-25.9, 49.12]) \
			    .parallels([-75, 80.5]) \
			    .scale(650000) \
			    .translate([width / 2, height / 2])' \
	-o $@ \
	-p elevation="ELEVATION" \
	-- E251A=$<

# 251B
build/251B.shp: build/251B.shp.zip
	unzip -od $(dir $@) $<
	touch $@

build/251BG.json: build/251B.shp
	ogr2ogr -f GeoJSON build/251BG.json -t_srs "+proj=latlong +datum=WGS84" build/251B.shp

build/E251B.json: build/251BG.json
	node_modules/.bin/topojson \
	--projection='width = 1060, height = 1100, d3.geo.conicConformal() \
				.rotate([98, 0]) \
			    .center([-25.9, 49.12]) \
			    .parallels([-75, 80.5]) \
			    .scale(650000) \
			    .translate([width / 2, height / 2])' \
	-o $@ \
	-p elevation="ELEVATION" \
	-- E251B=$<

# 251D
build/251D.shp: build/251D.shp.zip
	unzip -od $(dir $@) $<
	touch $@

build/251DG.json: build/251D.shp
	ogr2ogr -f GeoJSON build/251DG.json -t_srs "+proj=latlong +datum=WGS84" build/251D.shp

build/E251D.json: build/251DG.json
	node_modules/.bin/topojson \
	--projection='width = 1060, height = 1100, d3.geo.conicConformal() \
				.rotate([98, 0]) \
			    .center([-25.9, 49.12]) \
			    .parallels([-75, 80.5]) \
			    .scale(650000) \
			    .translate([width / 2, height / 2])' \
	-o $@ \
	-p elevation="ELEVATION" \
	-- E251D=$<

# merge all together
merged.json: nanaimo.json build/E250B.json build/E251A.json build/E251B.json
	node_modules/.bin/topojson \
	-o merged.json -p elevation -- nanaimo=nanaimo.json contour=build/E250B.json contour=build/E251A.json contour=build/E251B.json

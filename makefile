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

# First merge all the shapefiles

# run this in terminal to merge all contour shp files
	# for i in $(ls build/*.shp); do ogr2ogr -f 'ESRI Shapefile' -update -append merged $i -nln contours done

# make Geojson file
build/Geocontours.json: merged/contours.shp
	ogr2ogr -f GeoJSON build/Geocontours.json -t_srs "+proj=latlong +datum=WGS84" merged/contours.shp

# make Topojson file
build/contours.json: build/Geocontours.json
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
	-- contours=$<



# 250B
# build/250B.shp: build/zipped/250B.shp.zip
# 	unzip -od $(dir $@) $<
# 	touch $@

# build/250BG.json: build/250B.shp
# 	ogr2ogr -f GeoJSON build/250BG.json -t_srs "+proj=latlong +datum=WGS84" build/250B.shp

# build/E250B.json: build/250BG.json
# 	node_modules/.bin/topojson \
# 	--projection='width = 1060, height = 1100, d3.geo.conicConformal() \
# 				.rotate([98, 0]) \
# 			    .center([-25.9, 49.12]) \
# 			    .parallels([-75, 80.5]) \
# 			    .scale(650000) \
# 			    .translate([width / 2, height / 2])' \
# 	-o $@ \
# 	-p elevation="ELEVATION" \
# 	-- E250B=$<



# merge all together
merged.json: nanaimo.json build/contours.json
	node_modules/.bin/topojson \
	-o merged.json -p elevation -- nanaimo=nanaimo.json contour=build/contours.json

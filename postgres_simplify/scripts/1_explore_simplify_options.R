library(rgdal)
library(rgeos)
library(maptools)
library(GISTools)
library(ggplot2)






# For a recent project we needed to create a mapping
# application using a specific shapefile of the world's
# countries. Although not super detailed, it was detailed
# enough that it's file size was large (what size?).

# In this post we're going to explore the different options
# for reducing file sizes but maintaining the original
# geometry as much as possible. 

# We found some useful links related to this topic on
# Stack Overflow: http://stackoverflow.com/questions/1849928/how-to-intelligently-degrade-or-smooth-gis-data-simplifying-polygons 
# and ...



# Read in the original shapefile. This is a clipped version
# of the full dataset, the southern tip of South America.
orig<-readOGR("D:/work_big_current/blog/postgres_simplify/gis", "SAsouth")

head(orig@data)

	
g<-ggplot() + 
	geom_polygon(data = orig, aes(x = long, y = lat, group = group),
		fill = "red", color = "gray70")
g	
	
	
	

# Simplify using R, the rgeos library and gSimplify function

# Using a tolerance of 0.01
simp01<-gSimplify(orig, tol = 0.01, topologyPreserve = TRUE)

g + geom_polygon(data = simp01, aes(x = long, y = lat, group = group),
	fill = "blue", color = "gray70", alpha= 0.5)



# Using a tolerance of 0.05
simp05<-gSimplify(orig, tol = 0.05, topologyPreserve = TRUE)

g + geom_polygon(data = simp05, aes(x = long, y = lat, group = group),
	fill = "blue", color = "gray70", alpha= 0.5)



# Using a tolerance of 0.1
simp1<-gSimplify(orig, tol = 0.1, topologyPreserve = TRUE)

g + geom_polygon(data = simp1, aes(x = long, y = lat, group = group),
	fill = "blue", color = "gray70", alpha= 0.5)






# The R library maptools has a function called
# thinnedSpatialPoly (http://www.inside-r.org/packages/cran/maptools/docs/thinnedSpatialPoly) which uses the Douglas-Peuker algorithm for 
# line generalization.
# Authors: Ben Stabler, Michael Friendly, Roger Bivand

thin01<-thinnedSpatialPoly(orig, tolerance = 0.01, minarea=0,
	topologyPreserve = FALSE, avoidGEOS = FALSE)


g + geom_polygon(data = thin01, aes(x = long, y = lat, group = group),
	fill = "blue", color = "gray70", alpha= 0.5)




thin05<-thinnedSpatialPoly(orig, tolerance = 0.05, minarea=0,
	topologyPreserve = TRUE, avoidGEOS = FALSE)

g + geom_polygon(data = thin05, aes(x = long, y = lat, group = group),
	fill = "blue", color = "gray70", alpha= 0.5)




thin1<-thinnedSpatialPoly(orig, tolerance = 0.1, minarea=0,
	topologyPreserve = TRUE, avoidGEOS = FALSE)

g + geom_polygon(data = thin1, aes(x = long, y = lat, group = group),
	fill = "blue", color = "gray70", alpha= 0.5)






# The R library GISTools has a function called
# generalize.polys


gen01<-generalize.polys(orig, tol = 0.01)

g + geom_polygon(data = gen01, aes(x = long, y = lat, group = group),
	fill = "blue", color = "gray70", alpha= 0.5)



writeOGR(thin01, "x://junk", "junkthin", "ESRI Shapefile")


nrow(fortify(thin01))












# datSimp2<-SpatialPolygonsDataFrame(simp1, data = orig@data)







# -------------------------------------------------- #
# Explore what our options are for mapping data in 
# Shiny. We're somewhat restricted here because we
# have to use the IHME country boundaries which are
# quite detailed. We can probably get away with doing
# some smoothing but not much.
# -------------------------------------------------- #


# Read in the 2015 shapefile which has the 2013 data 
# attached (for testing). Remember this shp has insets
# for many of the smaller island nations so should not
# be used to intersect with population grid, etc.
# This file was created using R script:
# 6_link_exposure_data_2015_shp.R

dat<-readOGR("X:/projects/hei_globalBurden/gis/layers/gbd2015", "gbd2015_wdata")


# Add a unique id since some countries have multiple polygons
dat$zid<-1:nrow(dat)



# The original data is definitely going to be
# too big. Let's experiment with simplifying.
# datSimp1<-gSimplify(dat, tol=0.01, topologyPreserve=TRUE)
datSimp2<-gSimplify(dat, tol=0.05, topologyPreserve=TRUE)



# plot(dat, col = "red")
# plot(datSimp2, col = "blue", add = T)




# We'll continue with the datSimp2. I tested using 
# a higher tolerance but the smallest I was able 
# to get it was ~10Mbs and the topology started
# to look a little goofy. Add the data back in.
datSimp2<-SpatialPolygonsDataFrame(datSimp2, data = dat@data)


writeOGR(datSimp2, "x:/junk", "cntry_simp2", driver = "ESRI Shapefile")





# -------------------------------------------------- #
# Highmaps
# -------------------------------------------------- #


# To use highmaps the data needs to be in geojson
# format. First do a basic conversion using the
# geojsonio library.

geodat<-geojson_list(datSimp2, geometry = "polygon")




# Here we'll create the dataframe of colors



temp<-filter(dat@data, O3_2013 != -99999)
temp<-quantile(temp$O3_2013, probs = seq(0, 1, 0.1))
	

# cols<-data.frame(from = c(-99999, temp[1:length(temp)-1]),
# 	to = c(0, temp[2:length(temp)]), 
# 	color = c("#7E827A", substring(viridis(length(temp)-1, option = "D"), 0, 7)))
# cols<-list.parse3(cols)


# colPal<-colorRampPalette(c("#FFDA33", "#731630", "#261822"))
# colPal<-colPal(length(temp)-1)

# colPal<-colorRampPalette(c("#334D5C", "#EFC94C", "#DF4949"))
# colPal<-colPal(length(temp)-1)

colPal<-colorRampPalette(c("#FFD462", "#CF423C", "#73152E"))
colPal<-colPal(length(temp)-1)


cols<-data.frame(from = c(-99999, temp[1:length(temp)-1]),
	to = c(0, temp[2:length(temp)]),
	color = c("#7E827A", colPal))
cols<-list.parse3(cols)




highchart() %>%
	hc_add_series_map(geodat, df = dat@data, joinBy = "zid",
		value = "O3_2013") %>%
	hc_colorAxis(dataClasses = cols) %>%
	hc_legend(valueDecimals = 0, layout = "vertical",
		floating = TRUE, align = "left")


highchart(type = "map") %>%
	hc_add_series(mapData = geodat, lineWidth = 5,
		color = "black", type = "mapline") 
	





highchart(type = "map") %>%
	# hc_add_series_map(geodat, df = dat@data, joinBy = "zid",
	# 	value = "O3_2013") %>%
	hc_add_series(data = geodat, type = "mapline",
		lineWidth = 5, color = "black") %>% 
	hc_colorAxis(dataClasses = cols) %>%
	hc_legend(valueDecimals = 0, layout = "vertical",
		floating = TRUE, align = "left")
	# hc_add_theme(hc_theme_db())
	
	
	
	
	
	
	hc_add_series_map(map = geodat1, df = dat@data, joinBy = "iso3", value = "O3_2013") %>%
	# hc_colorAxis(stops = dstops) %>%
	hc_legend(layout = "vertical", floating = TRUE, align = "left") %>%
	hc_add_theme(hc_theme_db())











datorig<-readOGR(layer = "GBD_WITH_INSETS_NOSUBS", dsn = "X:/projects/hei_globalBurden/data/data_client/20160613_gbd2015_shapefiles/GBD_WITH_INSETS_NOSUBS")
datorig$val<-round(rnorm(nrow(datorig), 16, 4), 2)


dat<-readOGR(dsn = "D:/net_downloads/GBD_WITH_INSETS_NOSUBS_mapshaper", layer = "GBD_WITH_INSETS_NOSUBS")
dat$iso3<-datorig$iso3
dat$val<-round(rnorm(nrow(dat), 16, 4), 2)

# 
# 
# dat2<-dat[dat$CNTRY_NAME %in% c("United States", "Canada", "Mexico"),]
# 
# nshp<-gSimplify(dat, tol=0.1, topologyPreserve=TRUE)
# nshp$iso3<-dat@data$iso3



# nshp<-gSimplify(dat2, tol=0.1, topologyPreserve=TRUE)
# nshp$iso3<-dat2@data$iso3


# dat2<-geojson_json(dat)
mapdat<-geojson_list(dat, geometry = "polygon")
mapdat2<-geojson_list(datorig, geometry = "polygon")



library("viridisLite")
n <- 10
dstops <- data.frame(q = 0:n/n, c = substring(viridis(n + 1, option = "D"), 0, 7))
dstops <- list.parse2(dstops)



highchart() %>%
	hc_add_series_map(map = mapdat, df = dat@data, joinBy = "iso3", value = "val") %>%
	hc_colorAxis(stops = dstops) %>%
	hc_legend(layout = "vertical", floating = TRUE, align = "left") %>%
	hc_add_theme(hc_theme_db())



highchart() %>%
	hc_add_series_map(map = mapdat2, df = datorig@data, joinBy = "iso3", value = "val") %>%
	hc_colorAxis(stops = dstops) %>%
	hc_legend(layout = "vertical", floating = TRUE, align = "left") %>%
	hc_add_theme(hc_theme_db())


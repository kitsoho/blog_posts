library(ggplot2)
library(gstat)
library(sp)
library(maptools)
library(rgdal)
library (raster)
require(grid)
library(png)

gpclibPermit()

setwd('/Users/alper/Downloads/___temp/_R_Code_Zev')

state <- readOGR(dsn = "/Users/alper/Downloads/___temp/_R_Code_Zev", layer = "akarcay")
projection(state) <- CRS("+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +no_defs")

xidw <- raster("test.tiff")
crs(xidw) <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs" 

xidw.sub <- crop(xidw, extent(state))
xidw.sub <- mask(xidw.sub, state)

yidw <- projectRaster(xidw.sub, crs='+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs')

png(filename="output.png", width=800, height=500, bg="transparent")
par(mar=c(0, 0, 0, 0));
plot(yidw, axes = F, box = F, legend = F)
dev.off();

library(foreign)
library(raster)
library(rgdal)
library(grid)



# Raster layer
xidw<-raster("D:/work_big_current/blog/raster_plot_margins/data/R_Export/test.tiff")

# State layer
state<-readOGR(dsn="D:/work_big_current/blog/raster_plot_margins/data/R_Export/akarcay.shp", layer="akarcay") 

# Set crs of raster
crs(xidw)<-"+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs" 

# New crs
crsNew<-"+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs"

# Project the raster
yidw<-projectRaster(xidw, crs=crsNew)

# Project the state
state.tr<-spTransform(state, CRS(crsNew))


# Crop to extent of state and mask
xidw.sub<-crop(yidw, extent(state.tr))
xidw.sub<-mask(xidw.sub, state.tr)


# Examples of plotting using spplot
# Plot, assign colors, otherwise use default
spplot(xidw.sub, col.regions=rev(terrain.colors(30, alpha = 1)))

# Plot, remove legend
spplot(xidw.sub, col.regions=rev(terrain.colors(30, alpha = 1)),
	colorkey=FALSE)

# Plot, remove legend and plot border
spplot(xidw.sub, col.regions=rev(terrain.colors(30, alpha = 1)),
	colorkey=FALSE, par.settings=list(axis.line=list(col=NA)))

# Save plot
#dev.new(width=0.3,height=0.3)
par(mar=c(0.01,0.01,0.01,0.01))
png(filename="D:/work_big_current/blog/raster_plot_margins/data/output3.png", bg="gray")
#par(mar=c(0.01,0.01,0.01,0.01))
#par(mar = c(0,0,0,0))
#plot.window(c(0,1),c(0,1), xaxs = "i", yaxs = "i")
spplot(xidw.sub, col.regions=rev(terrain.colors(30, alpha = 1)),
	colorkey=FALSE, par.settings=list(axis.line=list(col=NA)))
dev.off();



png("D:/work_big_current/blog/raster_plot_margins/data/test.png")
image(xidw.sub, axes = FALSE)
dev.off()


# grid.newpage() 
grid.raster(xidw.sub, interpolate=FALSE) 

png("D:/work_big_current/blog/raster_plot_margins/data/test2.png", 3, 3) 
grid.raster(im, interpolate=FALSE) 
dev.off() 



png(file = "D:/work_big_current/blog/raster_plot_margins/data/test3.png", bg = "red")
par(mar=c(0,0,0,0))
plot(xidw.sub, legend=FALSE)
# spplot(xidw.sub, col.regions=rev(terrain.colors(30, alpha = 1)),
# 	colorkey=FALSE, par.settings=list(axis.line=list(col=NA)))
#plot(1:10)
#rect(1, 5, 3, 7, col = "white")
dev.off()




xidw.sub<-crop(xidw, extent(state))
xidw.sub<-mask(xidw.sub, state)




# This works!
png("D:/work_big_current/blog/raster_plot_margins/data/test_good.png", w=1420, h=1110, bg="transparent")
par(mar = c(0,0,0,0))
#require(grDevices) # for colours
#x <- y <- seq(-4*pi, 4*pi, len=27)
#r <- sqrt(outer(x^2, y^2, "+"))
#image(z = z <- cos(r^2)*exp(-r/6), col=gray((0:32)/32),axes = FALSE)
image(xidw.sub, axes=FALSE, col = rev(terrain.colors(40)))
dev.off()





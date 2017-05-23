library(foreign)
library(raster)
library(rgdal)
library(ggplot2)
library(grid)




xidw<-raster("D:/work_big_current/blog/raster_plot_margins/data/R_Export/test.tiff")
state<-readOGR(dsn="D:/work_big_current/blog/raster_plot_margins/data/R_Export/akarcay.shp", layer="akarcay") 
	
crs(xidw) <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs" 

xidw.sub <- crop(xidw, extent(state))
xidw.sub <- mask(xidw.sub, state)

yidw <- projectRaster(xidw.sub, crs='+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs')


#yidw.sub <- mask(yidw, state)

spplot(yidw)


#plot(xidw.sub)
#spplot(xidw.sub, col.regions=rev(gray(seq(0,1,.01))))
#spplot(xidw.sub, col.regions=topo.colors(50))
#spplot(xidw.sub, col.regions=rev(heat.colors(20)))
spplot(xidw.sub, col.regions=rev(terrain.colors(40, alpha = 1)))





e<-extent(30, 31.65, 38.065, 39.125)
tt <- crop(xidw.sub,e)
spplot(tt, bty="n")

plot(yidw), xaxs="i", yaxs="i")





map.p <- rasterToPoints(yidw)
df <- data.frame(map.p)
#Make appropriate column headings
colnames(df) <- c("Longitude", "Latitude", "MAP")


ggplot(data=df, aes(y=Latitude, x=Longitude)) +
	geom_raster(aes(fill=MAP)) +
	#geom_point(data=sites, aes(x=x, y=y), color="white", size=3, shape=4) +
	theme_bw() +
	coord_equal() +
	#scale_fill_gradient("MAP (mm/yr)", limits=c(0,2500)) +
	theme(plot.margin=unit(c(0,0,0,0),"mm"))
	scale_fill_gradient("MAP (mm/yr)") +
	theme(axis.title.x = element_text(size=16),
		axis.title.y = element_text(size=16, angle=90),
		axis.text.x = element_text(size=14),
		axis.text.y = element_text(size=14),
		panel.grid.major = element_blank(),
		panel.grid.minor = element_blank(),
		legend.position = "right",
		legend.key = element_blank()
	)




png(filename="D:/work_big_current/blog/raster_plot_margins/data/output.png", width=800, height=500, bg="transparent")
plot(yidw, axes = F, box = F, legend = F)
dev.off();

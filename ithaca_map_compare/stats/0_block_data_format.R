library(foreign)

mydata<-read.csv("D:/work_big_current/blog/ithaca_map_compare/data/block_tompkins_cnty_housing.csv", as.is=T)



mydata[,c("STATE", "COUNTY", "TRACT", "BLKGRP", "BLOCK")]<-
    apply(mydata[,c("STATE", "COUNTY", "TRACT", "BLKGRP", "BLOCK")], 2,
          function(x) as.character(as.numeric(x)))

unique(nchar(mydata$STATE))

unique(nchar(mydata$COUNTY))
#mydata$COUNTY[nchar(mydata$COUNTY) == 1]<-paste("00", mydata$COUNTY[nchar(mydata$COUNTY) == 1], sep="")
#mydata$COUNTY[nchar(mydata$COUNTY) == 2]<-paste("0", mydata$COUNTY[nchar(mydata$COUNTY) == 2], sep="")


unique(nchar(mydata$TRACT))
mydata$TRACT[nchar(mydata$TRACT) == 3]<-paste("000", mydata$TRACT[nchar(mydata$TRACT) == 3], sep="")
mydata$TRACT[nchar(mydata$TRACT) == 4]<-paste("00", mydata$TRACT[nchar(mydata$TRACT) == 4], sep="")
#mydata$TRACT[nchar(mydata$TRACT) == 5]<-paste("0", mydata$TRACT[nchar(mydata$TRACT) == 5], sep="")


unique(nchar(mydata$BLKGRP)) #---- we don't need this b/c it's included in "BLOCK" (first digit)

unique(nchar(mydata$BLOCK))
mydata$BLOCK[nchar(mydata$BLOCK) == 1]<-paste("000", mydata$BLOCK[nchar(mydata$BLOCK) == 1], sep="")
mydata$BLOCK[nchar(mydata$BLOCK) == 2]<-paste("00", mydata$BLOCK[nchar(mydata$BLOCK) == 2], sep="")


mydata$FIPS<-paste(mydata$STATE, mydata$COUNTY, mydata$TRACT, mydata$BLOCK, sep="")

head(mydata)





mydata$pct_OO<-mydata$H0160002/mydata$H0160001
mydata$pct_RO<-mydata$H0160010/mydata$H0160001


mydata<-mydata[,c("FIPS", "pct_OO", "pct_RO", "H0160001")]
#mydata$H0160001[mydata$H0160001 == 0]<-NA

write.dbf(mydata, "D:/work_big_current/blog/ithaca_map_compare/gis/data/block_tompkins_housing.dbf")

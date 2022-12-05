library(leaflet)
library(rgdal)
library(sf)
library(tmap)
library(sp)
library(RColorBrewer)
library(dplyr)
library(ggplot2)
library(rjson)
library(jsonlite)
library(leaflet.extras)
library(RCurl)
library(htmltools)
library(htmlwidgets)
library(leafletCN)
library(raster)

gw_2013 <- readOGR("2013_Water_Level.geojson")
gw_PreDev <- readOGR("pre_dev_wl.geojson")
gw_2000 <- readOGR("2000_Water_Level.geojson")
gw_1980 <- readOGR("1980_Water_Level.geojson")
gw_decline <- raster("aquifer_decline1.tif")


gw_bound <- st_read("D:/Web_GIS/Web Map Tutorial/Tutorial/ogallala_boundary.geojson")

#set color ramp
gw_bins <- c(0, 100, 200, 300, 400, 500, 600
)
gw_pal_2013 <- colorBin("Blues",
  domain = gw_2013$lev_va_ft,
  bins = gw_bins
)
gw_pal_PreDev <- colorBin("Blues", 
  domain = gw_PreDev$lev_va_ft,
  bins = gw_bins
)
gw_pal_2000 <- colorBin("Blues",
  domain = gw_2000$lev_va_ft,
  bins = gw_bins
)
gw_pal_1980 <- colorBin("Blues",
  domain = gw_1980$lev_va_ft,
  bins = gw_bins
)


ras_bin <- c(100, 0, -100, -200, -300)
pal_ras <- colorBin("RdYlBu", values(gw_decline), na.color = "transparent")


gw_2013$popup1 <- paste("<b>", "Site Name:", "</b>",
                      "</br>",gw_2013$site_name,
                      "</br>", "<b>", "Water Level in Feet:", "</b>", 
                      "</br>", gw_2013$lev_va_ft, 
                      "</br>", "<b>", "Well Depth in Feet:", "</b> ",
                      "</br>",gw_2013$well_depth
                      )

gw_PreDev$popup2 <- paste("<strong>","Site Name:", "</strong>",
                       "</br>",gw_PreDev$site_name,
                       "</br>", "<strong>","Water Level in Feet:", "</strong>",
                       "</br>",gw_PreDev$lev_va_ft, 
                       "</br>", "<strong>","Well Depth in Feet:", "</strong>",
                       "</br>", gw_PreDev$well_depth
                       )

gw_2000$popup3 <- paste("<strong>","Site Name:", "</strong>",
                        "</br>",gw_2000$site_name,
                        "</br>", "<strong>","Water Level in Feet:", "</strong>",
                        "</br>",gw_2000$lev_va_ft, 
                        "</br>", "<strong>","Well Depth in Feet:", "</strong>",
                        "</br>", gw_2000$well_depth
                        )
gw_1980$popup4 <- paste("<strong>","Site Name:", "</strong>",
                        "</br>",gw_1980$site_name,
                        "</br>", "<strong>","Water Level in Feet:", "</strong>",
                        "</br>",gw_1980$lev_va_ft, 
                        "</br>", "<strong>","Well Depth in Feet:", "</strong>",
                        "</br>", gw_1980$well_depth
                        )

webmap <- leaflet() %>%
  addProviderTiles(providers$OpenStreetMap
          ) %>%
  addCircleMarkers(data = gw_2013,
              stroke = TRUE,
              weight = 0.15,
              color = "Blue",
              radius = 3,
              opacity = 1,
              fillColor = ~gw_pal_2013(lev_va_ft),
              fillOpacity = 0.9,
              popup = ~popup1,
              group = "Water Level 2013"
          ) %>%
  addCircleMarkers(data = gw_2000,
                   stroke = TRUE,
                   weight = 0.15,
                   color = "Blue",
                   radius = 3,
                   opacity = 1,
                   fillColor = ~gw_pal_2000(lev_va_ft),
                   fillOpacity = 0.9,
                   popup = ~popup3,
                   group = "Water Level 2000"
          ) %>%
  addCircleMarkers(data = gw_1980,
                   stroke = TRUE,
                   weight = 0.15,
                   color = "Blue",
                   radius = 3,
                   opacity = 1,
                   fillColor = ~gw_pal_1980(lev_va_ft),
                   fillOpacity = 0.9,
                   popup = ~popup4,
                   group = "Water Level 1980"
         ) %>%
  addCircleMarkers(data = gw_PreDev,
              stroke = TRUE,
              weight = 0.15,
              color = "Blue",
              radius = 3,
              opacity = 1,
              fillColor = ~gw_pal_PreDev(lev_va_ft),
              fillOpacity = 0.9,
              popup = ~popup2,
              group = "Water Level Pre Development"
          ) %>%
  addPolygons(data = gw_bound,
              stroke = TRUE,
              weight = 1,
              color = "Black",
              opacity = 1,
              fillOpacity = 0,
              options = pathOptions(clickable = FALSE)
          ) %>%
  addLegend("bottomright", pal = gw_pal, values = gw_2013$lev_va_ft,
        title = "Groundwater Depth Feet",
        labFormat = labelFormat(suffix = " ft"),
        opacity = 1
        ) %>%
  addLayersControl(
    baseGroups = c("Water Level 2013", "Water Level 2000", 'Water Level 1980', "Water Level Pre Development"),
    options = layersControlOptions(collapsed = TRUE)
  )
  
webmap

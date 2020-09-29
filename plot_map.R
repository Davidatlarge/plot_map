plot_map <- function(
    lats, # latitude of data
    lons, # longitude of data
    lon.min = NULL,
    lon.max = NULL,
    lat.min = NULL,
    lat.max = NULL,
    values = NULL, # data values
    value.name = NULL, # name for the data legend    
    bathymetry = FALSE, # can be logical (i.e. should a bathymetry be plotted) or the name of an object of class bathy
    keep = FALSE # keep downloaded bathymetry? only relevant with bathymetry=TRUE
) {
    suppressWarnings(library(mapdata, quietly = TRUE))
    suppressWarnings(library(ggplot2, quietly = TRUE))
    
    # define box
    latextra <- abs(diff(range(lats)))/10
    lonextra <- abs(diff(range(lons)))/10
    if(latextra == 0) {latextra <- lonextra}
    if(lonextra == 0) {lonextra <- latextra}
    if(lonextra == 0 && latextra == 0) {lonextra <- 1
    latextra <- 1}
    if(is.null(lon.min)) {lon.min <- min(lons, na.rm = TRUE)-lonextra}
    if(is.null(lon.max)) {lon.max <- max(lons, na.rm = TRUE)+lonextra}
    if(is.null(lat.min)) {lat.min <- min(lats, na.rm = TRUE)-latextra}
    if(is.null(lat.max)) {lat.max <- max(lats, na.rm = TRUE)+latextra}
    
    # get data for bathymetry if requested
    if(is.logical(bathymetry) && bathymetry == TRUE){
        bath <- marmap::getNOAA.bathy(lon1 = lon.min, lon2 = lon.max, lat1 = lat.min, lat2 = lat.max, resolution = 1, keep = keep)
        bath <- fortify(bath) # make a df out of bathy so ggplot can fully use the data
    }
    # use bathymetry data if supplied
    if(class(bathymetry)=="bathy"){
        bath <- fortify(bathymetry) # make a df out of bathy so ggplot can fully use the data
    }
    # print warning if bathymetry has been supplied wrong
    if(class(bathymetry)!="bathy" && !is.logical(bathymetry)){
        warning("error in argument 'bathymetry'; must be logical or of class 'bathy'")
    }
    
    # get data for land map
    landmap <- map_data('worldHires')
    # reduce the size of the map data for faster plotting. this does not simply remove values outside the lon/lat ranges because that would cut the polygons and mess with the plotting
    regions <- unique(landmap[landmap$long>=lon.min & landmap$long<=lon.max & # find the regions included in the lon/lat ranges
                                  landmap$lat>=lat.min & landmap$lat<=lat.max,]$region)
    landmap <- landmap[landmap$region %in% regions,] # reduce landmap to only keep regions included in the lon/lat ranges
    
    # make the basic map plot
    p1 <- ggplot() +
        coord_map(projection = "mercator", xlim = c(lon.min, lon.max), ylim = c(lat.min, lat.max)) +
        scale_x_continuous(expand = c(0, 0), name = "Longitude °E") +
        scale_y_continuous(expand = c(0, 0), name = "Latitude °N") +
        theme_bw()
    
    # add bathymetry if requested or supplied
    if(exists("bath")) {
        p1 <- p1 + 
            geom_contour(data = bath, aes(x = x, y = y, z = z),
                         # breaks = seq(-2000, -200, by = 200), 
                         size = .2, linetype = 2, color = "black") 
    }    
    
    # add data
    p1 <- p1 + 
        geom_point(aes(x = lons, y = lats, color = values)) +
        labs(colour = value.name)
    
    if(is.numeric(values)) {
        p1 <- p1 +
            scale_color_gradientn(colors = c("blue", "green", "orange", "red"))
    }
    
    # add land map
    p1 <- p1 + 
        geom_polygon(data = landmap, 
                     aes(x = long, y = lat, group = group), fill = "seashell4", colour = "grey30", lwd = .5)
    
    return(p1)
}

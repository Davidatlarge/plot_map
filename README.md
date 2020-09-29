plot a surface map for ocean data
================

### Description

This function uses ggplot to make a surface map to visualize ocean
science data. It is **not** suitable for terrestrial data because the
land map is plotted above the data points. Land map data is contained in
the package mapdata. Ocean bathymetry is optionally plotted and data is
retrieved from NOAA with a call to marmap::getNOAA.bathy();
alternatively, bathymetry data can be supplied as an existing object of
class bathy.

### Arguments

*bathymetry = FALSE* – can be logical (i.e. should a bathymetry be
plotted) or the name of an object of class bathy

*keep = FALSE* – keep downloaded bathymetry in the current wd? only
relevant with bathymetry=TRUE

*lon.min, lon.max, lat.min, lat.max* – map limits, if not supplied the
range of lats and lons will be slightly extended

*lats, lons* – latitude and longitude of data

*values* – optional, data values

*value.name* – optional, name for the data legend

### Example

normal plot

``` r
p1 <- plot_map(
    bathymetry = TRUE,
    keep = FALSE,
    lon.min = 112,
    lon.max = 118,
    lat.min = 16,
    lat.max = 24,
    lats = seq(22, 17, length.out = 10),
    lons = seq(114, 116, length.out = 10),
    values = rnorm(10),
    value.name = "example [unit]"
)
```

    ## Registered S3 methods overwritten by 'adehabitatMA':
    ##   method                       from
    ##   print.SpatialPixelsDataFrame sp  
    ##   print.SpatialPixels          sp

    ## Querying NOAA database ...

    ## This may take seconds to minutes, depending on grid size

    ## Building bathy matrix ...

``` r
p1
```

![](README_files/figure-gfm/example-1.png)<!-- -->

bounding box not fully supplied

``` r
p2 <- plot_map(
    lon.min = -59, 
    lat.max = -33,
    lats = seq(-35.5, -37.5, length.out = 10),
    lons = seq(-56.5, -52, length.out = 10),
    values = rnorm(10),
    value.name = "example [unit]"
)
p2
```

![](README_files/figure-gfm/example2-1.png)<!-- -->

because the result is a ggplot, it can be extendend with additional
layers, and the theme can be changed

``` r
p1 +
    annotate("text", x = 115, y = 22, label = "some\ntext", size = 4, fontface = "bold") +
    geom_point(aes(x = c(116, 116.5, 117), y = c(22, 22, 22)), col = "red", size = 4) +
    theme_dark()
```

![](README_files/figure-gfm/example3-1.png)<!-- -->

plot with bathy object supplied

``` r
plot_map(
    bathymetry = marmap::getNOAA.bathy(lon1 = 114, lon2 = 116, lat1 = 18, lat2 = 20, resolution = 1),
    keep = FALSE,
    lon.min = 112,
    lon.max = 118,
    lat.min = 16,
    lat.max = 24,
    lats = seq(22, 17, length.out = 10),
    lons = seq(114, 116, length.out = 10),
    values = rnorm(10),
    value.name = "example [unit]")
```

    ## Querying NOAA database ...

    ## This may take seconds to minutes, depending on grid size

    ## Building bathy matrix ...

![](README_files/figure-gfm/example4-1.png)<!-- -->

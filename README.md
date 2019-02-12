plot a surface map for ocean data
================
David Kaiser
12 February 2019

### Description

This function uses ggplot to make a surface map to visualize ocean science data. It is **not** suitable for terrestrial data because the land map is plotted above the data points. Land map data is contained in the package mapdata. Ocean bathymetry is optionally plotted and data is retrieved from NOAA with a call to marmap::getNOAA.bathy(); alternatively, bathymetry data can be supplied as an existing object of class bathy.

### Arguments

*bathymetry = TRUE* -- can be logical (i.e. should a bathymetry be plotted) or the name of an object of class bathy

*keep = TRUE* -- keep downloaded bathymetry in the current wd? only relevant with bathymetry=TRUE

*lon.min, lon.max, lat.min, lat.max* -- map limits

*lats, lons* -- latitude and longitude of data

*values* -- data values

*value.name* -- name for the data legend

### Example

``` r
plot_map(
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

    ## Querying NOAA database ...
    ## This may take seconds to minutes, depending on grid size
    ## Building bathy matrix ...

![](README_files/figure-markdown_github/example-1.png)
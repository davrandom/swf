library(sf)
library(ggplot2)
library(dplyr)


doSphPlot<-function(data, value, legend_name, what='prova', minv=-2, maxv=2, ticks=0.5, invert=1){
    # Create grid
    grid <- st_sf(st_make_grid(cellsize = c(1,1), offset = c(-180,-90), n = c(360,180),
                              crs = st_crs(4326), what = 'polygons'))

    # dplyr::mutate is the verb to change/add a column
    grid <- grid %>% mutate(valore = value)

    # SPK
    spk_azimuth = c(0.0, 30.0, 90.0, 130.0, 230.0, 270.0, 330.0, 45.0, 135.0, 225.0, 315.0)
    spk_elevation = c(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 45.0, 45.0, 45.0, 45.0)
    spk <- data.frame(spk_azimuth, spk_elevation)
    spk <- st_as_sf(spk, coords = c('spk_azimuth', 'spk_elevation'), crs = 4326)

    # TODO: Build object with coordinates and text labels
    labels <- data.frame(x = c(-90, 0, 90), y = rep(5,3),
                         text = c('left', 'front', 'right'))
    labels <- st_as_sf(labels, coords = c('x','y'), crs = 4326)

    # Plot polygons with color and mollweide projection
    ggplot() +
        geom_sf(data = grid, aes(fill=valore, col = valore)) +

        geom_sf(data=st_graticule(crs = st_crs(4326),
                            lat = seq(-60,60,30),
                            lon = seq(-180, 180, 30)),
                            col = 'white', size = 0.2) +
        geom_sf(data=st_graticule(crs = st_crs(4326),
                            lat = 0,
                            lon = seq(-180, 180, 90)),
                            col = 'white', size = 0.5) +

        geom_sf(data = spk, size = 3) +
        geom_sf_text(data=labels, aes(label = text), col = 'white', nudge_x = 15, nudge_y = 4) +  # nundge doesn't work...

        scale_fill_viridis_c(limits=c(minv, maxv), breaks=seq(minv, maxv,by=ticks), direction=invert) +
        scale_color_viridis_c(limits=c(minv, maxv), breaks=seq(minv, maxv,by=ticks), guide = FALSE, direction=invert) +

        coord_sf(crs = st_crs('ESRI:54009')) +
        labs(fill = legend_name, x = NULL, y = NULL) +
        theme(panel.background = element_blank())

    nome = paste(what, '.png', sep = "", collapse = NULL)
    ggsave(nome, width = 15, units = "cm")
    nome = paste(what, '.pdf', sep = "", collapse = NULL)
    ggsave(nome, width = 15, units = "cm")

}


# Import data
files_list <- c('wv0_interp_704_physics', 'wv1_interp_704_physics', 'ambi2_704_physics', 'ambi3_704_physics', 'vbap_pressure_704_physics')
modes <- c(1, 2, 3)
for(mode in modes)
    {
    for (filename in files_list){
        data_path <- paste(filename, '.txt', sep = "", collapse = NULL)
        data <- read.csv(data_path, header = FALSE)

        invert=1
        if(mode == 1){
        # energy
        what_plot = 'energy_dB'
        legend='E (dB)'
        value <- data$V6
        value = 10*log10(value)
        minv = -2.5  # for Ambi and SWF
        maxv =  2
#         minv = -5  # for vbap
#         maxv =  0
        ticks = 0.5
        print("Doing energy.")
        }

        if(mode == 2){
        # radial intensity
        what_plot = 'intensity_R'
        legend=expression('I'['R'])
        value <- data$V7
        minv = 0 # -0.641548
        maxv = 1 # 0.938332
        ticks = 0.2
        print("Doing intensity R.")
        }

        if(mode == 3){
        # transverse intensity
        what_plot = 'intensity_T'
        legend=expression('I'['T']*' (deg)')
        value <- data$V8
        value = asin(value) / pi * 180
        minv = 0
        maxv = 30 # 90
        ticks = 5
#         minv = 0
#         maxv = 1
#         ticks = 0.2
        print("Doing intensity T.")
        invert=-1
        }

        rootname = strsplit(filename, '_')
        plotname = paste(rootname[[1]][1], what_plot, sep = "_", collapse = NULL)
        print(plotname)
        doSphPlot(data, value, legend, what=plotname, minv=minv, maxv=maxv, ticks=ticks, invert=invert)
    }
}

print("Done.")


# swf
Accessory data for published papers on SWF

Folder:
* jaes_68-9_2020_data: contains data for the paper: "Wavelet-Based Spatial Audio Format", DOI: https://doi.org/10.17743/jaes.2020.0049
* i3da_2021: contains data for the paper: "Subjective Evaluation of the Localization Performance of the Spherical Wavelet Format Compared to Ambisonics"

## The Data and Plots
Each folder contains the data and script to replicate the plots 
(also present in a `plots` subfolder).
The script to generate the plots is an `R` script, 
and is called `make_r_spherical_plots_*.r`, 
with a variable suffix depending on the paper name.

## How to Run the Code
First install R. The code is tested with R 4.1.0, 4.3.2.

Then, install dependencies. From the R console:
```R
install.packages(c('sf', 'ggplot2', 'dplyr'))
```
you might want to specify a custom installing folder
```R
install.packages(c('sf', 'ggplot2', 'dplyr'), lib="/Users/yourname/.Rlibs")
```
These packages require some libraries to be installed. 
The installation will fail and indicate the missing libraries.
Yes, R is a nightmare.

To run the code,
```
R < make_r_spherical_plots.r --vanilla
```

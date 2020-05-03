library(tidyverse)
library(sf)

#Cargo radios y unifico columnas:
radios_caba <- st_read("raw_data/radios_amba_caba/cabaxrdatos.shp")
radios_amba <- st_read("raw_data/radios_amba_caba/Buenos_Aires_con_datos.shp")
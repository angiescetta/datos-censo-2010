library(tidyverse)
library(sf)

#Cargo radios y unifico columnas:

link_amba_caba <- read.csv("raw_data/link_amba_caba.csv")

radios_amba <- st_read("raw_data/Buenos_Aires_con_datos.shp") %>%
  st_transform(crs=4326) %>% #Proyección Mercator
  select(link, varon, mujer, totalpobl, hogares, viviendasp, viv_part_h, geometry) %>%
  mutate(link=as.integer(as.character(link))) %>%
  filter(link%in%link_amba_caba$link) %>% #Me quedo solo con los radios de AMBA (no de todo PBA)
  rename(p_varon=varon,
         p_mujer=mujer,
         p_total=totalpobl,
         h_total=hogares,
         v_part_total=viviendasp, #Viviendas particulares
         v_part_habit=viv_part_h) #Viviendas particulares habitadas

radios_caba <- st_read("raw_data/cabaxrdatos.shp") %>%
  st_transform(crs=4326) %>% #Proyección Mercator
  select(LINK, VARONES, MUJERES, TOT_POB, HOGARES, VIV_PART, VIV_PART_H, geometry) %>%
  mutate(LINK=as.integer(as.character(LINK))) %>%
  rename(link=LINK, #ID de radio
         p_varon=VARONES,
         p_mujer=MUJERES,
         p_total=TOT_POB,
         h_total=HOGARES,
         v_part_total=VIV_PART, #Viviendas particulares
         v_part_habit=VIV_PART_H) #Viviendas particulares habitadas

radios_total <- rbind(radios_amba, radios_caba)

#Población Argentina y Extranjera:
p_segun_origen <- read.csv("raw_data/p_segun_origen.csv")

radios_total <- radios_total %>%
  left_join(p_segun_origen, by="link")
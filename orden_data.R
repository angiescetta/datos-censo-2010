library(tidyverse)
library(sf)

#Cargo radios y unifico columnas:

link_amba_caba <- read.csv("raw_data/link_amba_caba.csv")

radios_amba <- st_read("raw_data/Buenos_Aires_con_datos.shp") %>%
  st_transform(crs=4326) %>% #Proyección Mercator
  mutate(link=as.integer(as.character(link)),
         area="AMBA") %>%
  select(link, area, varon, mujer, totalpobl, hogares, viviendasp, viv_part_h, geometry) %>%
  filter(link%in%link_amba_caba$link) %>% #Me quedo solo con los radios de AMBA (no de todo PBA)
  rename(p_varon=varon,
         p_mujer=mujer,
         p_total=totalpobl,
         h_total=hogares,
         v_part_total=viviendasp, #Viviendas particulares
         v_part_habit=viv_part_h) #Viviendas particulares habitadas

radios_caba <- st_read("raw_data/cabaxrdatos.shp") %>%
  st_transform(crs=4326) %>% #Proyección Mercator
  mutate(link=as.integer(as.character(LINK)),
         area="CABA") %>%
  select(link, area, VARONES, MUJERES, TOT_POB, HOGARES, VIV_PART, VIV_PART_H, geometry) %>%
  rename(p_varon=VARONES,
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

#Población segun grupo de edad:
p_grupo_edad <- read.csv("raw_data/p_grupo_edad.csv")

radios_total <- radios_total %>%
  left_join(p_grupo_edad, by="link")

#Población según condición de actividad:
p_cond_actividad <- read.csv("raw_data/p_cond_actividad.csv")

radios_total <- radios_total %>%
  left_join(p_cond_actividad, by="link")

#Población analfabeta:
p_analfabetismo <- read.csv("raw_data/p_analfabetismo.csv")

radios_total <- radios_total %>%
  left_join(p_analfabetismo, by="link")

#Hogares con NBI:
h_nbi <- read.csv("raw_data/h_nbi.csv")

radios_total <- radios_total %>%
  left_join(h_nbi, by="link")

#Hogares con Hacinamiento (3 o más personas por cuarto):
h_hacinamiento <- read.csv("raw_data/h_hacinamiento.csv")

radios_total <- radios_total %>%
  left_join(h_hacinamiento, by="link")

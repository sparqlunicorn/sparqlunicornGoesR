library(WikidataQueryServiceR)

# all stones in wikidata and their location

sparql_query <- 'SELECT ?label ?item ?geo  WHERE {
  ?item wdt:P31 wd:Q2016147;
   wdt:P361 wd:Q70873595.
  OPTIONAL {
    ?item rdfs:label ?label.
    FILTER((LANG(?label)) = "en")
  }
  ?item wdt:P625 ?geo.
  OPTIONAL { ?item wdt:P17 ?countryWD. ?countryWD rdfs:label ?country. FILTER((LANG(?country)) = "en")}
}
ORDER BY (?label)' 


ogi_ort  <- query_wikidata(sparql_query, "simple")
View(ogi_ort)

#check for double entries

isUnique <- function(vector){
  return(!any(duplicated(vector)))
}


# isUnique(ogi_ort$label) not unique

double <- ogi_ort$label[duplicated(ogi_ort$label)]
# duplication is because of different writings of inscription, so for this analysis not important

# distinct keeps the first of the double entries of label, option .kep_all is used to keep all variables in the data.

ogi_ort %>% distinct(label, .keep_all = TRUE) -> ogi_ort2



## try a different distance analysis: percolation

# 1. split column with point information into x and y, remove "point()" and make as numeric
#gsub ("the part you want to remove", "the part you want to have instead", data, fixed = TRUE if not regex)

library(tidyr)

ogi_ort2 %>% separate(geo, sep = " ", into = c("Easting", "Northing")) -> ogi_ort_pt
ogi_ort_pt$Easting <- as.numeric(as.character(gsub("Point(", "", ogi_ort_pt$Easting, fixed = TRUE)))
ogi_ort_pt$Northing <- as.numeric(as.character(gsub(")", "", ogi_ort_pt$Northing, fixed = TRUE)))

# 2. keep only locational info
ogi_pt <- ogi_ort_pt[, c(1,3:4)]

names(ogi_pt)[1] <- "PlcIndex"
ogi_pt$PlcIndex <-gsub("a", "4", ogi_pt$PlcIndex, fixed = TRUE)
ogi_pt$PlcIndex <-gsub("b", "8", ogi_pt$PlcIndex, fixed = TRUE)


# transform WGS and project on UTM 29 /Ireland
library(rgdal)

coordinates(ogi_pt) <- c("Easting", "Northing")
proj4string(ogi_pt) <- CRS("+proj=longlat +datum=WGS84") 

ogi_pt <- spTransform(ogi_pt, CRS("+proj=utm +zone=29N ellps=WGS84"))

ogi_pt <- as.data.frame(ogi_pt)

# rename label

ogi_pt$PlcIndex <- as.numeric(as.character(gsub("CIIC", "", ogi_pt$PlcIndex, fixed = TRUE)))

library(percopackage)

percolate(ogi_pt, upper_radius = 50, lower_radius = 5, step_value = 5, limit = 60, radius_unit = 1000)

plotClustFreq(source_file_name = "CIIC Ogham Stones")  
library(WikidataQueryServiceR)

# all stones in wikidata and their location

sparql_query <- 'SELECT ?label ?item ?geo ?country ?local ?admin_bound ?mat WHERE {
  ?item wdt:P31 wd:Q2016147;
   wdt:P361 wd:Q70873595.
  OPTIONAL {
    ?item rdfs:label ?label.
    FILTER((LANG(?label)) = "en")
  }
  ?item wdt:P625 ?geo.
  OPTIONAL { ?item wdt:P17 ?countryWD. ?countryWD rdfs:label ?country. FILTER((LANG(?country)) = "en")}
  OPTIONAL { ?item wdt:P189 ?location. ?location wdt:P31 wd:Q72617071. ?location rdfs:label ?local. FILTER((LANG(?local)) = "en")}
  OPTIONAL { ?item wdt:P189 ?admin. ?admin wdt:P31 ?admintype. FILTER (?admintype IN (wd:Q179872,wd:Q17364572,wd:Q1317848)) ?admin rdfs:label ?admin_bound. FILTER((LANG(?admin_bound)) = "en")}
  OPTIONAL { ?item wdt:P186 ?material. ?material rdfs:label ?mat. FILTER((LANG(?mat)) = "en")}
}
ORDER BY (?label)' 

ogi_ort  <- query_wikidata(sparql_query, "simple")
View(ogi_ort)

isUnique(ogi_ort$label)

double <- ogi_ort$label[duplicated(ogi_ort$label)]
# duplication is because of different writings of inscription, so for this analysis not important

# distinct keeps the first of the double entries of label, option .kep_all is used to keep all variables in the data.

ogi_ort %>% distinct(label, .keep_all = TRUE) -> ogi_ort2

library(ggplot2)
library(tidyverse)

# look at material (not too many infos yet):
ogi_ort2 %>%
  filter(mat != is.na(mat)) %>%
  group_by(mat) %>%
  summarize(Count = n()) -> ogi_mat


ggplot()+
  geom_col(data = ogi_mat, aes(x = (reorder(mat, Count)), y = Count))
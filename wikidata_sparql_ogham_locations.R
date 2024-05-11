library(WikidataQueryServiceR)

# all stones in wikidata and their location

sparql_query <- 'SELECT ?label ?item ?geo ?country ?local ?admin_bound WHERE {
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
}
ORDER BY (?label)' 

ogi_ort  <- query_wikidata(sparql_query, "simple")

View(ogi_ort)

isUnique(ogi_ort$label)

# some stones are double, therefore keep only one of the doubled ones: 

ogi_ort %>% distinct(label, .keep_all = TRUE) -> ogi_ort2


library(ggplot2)
library(tidyverse)

# look at counties:

ogi_ort2 %>%
  filter(admin_bound != is.na(admin_bound)) %>% #remove NAs
  group_by(admin_bound) %>%
  summarize(Count = n()) -> ogi_admin  


ggplot()+
  geom_col(data = ogi_admin, aes(x = reorder(admin_bound, Count), y = Count))+
  theme(axis.text.x = element_text(angle = 45))

# filter for most commen counties

ogi_admin %>%
  filter(Count > 2) %>%
  ggplot(.) + 
  geom_col(aes(x = reorder(admin_bound, Count), y = Count))+
  theme(axis.text.x = element_text(angle = 45))

# look at townlands: 

ogi_ort2 %>%
  filter(local != is.na(local)) %>% #remove NAs
  group_by(local) %>%
  summarize(Count = n()) -> ogi_local

# filter for most commen townlands
ogi_local %>%
  filter(Count > 2) %>%
  ggplot(.) + 
  geom_col(aes(x = reorder(local, Count), y = Count))+
  labs(x = "Townlands")+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "white"))+
  theme(axis.text.x = element_text(angle = 45, 
                                   hjust = 0.76))

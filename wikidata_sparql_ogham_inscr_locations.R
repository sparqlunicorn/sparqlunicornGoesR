library(WikidataQueryServiceR)

# all stones in wikidata and their location

sparql_query <- 'SELECT ?label ?item ?geo ?country ?inscription ?local ?admin_bound ?mat WHERE {
  ?item wdt:P31 wd:Q2016147;
   wdt:P361 wd:Q70873595.
  OPTIONAL {
    ?item rdfs:label ?label.
    FILTER((LANG(?label)) = "en")
  }
  ?item wdt:P625 ?geo.
  OPTIONAL { ?item wdt:P17 ?countryWD. ?countryWD rdfs:label ?country. FILTER((LANG(?country)) = "en")}
  OPTIONAL { ?item wdt:P1684 ?inscription. }
  OPTIONAL { ?item wdt:P189 ?location. ?location wdt:P31 wd:Q72617071. ?location rdfs:label ?local. FILTER((LANG(?local)) = "en")}
  OPTIONAL { ?item wdt:P189 ?admin. ?admin wdt:P31 ?admintype. FILTER (?admintype IN (wd:Q179872,wd:Q17364572,wd:Q1317848)) ?admin rdfs:label ?admin_bound. FILTER((LANG(?admin_bound)) = "en")}
  OPTIONAL { ?item wdt:P186 ?material. ?material rdfs:label ?mat. FILTER((LANG(?mat)) = "en")}
}
ORDER BY (?label)' 


ogi_ort  <- query_wikidata(sparql_query, "simple")
View(ogi_ort)

library(ggplot2)
library(tidyverse)

# look at material:
ogi_ort %>%
  filter(mat != is.na(mat)) -> ogi_mat

  ggplot()+
  geom_bar(data = ogi_mat, aes(x = mat))

# look at most common locations:
  
table(ogi_ort$local)-> tab_loc

ogi_ort %>%
  group_by(local) %>%
  summarise(Count = n())%>%
  filter(Count > 10) -> tab_loc2

  
  
  
# the stones in wikidata that are also linked to formula words

sparql_query <- 'SELECT ?label ?item ?geo ?country ?inscription ?local ?mat ?inscriptionmentionsLabel WHERE {
  ?item wdt:P31 wd:Q2016147;
   wdt:P361 wd:Q70873595;
   wdt:P6568 ?inscriptionmentions.

  OPTIONAL {
    ?item rdfs:label ?label.
    FILTER((LANG(?label)) = "en")
  }
  ?item wdt:P625 ?geo.
  OPTIONAL { ?item wdt:P17 ?countryWD. ?countryWD rdfs:label ?country. FILTER((LANG(?country)) = "en")}
  OPTIONAL { ?item wdt:P1684 ?inscription. }
  OPTIONAL { ?item wdt:P189 ?location. ?location rdfs:label ?local. FILTER((LANG(?local)) = "en")}
  OPTIONAL { ?item wdt:P186 ?material. ?material rdfs:label ?mat. FILTER((LANG(?mat)) = "en")}
  OPTIONAL {
  ?inscriptionmentions rdfs:label ?inscriptionmentionsLabel.
  FILTER((LANG(?inscriptionmentionsLabel)) = "en")
}
}
ORDER BY (?label)' 

ogi_inscr  <- query_wikidata(sparql_query, "simple")
View(ogi)
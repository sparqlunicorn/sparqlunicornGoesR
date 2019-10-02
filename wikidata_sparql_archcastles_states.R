#install.packages("WikidataQueryServiceR")
library(WikidataQueryServiceR)

# query Wikidata SPARQL endpoint
# https://w.wiki/9Ew
sparql_query <- '# European castles which are archaeological sites
SELECT ?label ?coord ?subj ?image ?state ?stateLabel WHERE {
  ?subj wdt:P31 wd:Q839954;
    (wdt:P31/(wdt:P279*)) wd:Q23413;
    wdt:P625 ?coord;
    wdt:P18 ?image;
    wdt:P17 ?state.
  ?state wdt:P30 wd:Q46.
  SERVICE wikibase:label {
    bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en".
    ?subj rdfs:label ?label.
  }
  ?state rdfs:label ?stateLabel.
  FILTER((LANG(?stateLabel)) = "en")
}'

df <- query_wikidata(sparql_query, "simple")
df2 <- as.data.frame(df)
#View(df2)

library(ggplot2)

ggplot()+
  geom_bar(data = df2, aes(x = stateLabel, fill = stateLabel))+
  labs(y = "count",
       fill = "state")+
  theme_dark()
#install.packages("WikidataQueryServiceR")
library(WikidataQueryServiceR)

# query Wikidata SPARQL endpoint
# https://w.wiki/9EA
sparql_query <- 'SELECT * WHERE {
  ?item wdt:P31 wd:Q2016147;
    wdt:P361 wd:Q67978809;
    wdt:P17 ?state.
  OPTIONAL {
    ?item rdfs:label ?label.
    FILTER((LANG(?label)) = "en")
  }
  OPTIONAL {
    ?state rdfs:label ?stateLabel.
    FILTER((LANG(?stateLabel)) = "en")
  }
}
ORDER BY (?label)'

df <- query_wikidata(sparql_query, "simple") # from the query_wikidata help: "simple" uses CSV and returns pure character data frame

library(ggplot2)

ggplot()+
  geom_bar(data = df, aes(x = stateLabel, fill = stateLabel))+
  labs(y = "count", x = "",
       fill = "states")+
  theme_dark()

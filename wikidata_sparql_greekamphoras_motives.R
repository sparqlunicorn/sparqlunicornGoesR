#install.packages("WikidataQueryServiceR")
library(WikidataQueryServiceR)

# query Wikidata SPARQL endpoint
# https://w.wiki/9Er
sparql_query <- 'SELECT ?item ?itemLabel ?motive ?motiveLabel ?pic WHERE {
  VALUES ?objects {
    wd:Q41971267
  }
  ?item wdt:P31 ?objects;
    wdt:P180 ?motive;
    wdt:P18 ?pic.
  ?motive rdfs:label ?motiveLabel.
  FILTER((LANG(?motiveLabel)) = "en")
  ?item rdfs:label ?itemLabel.
  FILTER((LANG(?itemLabel)) = "en")
  FILTER((((STRSTARTS(?motiveLabel, "a")) || (STRSTARTS(?motiveLabel, "A"))) || (STRSTARTS(?motiveLabel, "c"))) || (STRSTARTS(?motiveLabel, "C")))
}
ORDER BY (?motiveLabel)'

df <- query_wikidata(sparql_query, "simple")
#View(df)

library(ggplot2)

ggplot()+
  geom_bar(data = df, aes(x = motiveLabel, fill = motiveLabel))+
  labs(y = "count",
       fill = "motive")+
  theme_dark()
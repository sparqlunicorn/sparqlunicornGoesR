#install.packages("WikidataQueryServiceR")
library(WikidataQueryServiceR)

# query Wikidata SPARQL endpoint
# https://w.wiki/9E8
sparql_query <- 'SELECT * WHERE {
  ?item wdt:P31 wd:Q2016147;
    wdt:P361 wd:Q67978809;
    wdt:P6568 ?inscriptionmentions.
  FILTER(?inscriptionmentions != wd:Q67381377)
  FILTER(?inscriptionmentions != wd:Q67382150)
  OPTIONAL {
    ?item rdfs:label ?label.
    FILTER((LANG(?label)) = "en")
  }
  OPTIONAL {
    ?inscriptionmentions rdfs:label ?inscriptionmentionsLabel.
    FILTER((LANG(?inscriptionmentionsLabel)) = "en")
  }
}
ORDER BY (?label)'
  
  df <- query_wikidata(sparql_query, "simple")
  df2 <- as.data.frame(df)
  #View(df2)
  
  library(ggplot2)
  
  ggplot()+
    geom_bar(data = df2, aes(x = inscriptionmentionsLabel, fill = inscriptionmentionsLabel))+
    labs(y = "count", x = "inscription mentions",
         fill = "mentioned words")+
    theme_dark()
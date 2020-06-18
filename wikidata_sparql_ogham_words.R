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
  
  df <- query_wikidata(sparql_query, "simple") # is already a dataframe
  #View(df)

  # create a more barplot with percentage of mentions on top of actual count of words.  
library(ggplot2)
library(tidyverse)  
  df %>% 
    count(inscriptionmentionsLabel) %>% 
    mutate(perc = n*100 / nrow(df)) -> df2  

ggplot()+
  geom_col(data = df2, aes(x = reorder(inscriptionmentionsLabel, perc), 
                           fill = inscriptionmentionsLabel, 
                           y = n))+
  labs(y = "count", 
       x = "inscription mentions",
       fill = "mentioned words")+
  geom_text(data = df2, 
            aes(x = reorder(inscriptionmentionsLabel, perc), 
                col = inscriptionmentionsLabel, 
                y = n, 
                label = paste(round(perc, 0), "%")), 
            vjust = -0.5, 
            show.legend = FALSE)+
  theme_bw()
    
#install.packages("WikidataQueryServiceR")
library(WikidataQueryServiceR)

# query Wikidata SPARQL endpoint
# https://w.wiki/8uP
sparql_query <- 'SELECT ?item ?itemLabel ?motive ?motiveLabel
WHERE
{
  VALUES ?objects {wd:Q41971267}
?item wdt:P31 ?objects.
  ?item wdt:P180 ?motive .
SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en" }
} ORDER BY ?motiveLabel'

df <- query_wikidata(sparql_query)
df2 <- as.data.frame(df)
#View(df2)

library(ggplot2)

ggplot()+
  geom_bar(data = df2, aes(x = motiveLabel, fill = motiveLabel))+
  labs(y = "count",
       title = "Archaeological site")+
  theme_dark()
#install.packages("WikidataQueryServiceR")
library(WikidataQueryServiceR)

# query Wikidata SPARQL endpoint
# https://w.wiki/8uQ
sparql_query <- 'SELECT ?item ?itemLabel ?motive ?motiveLabel ?pic
WHERE
{
  VALUES ?objects {wd:Q41971267}
  ?item wdt:P31 ?objects.
  ?item wdt:P180 ?motive .
  ?item wdt:P18 ?pic .
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en" }
} ORDER BY ?motiveLabel'

df <- query_wikidata(sparql_query)
df2 <- as.data.frame(df)
#View(df2)

library(ggplot2)

ggplot()+
  geom_bar(data = df2, aes(x = motiveLabel, fill = motiveLabel))+
  labs(y = "count",
       title = "Greek Amphoras")+
  theme_dark()
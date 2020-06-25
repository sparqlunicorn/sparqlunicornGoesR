library(WikidataQueryServiceR)


# the stones in wikidata that are also linked to formula words (not too many yet)

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
View(ogi_inscr)
# to be continued
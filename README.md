# salud-news-server
The code for the server for managing, collection, and formatting, and storing of news data for the Salud Domain.


# Data Structure
The data structure in the `news` table is as follows:
| Variable | Type | Description | Example |
| -------- | ---- | ------------------ | --- |
| time     | String | time newsapi.ai found the article in UTC timezone | 11:40:00 |
| dataType | String | type of the article (news, blog, or pr) | "news" |
| eventUri | String | event URI to which the article is assigned to (if any) | "eng-2320588" |
| shares | JSON | The shares on various platforms | {"facebook": 1, "pinterest:" 2} |
| location | JSON | was there explicit location extracted from dateline? | {"label": {"eng": "Boston"}, "type": "place",  {"country": {"label": {"eng": "United States"}, "type": "country"} |
| wgt | Int | parameter used internally for sorting purposes (DO NOT USE THE VALUE) | 12341243 |
| isDuplicate | Bool | is article a duplicate of another article? | false |
| sim | Float | cosine similarity of the article to the centroid of the story | 0.3906 | 
| body | String | article's full body | "As Phil Schiliro arrived at his first meeting last ..."
| image | String | article's image | "https://cdn.arstechnica.net/wp-content/uploads/2013/07/you-slow.jpg" |
| sentiment | Float | sentiment of the article (can be null if value is not set). Between -1 (very negative) and 1 (very positive) | -0.2 |
| date | Date | date newsapi.ai found the article in UTC timezone | 2013-12-18 |
| url | String | web url of the article | "http://www.Newsmax.com/Newsfront/obama-staff-veterans-revamp/2013/12/18/id/542478" |
| uri | String | article's URI (unique article's ID - not necessarily a number) | "143701955" |
| relevance | Int | relevance represents how well does the article match the query - the higher the value, the better the match. If search results are sorted by relevance, this is the value used for sorting | 34 |
| dateTimePub | DateTime | the datetime provided in the RSS feed or in article's metadata. The value chosen is the value closest to the datetime when the article was identified. The value is not monotonically increasing as the articles are added to Event Registry | 2013-12-18T11:12:00Z |
| source | JSON | details about the news source (see Source data model) | {"uri": "boston.com", "dataType": "news", "title": "Boston"} |
| lang | String | language of the article | "eng" |
| title | String | article's title | "Desperate Obama Tries to Reset Agenda with New Staff"
| dateTime | DateTime | datetime when we found and serialized the article in UTC timezone. Each next article added to Event Registry will have a higher value | 2013-12-18T11:40:00Z |
| authors | JSON | list of article's authors | [{"uri": "john_doe@techcrunch.com", "name":"John Doe", "type":"author", "isAgency": false},...] |
| categories | JSON | All categories identified in the article. See the category data model [here](https://www.newsapi.ai/documentation?tab=data_models) | [{"label":{"eng":"Cardiology"},"uri":"http://en.wikipedia.org/wiki/Cardiology","score":5,"type":"wiki"},{"label":{"eng":"Hospital General Universitario Gregorio Marañón"},"uri":"http://en.wikipedia.org/wiki/Hospital_General_Universitario_Gregorio_Marañón","score":4,"type":"wiki"}] |
| originalArticle | JSON | The full entry of the original article (if this article is a duplicate), otherwise NULL | {"sim": 0.8666666746139526, "uri": "8531281299", "url": "https://www.europapress.es/madridnoticia-programa-prevecolon-comunidad-cierra-2024-record-356997-pruebas-deteccion-499-casos-cancer-20250204074732.html", "body": "Puede consultar la ...", "date": "2025-02-04", "lang": "spa", ...} |
| duplicateList | List | List of all articles that are duplicates of this article | ["8531312841", "8531312843"]|
| originalArticleUri | String | The URI of the original article this one is based on. If this is the original, originalArticleUri=uri | "8531312841" |
<!-- 
# Functioning
The endpoint for getting news articles for a particular keyword, date, language, location, ... is live  here `{url_webserver}/news/query`. The `{url_webserver}` can be read on the top right corner of the github repo (is not stable yet, as we might want a dedicated domain).
API docs are here `{url_webserver}/docs`.
There you also find a testing zone for a query.
An example query from the command line is as follows -->

<!-- ```bash
curl -v "https://absolute-newsapi-query-7d1dab937c32.herokuapp.com/news/query?keyword=o2&language=spa&location=Spain&date=y2023m11d01&followingdays=5&maxarticles=3"
``` -->

<!-- Which returns a result like this:

```json
[{"time":"13:08:56","dataType":"news","eventUri":null,"shares":{"facebook":6},"location":{"label":{"eng":"Málaga"},"type":"place","country":{"label":{"eng":"Spain"},"type":"country"}},"wgt":6,"isDuplicate":false,"sim":0,"body":"MÁLAGA, 2 Nov. (EUROPA PRESS) -\n\nEl Área de Deporte del Ayuntamiento de Málaga vuelve a apoyar la actividad '24 horas. Enciende la llama', que organiza la ONG Manos Unidas.\n\nEl concejal delegado de Deporte, Borja Vivas, ha presentado este jueves esta iniciativa que alcanza su undécima edición acompañado por el diputado de Deportes, Juan Rosas, y la presidenta de Manos Unidas en Málaga y Melilla, Ana Torralba.\n\nCon la frase 'Enciende tu compromiso', esta iniciativa de sensibilización se desarrollará con el mismo objetivo que en años anteriores: iluminar virtualmente el mundo para acabar, juntos, con las \"partes ensombrecidas\" que éste tiene, causadas por el hambre, las desigualdades y las injusticias que siguen existiendo hoy en día, y contra las que Manos Unidas lucha desde hace 63 años.\n\nLa acción consiste en el encendido de una vela en cualquiera de 16 centros deportivos de la ciudad que se van a implicar entre el 6 y el 12 de noviembre.\n\nCualquier persona puede sumarse a la XI edición de las '24 horas' de Manos Unidas con su foto para 'Enciende la Llama'. La forma de hacer llegar su foto es subirla directamente, a partir del 3 de noviembre, a la página web de la iniciativa: http://www.manosunidas.org/24horas. A partir del 11 de noviembre las velas se podrán ver en el mapa interactivo.\n\nIgualmente, la página web irá mostrando cómo el mapa del mundo se va iluminando con las fotografías que van llegando desde muchos lugares del planeta, formando parte, un año más, de la seña de identidad de la iniciativa: la acción 'Enciende la llama'.\n\n\"Es una acción sencilla, accesible a todos, que mediante un gesto (la toma de una fotografía con una vela encendida) busca ofrecer a la sociedad la forma de mostrar, de manera activa, su solidaridad con los países del Sur y con las personas que en ellos viven\", han señalado.\n\nLos gimnasios y centros en los que van a estar las '24 horas para iluminar el mundo' son Forus Trinidad, Forus El Torcal, Forus Conde de Guadalhorce, O2 Centro Welness El Perchel, Centro Acuático Inacua, Vals sport Churriana, Vals sport El Cónsul, Vals sport Ciudad Jardín, Vals sport Teatinos, Go Fit Segalerva, Go Fit Huellin, David Lloyd,, Polideportivo Ciudad Jardín, Club Mediterráneo, Pabellón de Deportes de la UMA y Real Club de Golf Guadalhorce.","image":"https://img.europapress.es/fotoweb/fotonoticia_20231102140152_1200.jpg","sentiment":null,"date":"2023-11-02","url":"https://www.europapress.es/andalucia/malaga-00356/noticia-centros-deportivos-malaga-suman-24-horas-enciende-llama-manos-unidas-20231102140152.html","uri":"7814621326","relevance":2,"dateTimePub":"2023-11-02T13:01:52Z","source":{"uri":"europapress.es","dataType":"news","title":"europa press"},"lang":"spa","title":"Centros deportivos de Málaga se suman a 24 horas. Enciende la llama'...","dateTime":"2023-11-02T13:08:56Z","authors":[]}]
```

### Composite keywords

Note: if you use `curl` or an equivalent tool, remember to parse the query url properly. Importantly, if you have a white space in the midst of the keyword string (such as in `"o2 iphone"`), subtistute the white space with `%20` (urls don't cope well with white spaces).
On the other hand, if you use the website interface (the one in `/docs`) to test your queries, the website will take care of that automatically.

## Deployment

The web server is launched from the `Server.jl` script.
The script accepts one input, namely the `PORT` on which to serve.
The variable `PORT` is defined by Heroku.

## API logic

The endpoint are developed in `/src` and included in the `Server.jl`.
Endpoint logic is described as swagger markdown.
**Warning** formatting errors in the docs BREAK the server, so experiment on local first!
Always refer to the [Swagger's OpenAPI documentation](https://swagger.io/docs/specification/).

## Building process

The webserver is built using an ad hoc buildpack for Julia we maintain [here](https://github.com/Baffelan/heroku-buildpack-julia/).
This compiles a sysimage of Julia and the necessary packages so that start up is faster. -->

"""
A function to format the resulting news articles. Takes the vector of dictionaries and converts them into a DataFrame.

# Arguments
- `articles::Dict`: Dictionary from the `query_newsapi` function from `IOM_newsAPI_query`.
"""
function format_result(articles)
    dict_to_df(d) = DataFrame([Symbol(k)=>JSON.json(v) for (k,v) in d]...)

    dfs = dict_to_df.(articles)

    big_df = vcat(dfs...)
    big_df[:, "originalArticleUri"]=[a["originalArticle"]=="null" ? a["uri"] : "\""*JSON.parse(a["originalArticle"])["uri"]*"\"" for a in eachrow(big_df)]
    return big_df
end
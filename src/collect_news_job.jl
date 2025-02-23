"""
Collects and write daily news articles to `storage_address`, based on the user file at `user_address`

# Arguments
- `user_address::String`: Address for the user file.
- `storage_address::String`: Address to write the news articles to.
"""
function collect_news_job(endpoint_dict, read_user_function; write_to_db=true)
    user = read_user_function(endpoint_dict)
    articles = query_newsapi(user, (today()-Day(1), today()), 1000, "Date")
    formatted = format_result(articles)
    if write_to_db
        if typeof(formatted) <: DataFrame
            write_formatted(formatted, endpoint_dict)
        end
    else
        return formatted
    end
end



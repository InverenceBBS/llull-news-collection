using Oxygen
using SwaggerMarkdown
using HTTP
using Dates
# think about adding Umbrella for authentication
#using Umbrella
using IOM_newsAPI_query
using LibPQ
using DataFrames
using JSON
using CSV
using TimeZones

"""
This file is no longer being used. The functionality has bee superceded by `Server.jl`
"""


#  Variable  Type  Description  Example 
#  --------  ----  ------------------  --- 
include("src/news_collection/format_result.jl")
include("src/news_collection/read_user_file.jl")
include("src/news_collection/write_formatted.jl")
include("src/news_collection/db_conn.jl")

include("src/collect_news_job.jl")


endpoint_dict = Dict("keyword"=>"/news_kws", #REPLACE WITH ENV["CONFIG_KEYWORD_TABLE"]
                  "concept"=>"/news_concept",
                  "source"=>"/news_sources",
                  "location"=>"https://en.wikipedia.org/wiki/Spain",
                  "news_db"=>db_conn(),
                  "news_table"=>ENV["NEWS_TABLE"])
collect_news_job(endpoint_dict, read_user_file_location)
collect_news_job(endpoint_dict, read_user_file_sources)


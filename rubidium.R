library(httr)
library(rvest)
library(RSelenium)
library(jsonlite)
library(stringr)

dt <- read_html('https://metal-archives.com/bands/bolt_thrower')

band_info <- dt %>% html_nodes("#band_info, dd")
band_info[[6]] %>% html_text()

# search
name = 'dt'
results <- read_html(paste0("https://metal-archives.com/search?searchString=", name, "&type=band_name"))
results 

json_url <- "https://metal-archives.com/search/ajax-band-search/?field=name&query=dt"
response <- GET(json_url)
http_type(response)
results <- data.frame(fromJSON(content(response, as = 'text'))$aaData)
results$URL <- sapply(results[, 1], function(x) str_match_all(x, "https://(.*?)")[[1]][1, 1])

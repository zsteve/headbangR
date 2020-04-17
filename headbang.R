library(httr)
library(rvest)
library(RSelenium)
library(jsonlite)
library(stringr)
library(lastfmR)

clean <- function(htmlString) {
  return(str_trim(gsub("<.*?>", "", htmlString)))
}


dt <- read_html('https://metal-archives.com/bands/bolt_thrower')

band_info <- dt %>% html_nodes("#band_info, dd")
band_info[[6]] %>% html_text()

# search
name = 'dt'
results <- read_html(paste0("https://metal-archives.com/search?searchString=", name, "&type=band_name"))
results 

search_artist <- function(name){
  name <- str_replace_all(name, " ", "+")
  json_url <- paste0("https://metal-archives.com/search/ajax-band-search/?field=name&query=\"", name, "\"")
  response <- GET(json_url)
  http_type(response)
  results <- data.frame(fromJSON(content(response, as = 'text'))$aaData)
  if(nrow(results) == 0){
    return(NA)
  }
  names(results) <- c("URL", "genre", "country")
  results$name <- clean(results$URL)
  results$URL <- str_remove(str_remove(str_extract(results$URL, "<a href=\".*?\">"), "<a href=\""), "\">")
  return(results)
}

## now try some real shit

x <- get_scrobbles(user = "zstorke")
artist_names <- lapply(x$track.album.artists, function(x) x$name[1])
artist_names <- unique(artist_names)
View(artist_names)

search_artist(artist_names[4])

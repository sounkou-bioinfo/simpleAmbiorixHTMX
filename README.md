# Simple Demo app deploy to shinyapps.io via github actions

This is a hack to deploy `{ambiorix}` apps via shiny servers from https://x.com/ambiorixweb/status/1842509254214697346. Needed to install a previous version of rsconnect for this to work with the custom renv.lock.

## Standard shiny server

A running shiny server where `{ambiorix}` and `{htmltools}` are installed.

## R console shinyapps.io deploy


```{r}
renv::restore()
rsconnect::setAccountInfo(name = Sys.getenv("RS_CONNECT_NAME"),
			  token = Sys.getenv("RS_CONNECT_TOKEN"),
			  secret = Sys.getenv("RS_CONNECT_SECRET")
              )
rsconnect::deployApp(forceUpdate = TRUE)
```

## github actions

There is a github action to deploy this on shinyapps.io
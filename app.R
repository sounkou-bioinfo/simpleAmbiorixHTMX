# simple htmx demo 
# inspired from https://gist.github.com/DavZim/c01511cce2db14efbd12a34c18d3a93d

#  load packages ----


#
home_get <- function(req, res) {
  html <- '
  <!---public/index.html--->
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <script src="https://unpkg.com/htmx.org@1.9.10"></script>
  </head>
  <body>
    <h1>Hello World using Ambiorix and HTMX from R</h1>

    <div style="display:flex;flex-direction: row;align-items: flex-start; gap:20px;">
      <button hx-post="./clicked" hx-swap="innerHTML">
        Click Me
      </button>


      <div>
        <p>The following plot is loaded automagically</p>
        <div
          hx-get="./plot"
          hx-trigger="load"
          style="height:400px;width:400px">
          "Loading plot..."
        </div>
      </div>


      <div>
        <p>The following plot is loaded/updated on button click</p>
        <button
          hx-get="./plot2"
          hx-swap="innerHTML show:top"
          hx-target="#target-plot">
          Update Plot
        </button>
        <div
          id="target-plot"
          style="height:400px;width:400px;background-color:antiquewhite;display:flex;align-items: center;justify-content: center;"></div>
      </div>
    </div>

  </body>
</html>
  '
  res$set_status(200L)$send(html)
}

##
n_clicked <- 0
##

nclicks_get <- function(req, res) {
  n_clicked <<- n_clicked + 1
  res$set_status(200L)$send(
    paste0("Clicked <b>", n_clicked, "</b>\n")
  )
  
    }

plot_get <- function(req, res) {
  png(filename = "plot.png", width = 400, height = 350)
  plot(1:10, cumsum(rnorm(10)))
  dev.off()
  Sys.sleep(1)
  enc <- base64enc::base64encode("plot.png")
  unlink("plot.png")
  res$set_status(200L)$send(
    paste0("<img src='data:image/png;base64,", enc, "' style='height:80%;width:80%'/>")
  )
}



plot2_get <- function(req, res) {
  png(filename = "plot2.png", width = 400, height = 350)
  ir <- iris[sample.int(nrow(iris), 10), ]
  plot(
    x = ir$Petal.Length, 
    y = ir$Petal.Width,
    cex = 3,
    pch = 21,
    main = "Petal Length vs. Petal Width",
  )
  dev.off()
  enc <- base64enc::base64encode("plot2.png")
  unlink("plot2.png")
  res$set_status(200L)$send(
    paste0("<img src='data:image/png;base64,", enc, "' style='height:80%;width:80%'/>")
  )
}


port <- Sys.getenv("SHINY_PORT", 8080L)

ambiorix::Ambiorix$
  new(port = port)$
  get("/", home_get)$
  post("/clicked", nclicks_get)$
  get("/plot2", plot2_get)$
  get("/plot", plot_get)$
  start()

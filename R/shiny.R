#' Shiny app
#' 
#' @description this is a shiny app that loads patent data, views it,
#' and does a simple visualization. 
#' 
#' NOTE: This only works with xlsx files. 
#' 
#' @export

## yang yao start
runExample <- function() {
  appDir <- system.file("shiny", "app" ,package = "patentr")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `patentr`.", call. = FALSE)
  }
  shiny::runApp(appDir, display.mode = "normal")
}
## yang yao end
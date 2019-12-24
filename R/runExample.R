# common way to print error messages
errMsg <- function(x) {
  stop(sprintf("predictit: %s", x), call. = FALSE)
}

#' Run predictit examples
#'
#' Launch a \code{predictit} example Shiny app that shows how to
#' easily use \code{predictit} in an app.\cr\cr
#' Run without any arguments to see a list of available example apps.
#'
#' @param example The app to launch
#' @examples
#' ## Only run this example in interactive R sessions
#' if (interactive()) {
#'   # List all available example apps
#'   runExample()
#'
#'   runExample("demo")
#' }
#' @export
runExample <- function(example) {

  validExamples <-
    paste0(
      'Valid examples are: "',
      paste(list.files(system.file("examples", package = "predictit")),
            collapse = '", "'),
      '"')

  if (missing(example) || !nzchar(example)) {
    message(
      'Please run `runExample()` with a valid example app as an argument.\n',
      validExamples)
    return(invisible(NULL))
  }

  appDir <- system.file("examples", example,
                        package = "predictit")
  if (appDir == "") {
    errMsg(sprintf("could not find example app `%s`\n%s",
                   example, validExamples))
  }

  shiny::runApp(appDir, display.mode = "normal")
}

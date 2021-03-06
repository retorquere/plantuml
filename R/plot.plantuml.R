#' Generate UML graph from plantuml
#'
#' Generate an image containing based ion the plantuml code.
#' TODO can I use vector formats?
#'
#' @param x plantuml code to draw the UML graph
#' @param file
#' - **`file` is `NULL**: the graph is drawn in the graphics device.
#' - **`file` is a file name**: the graph is saved in the file and the type
#'   is based on the extensions.
#'- **`file` is `NULL`**: the data which would have been saved in the file
#'  is returned in a character vector. **This is only useful for text formats
#'  like `eps` or `svg`!**
#'
#' @param plantuml_opt additional options for plantuml in addition to \code{-p}
#'   and \code{-tFILETYPE}. See `plantuml_run() for a list of available file formats.
#' @param vector if \code{TRUE} use `svg` as intermediate format, if \code{FALSE}
#'   use `png`. Only effects plotting in device.
#' @param ... additional arguments for the `plot` function and the `plantuml_run` function.
#'
#' @md
#' @return returns file name (including absolute path) of the created graph.
#'
#' @export
#' @importFrom magrittr %>%
#' @importFrom png readPNG
#' @importFrom grid grid.raster
#' @importFrom grImport PostScriptTrace readPicture picture
#' @importFrom graphics plot
#'
#' @examples
#' plantumlCode <- '
#'  @startuml
#'  (*) --> "First Activity"
#'  -->[You can put also labels] "Second Activity"
#'  --> (*)
#'  @enduml
#' '
#' \dontrun{
#' x <- as.plantuml( plantumlCode )
#' plot( x )
#' plot(as.plantuml(x), java_opt = "-Djava.awt.headless=true")
#' }
plot.plantuml <- function(
  x,
  file = NULL,
  plantuml_opt = "",
  vector = TRUE,
  ...
  ){

  if (!x$complete) {
    x$code <- paste("@startuml \n ", x$code, " \n @enduml")
  }
  if ( is.null(file) ) {
    if (vector) {
      # fn <- tempfile( fileext = ".svg")
      # ffmt <- "-tsvg"
      fn <- tempfile( fileext = ".eps")
      ffmt <- "-teps"
      plantuml_opt = paste("-p", ffmt, plantuml_opt)
    } else {
      fn <- tempfile( fileext = ".png")
      ffmt <- "-tpng"
      plantuml_opt = paste("-p", ffmt, plantuml_opt)
    }
  } else if (file == "") {
    plantuml_opt = paste("-p",plantuml_opt)
  } else {
    fn <- file
    pos <- regexpr("\\.([[:alnum:]]+)$", fn)
    ext <- ifelse( pos > -1L, substring(file, pos + 1L), "")
    ffmt <- paste0("-t", ext)
    plantuml_opt = paste("-p", ffmt, plantuml_opt)
  }

  if (is.null(file)) {
    if (vector) {
      result <- plantuml_run(
        plantuml_opt = plantuml_opt,
        stdout = fn,
        input = x$code
      )
      fnrgl <- gsub(".eps", ".rgml", fn)
      grImport::PostScriptTrace(
        file = fn,
        outfilename = fnrgl
      )
      prgml <- grImport::readPicture(
        rgmlFile = fnrgl
      )
      plot(
        range(prgml@summary@xscale),
        range(prgml@summary@yscale),
        type = "n",
        axes = FALSE,
        xlab = "",
        ylab = "",
        asp = 1
      )
      picture(
        picture = prgml,
        xleft   = prgml@summary@xscale["xmin"],
        xright  = prgml@summary@xscale["xmax"],
        ybottom = prgml@summary@yscale["ymin"],
        ytop    = prgml@summary@yscale["ymax"]
      )
    } else {
      result <- plantuml_run(
        plantuml_opt = plantuml_opt,
        stdout = fn,
        input = x$code
      )
      puml <- png::readPNG(
        fn,
        info = TRUE
      )
      grid::grid.raster(
        puml,
        ...
      )
    }
  } else if (file == "") {
    result <- plantuml_run(
      plantuml_opt = plantuml_opt,
      stdout = TRUE,
      input = x$code
    )
  } else {
    result <- plantuml_run(
      plantuml_opt = plantuml_opt,
      stdout = fn,
      input = x$code
    )
  }
  return(result)
}

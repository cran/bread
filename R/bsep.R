#' Tries to identify the separator / delimiter used in a table format file
#'
#' The function reads the first row and tests the following common separators by default:
#'       \code{';' '\\t' ' ' '|' ':' ','}
#'
#' @param file String. Name or full path to a file compatible with data.table::fread()
#' @param ntries Numeric. Number of rows to check for
#' @param separators Vector of strings. Additional uncommon delimiter to check for
#'
#' @return A string
#'
#' @examples
#' file <- system.file('extdata', 'test.csv', package = 'bread')
#' ## Checking the delimiter on the first 12 rows, including headers
#' bsep(file = file, ntries = 12)
#' @export

bsep <- function(file, ntries = 10, separators = c(';', '\t', ' ', '|', ':', ',')){

  # meta_output <- list()
  # meta_output$colnames <- bcolnames(file)
  if(grepl(pattern = "\\'", file) == T){
    stop("### Can't parse because filename contains the character \" ' \".")
  }

  ## init loop
  ii <- 1

  ## Getting full path, in case the file is in the wd
  file <- normalizePath(path = file)
  if(startsWith(file, "\\")){
    file <- gsub(pattern = "\\\\", replacement = "/", x = file)
  }

  rowz <- system(command = paste0('head -n ', ntries, ' \'', file,'\''), intern = T)

  while(!exists('local_bread_separator')){
    ## if the number of separators is equal in all the rows and not zero
    ## we have found the separator (probably)
    ## here we remove everything but the separator and count what's left
    ## i miss stringr
    count_per_row <- nchar(gsub(paste0('[^', separators[ii],']'),'', x = rowz))
    if(length(unique(count_per_row))==1 & unique(count_per_row)[1]!=0){
      local_bread_separator <- separators[ii]
      break
    } else {
      ii <-  ii + 1
    }
    if(ii > length(separators)){
      stop('*** ERROR: We are having trouble determining the separator,
             please add a sep = "..." argument ***')
    }
  }
return(local_bread_separator)
}

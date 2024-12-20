#' Piecewise mean
#'
#' @description
#' \code{pmean} is to \code{\link[base]{mean}} what
#' \code{\link[base]{pmax}} is to \code{\link[base]{max}}.
#'
#' @param	...    vectors
#' @param	na.rm  a logical indicating whether missing values should be removed
#'
#' @return
#' Return the average of the numbers in the same position
#' across all inputs.
#'
#' @examples
#' pmean(1:10, 5, 11:20)
#' pmean(1:10, 5, c(11:19, NA))
#' pmean(1:10, 5, c(11:19, NA), na.rm = FALSE)
#'
#' @export
pmean <- function(..., na.rm = TRUE) {
  m <- cbind(...)
  apply(m, 1, mean, na.rm = na.rm)
}




#' Quarter name of a date vector, e.g., 2023q2
#'
#' @param	d    a vector of dates
#'
#' @return
#' Year and quarter concatenated delimited by the letter 'q'.
#'
#' @examples
#' quarter_name(as.Date('2022-01-14'))
#' quarter_name(ISOdate(1923, 12, 2))
#'
#' @export
quarter_name <- function(d){
  stopifnot(any(c('Date', 'POSIXct', 'POSIXlt', 'POSIXt') %in% class(d)))
  y <- as.integer(format(d, '%Y'))
  m <- as.integer(format(d, '%m'))
  q <- rep(1:4, each = 3)[m]
  paste(y, q, sep = 'q')
}




#' Get a substring from the left
#'
#' @description
#' Inspired by the Excel function with the same name.
#'
#' @param	string    a vector of strings
#' @param	n         a vector of integers (will be recycled, if needed)
#'
#' @return
#' The first \code{n} characters of each value in \code{string}.
#' If \code{n} has length 1, then that value is applied to all strings
#' because of recycling.
#' However, \code{n} can have more than one element!
#'
#'
#' @examples
#' left('lazy dog', 4)
#' left(c('lazy dog', 'blue dog'), 4)
#' left(c('lazy dog', 'red dog'), c(4, 3))
#'
#' @export
left <- function(string, n) {
  substring(
    text = string,
    first = 1,
    last = n
  )
}




#' Get a substring from the right
#'
#' @description
#' Inspired by the Excel function with the same name.
#'
#' @param	string    a vector of strings
#' @param	n         a vector of integers (will be recycled, if needed)
#'
#' @return
#' The last \code{n} characters of each value in \code{string}.
#' If \code{n} has length 1, then that value is applied to all strings
#' because of recycling.
#' However, \code{n} can have more than one element!
#'
#'
#' @examples
#' right('lazy dog', 3)
#' right(c('lazy dog', 'blue dog'), 3)
#' right(c('lazy dog', 'red frog'), c(3, 4))
#'
#' @export
right <- function(string, n) {

  out.len <- max(length(string), length(n))
  string <- rep(string, length.out = out.len)
  n <- rep(n, length.out = out.len)

  string.nchar <- nchar(string)

  substring(
    text = string,
    first = string.nchar - n + 1,
    last = nchar(string)
  )
}




#' Get a substring from the middle
#'
#' @description
#' Inspired by the Excel function with the same name.
#'
#' @param	string    a vector of strings
#' @param	start     a vector of starting points (will be recycled, if needed)
#' @param	length    a vector of lengths (will be recycled, if needed)
#'
#' @return
#' The \code{length} characters of each value in \code{string}
#' starting with the \code{start} character.
#'
#' @examples
#' mid('lazy dog', 3, 2)
#' mid('lazy dog', 6, 3)
#' mid(c('lazy dog', 'blue dog'), 2, 2)
#' mid(c('lazy dog', 'red frog'), 6, c(3, 2))
#'
#' @export
mid <- function(string, start, length) {
  substring(string, start, start + length - 1)
}




#' Remove leading and trailing whitespace from characters
#'
#' @description
#' Inspired by the Excel function with the same name.
#'
#' @param	x    a vector of strings
#'
#' @return
#' \code{x} without any leading or trailing whitespace.
#'
#' @examples
#' trim('  leading spaces')
#' trim('trailing spaces   ')
#' trim('  leading and trailing spaces   ')
#' trim('\n\r\t Other kinds of whitespace \t\n\r')
#' trim("\n Doesn't affect internal whitespace  ")
#'
#' @export
trim <- function(x) {
  gsub("^(\\s+)|(\\s+)$", "", x);
}




#' Package dev: open a test file
#'
#' @description
#' For use in package development.
#' Open a file in tests/testthat/ for the object called "test"
#' If the file doesn't already exist, create it.
#' If it already exists, open it for editing.
#'
#' @param	test     the object you want to write a test for
#' @param	pkg      to pass for the knitr environment.  Defaults to current working directory
#' @param	engine   if you are using something other than testthat,
#'                   you can save this test to "tests/ENGINE/"
#'
#' @return
#' Returns NULL invisibly.
#' Side-effect: opens the test file in the editor.
#'
#' @examples
#' # open_test(lm)
#'
#' @export
open_test <- function(test, pkg = basename(getwd()), engine = 'testthat') {

  test <- as.character(match.call(expand.dots = FALSE)$test)
  test_file <- paste0('./tests/', engine, '/test_', test, '.R')
  test_dir <- dirname(test_file)

  if (file.exists(test_file)) {
    utils::file.edit(test_file)
    return(invisible(NULL))
  }

  if (!dir.exists(test_dir))
    dir.create(test_dir, recursive = TRUE)

  knit_env <- list(f = test, pkg = pkg)
  RCode <- knitr::knit(text = test_template, envir = knit_env)
  writeChar(RCode, test_file)

  utils::file.edit(test_file)
  return(invisible(NULL))
}




#' Load Rdata to an environment
#'
#' @description
#' Instead of loading RData files to the global environment
#' load them to a new env.
#' \code{base::load} already has a way to do this,
#' but this is a convenience function that creates
#' a new environment by default.
#'
#' @param	RData    path to the RData file you want to load
#' @param	env      the environment you want to load to.  Defaults to a new environment.
#'
#' @return
#' Returns the environment you are loading to.
#'
#' @examples
#' # data_env <- load_env('file1.RData')
#' # load_env('file2.RData', data_env)
#'
#' @export
load_env <- function(RData, env = new.env()){
  base::load(RData, env)
  return(env)
}




#' Source R code to an environment
#'
#' @description
#' Instead of sourcing R code in the global environment
#' where it might create new objects or overwrite existing ones,
#' create a new environment (or use an existing one)
#' and source the code there!
#'
#' @param	RScript  path to the R file you want to run
#' @param	env      the environment you want to run in.  Defaults to a new environment.
#'
#' @return
#' Returns the environment where the processing occurred.
#'
#' @examples
#' # code_env <- source_env('file1.R')
#' # source_env('file2.R', code_env)
#'
#' @export
source_env <- function(RScript, env = new.env()){
  with(env, {
    base::source(RScript, local = TRUE)
    env
  })
}




#' Execute a function in an environment
#'
#' @description
#' Run a function in an environment other than Global.
#' One way to use this is to take other people's code
#' that uses global objects and create wrapper functions
#' where those objects can be passed in.
#'
#' @param	f       the function
#' @param	env     the environment you want to run in
#' @param	...     parameters to the function
#'
#' @return
#' Returns whatever \code{f} is supposed to return.
#'
#' @examples
#' # A function I get from a colleagues code
#' # Imagine it is something you cannot re-write easily
#' bad_func <- function(n) {
#'   set.seed(0)
#'   return(rnorm(n, mean = mu, sd = mu / 2))
#' }
#'
#' mu <- 5
#' bad_func(3)
#'
#' good_func <- function(n, mu) {
#'   temp_env <- new.env()
#'   temp_env$mu <- mu
#'   execute_in(bad_func, temp_env, n = n)
#' }
#'
#' good_func(3, 5)
#' good_func(3, 10)
#'
#' @export
execute_in <- function(f, env, ...) {
  if (!'environment' %in% class(env))
    env <- as.environment(env)
  if (identical(parent.env(env), emptyenv()))
    parent.env(env) <- globalenv()
  gox <- f
  environment(gox) <- env
  gox(...)
}




#' Write the code of a function to a file
#'
#' @param	f       the function
#' @param	file    where to save it
#' @param	name    what name to give the object in the file
#'
#' @return
#' Invisibly returns the contents of the file that was written.
#' The file is a sourceable file.
#' You can use \code{name} to give the object a new name
#' in the file so if you source it, you will not have
#' conflicts.
#'
#' @examples
#' my_func <- function(a, b) {a - b * 2 + a^2}
#' temp_R <- tempfile(fileext = '.R')
#' kode <- write_function(my_func, file = temp_R)
#' print(kode)
#'
#' kode <- write_function(my_func, file = temp_R, name = "diff_name")
#' print(kode)
#'
#' print(readLines(temp_R))
#'
#' @export
write_function <- function(f, file, name = NULL) {
  if (is.null(name)) {
    name <- as.character(match.call(expand.dots = FALSE)$f)
  }
  kode <- deparse(f)
  kode[1] <- paste0(name, ' <- ', kode[1])
  cat(kode, file = file, sep = '\n')
  invisible(kode)
}




#' Write the code of a package to a file
#'
#' @description
#' Uses \code{\link{write_package}} to write
#' every function in a package to a specified directory.
#'
#' @param	pkg       the package of interest
#' @param	folder    the folder where to save the R files
#'
#' @return
#' Nothing
#'
#' @examples
#' # write_package('alrtools', 'some/folder/')
#'
#' @export
write_package <- function(pkg, folder) {
  dir.create(folder, showWarnings = FALSE)
  fs <- ls(getNamespace(pkg), all.names = TRUE)
  for (f in fs) {
    g <- get(f, envir = getNamespace(pkg))
    p <- paste0(folder, '/', f, '.R')
    write_function(g, p, f)
  }
}




#' Pre-evaluate arguments of a function
#'
#' @description
#' To curry a function means to pre-evaluate some of the arguments
#' So, if you have a function
#'   \code{sum <- function(a, b) {a + b}}
#'
#' And you always want \code{b} to be 1, you could define
#'   \code{add.one <- curry(sum, b = 1)}
#'
#' Which is the same as
#'   \code{function(a) {a + 1}}
#'
#'
#' @param	FUN        the function we are currying
#' @param	...        the arguments you want to pre-evaluate
#'
#' @return
#' the new curried function
#'
#' @examples
#' sum <- function(a, b) {a + b}
#' add.one <- curry(sum, b = 1)
#' function(a) {a + 1}
#'
#' @export
curry <- function(FUN, ...){
  orig = as.list(match.call())
  noms = names(orig)
  if (length(orig) < 3)
    return(FUN)

  ff <- formals(FUN)
  for (i in 3:length(orig)) {
    # "a value of NULL deletes the corresponding item of the list.
    # To set entries to NULL, you need x[i] <- list(NULL)."
    if (is.null(orig[[i]])) {
      ff[noms[i]] <- list(NULL)
    } else {
      ff[[noms[i]]] <- orig[[i]]
    }
  }
  formals(FUN) <- ff
  return(FUN)
}




#' Header search function factory
#'
#' @description
#' Give \code{HFactory} an object or a name of an object
#' that has a \code{names} attribute
#' (Or a function that *returns* a named object).
#' \code{HFactory} will build you an easy-to-use function
#' that encapsulates searching the "header" of
#' the object.
#'
#' @param	name         the object or name of the object
#' @param	ignore.case  do you want your header search function to ignore case?
#'
#' @return
#' a function that takes one argument: \code{pattern}.
#' Give the return value a name, and you can call it like any other function.
#' It will use \code{grep} and \code{pattern} to find matching \code{names}.
#' The header-search function that is returned will catch name changes, too.
#'
#' @examples
#' my_iris <- datasets::iris
#' hi <- HFactory(my_iris)
#' hi('length')
#' hi('width')
#' my_iris$SpeciesPredicted <- 'TODO'
#' hi('species')
#'
#' @export
HFactory  <- function(name, ignore.case = TRUE){
  # TODO: there is something going on when using H functions
  # in a non-global environment
  is.function <- base::is.function(name)

  # Previously, name had to be a charater string representing the name of an object (how annoying!)
  # Because of the next line, it can now be an object!
  # Based on code of "rm" function
  name <- as.character(match.call(expand.dots = FALSE)$name)

  # If name is a function object, trail with "()"
  if(is.function) name <- paste0(name, '()')

  # Also, now it allows for a case-sensitive function
  if(ignore.case) ic = 'TRUE' else ic = 'FALSE'
  s <- paste0('function(pattern = \'\', ignore.case = ',ic,'){names(', name, ')[grep(pattern, names(', name, '), ignore.case = ignore.case)]}')
  return(eval(parse(text = s)))
}




#' Convert text to numbers
#'
#' @description
#' This function takes characters that look like numbers
#' and converts them to numbers.
#' Its name is based on the VBA function \code{CNumeric}.
#' It does some pre-processing before calling
#' \code{\link[base]{as.numeric}}.
#' \enumerate{
#'   \item converts factors
#'   \item removes all whitespace
#'   \item converts wrapping "()" to negatives
#'   \item removes commas
#'   \item converts percentages to decimals
#'   \item calls \code{\link[base]{as.numeric}}
#' }
#'
#' @param	v           a vector
#'
#' @return A vector of numerics. Returns \code{NA}
#' when conversion is not possible after application
#' of the rules above.
#'
#' @examples
#' # Commas are removed
#' cnumeric(c('1,000,000', '2,000.03'))
#'
#' # But, we don't check to make sure that
#' # commas are in the right place first
#' cnumeric(c('1,0,0', '2,0000.03'))
#'
#' # Accounting-style negatives
#' cnumeric(c('(1,000.92)', '(4)'))
#'
#' # Percents are converted
#' cnumeric(c('28.3%', '-1.3%', '(15%)'))
#'
#' # If scientific notation is present, R knows what to do
#' cnumeric(c('3e7', '5e-1'))
#'
#' # TODO it doesn't deal with currencies yet
#' cnumeric(c('USD 0.10', '$14.34'))
#'
#' @export
cnumeric <- function(v) {

  # If this has levels, unlevel it
  if (!is.null(levels(v)) & is.integer(unclass(v))) {
    v <- levels(v)[unclass(v)]
  }

  # Trim first
  v <- gsub(pattern = '\\s*', replacement = '', v)

  # Check to see if negatives are wrapped in ()
  l <- grepl('^\\(.*\\)$', v)
  w <- ifelse(l, paste('-', substring(v, 2, nchar(v) - 1), sep = ''), v)

  # Check to see if we have terminating %
  m <- grepl('.*%$', w)
  x <- ifelse(m, substring(w, 1, nchar(w) - 1), w)

  # Remove any commas
  y <- gsub(pattern = '[,]', replacement = '', x)

  # Cast and return
  #   Don't forget to divide percents by 100!
  kast <- as.numeric(y)
  ifelse(m, kast/100, kast)

}




#' Doc writing: get LaTeX of a matrix
#'
#' @description
#' If you are working in RMarkdown and need to write a matrix in LaTeX
#' it can be a pain.  This function tries to make it easier.
#'
#' @param	M          a matrix-like object
#' @param	one_line   logical -- whether to return one-line or many
#' @param	print      logical -- print the LaTeX to the screen
#' @param	ret        logical -- return the text so it can be stored in a variable
#'
#' @return
#' If \code{ret = TRUE}, the LaTeX code to represent the matrix.
#' If \code{print = TRUE}, the code is printed to the screen using \code{message}.
#'
#' @examples
#' m <- datasets::iris[1:5, 1:4]
#' matrix2latex(m)
#' tex <- matrix2latex(m, print = FALSE)
#' print(tex)
#'
#' @export
matrix2latex <- function(
  M, one_line = TRUE, print = TRUE, ret = !print) {
  M <- as.matrix(M)
  if (one_line) {
    newline = ' '
  } else {
    newline = '\n'
  }
  rows <- apply(M, 1, function(r) paste0(r, collapse = ' & '))
  rows_collapsed <- paste0(rows, collapse = paste0(' \\\\', newline))
  latex <- paste0(
    c('\\begin{bmatrix}', rows_collapsed, '\\end{bmatrix}'),
    collapse = newline)
  if (print) message(latex)
  if (ret) return(latex)
  invisible()
}




#' Intersection of sets
#'
#' @description
#' Give me a bunch of vectors.
#' I'll give you a unique list of all the values
#' that appear in all of them.
#'
#'
#' @param	...   as many vectors as you want
#'
#'
#' @return
#' A vector of values with no duplicates.
#' Each value in the return vector appeared in all input vectors.
#'
#' @examples
#' v1 <- 1:5
#' v2 <- 2:10
#' v3 <- c("1", "2", "3")
#' intersection(v1, v2)
#' intersection(v2, v3)
#' intersection(v1, v2, v3)
#'
#' @export
intersection <- function(...) {
  V <- list(...)
  if (length(V) == 0) return(logical())
  out <- unique(V[[1]])
  for (i in 2:length(V)) {
    out <- out[out %in% V[[i]]]
  }
  return(out)
}




#' Tabular summary of data.frame columns
#'
#' @description
#' Create a tabular form of summary info
#'
#' @param	dataframe   anything that can be coerced into a data frame
#'
#'
#' @return
#' Like the summary function, but tabular and with more information
#'
#' @examples
#' info(iris)
#'
#' @export
info <- function(dataframe) {
  out <- NULL
  for (i in 1:ncol(dataframe)) {

    v <- dataframe[, i, drop = TRUE]
    num <- is.numeric(v) | is.logical(v)
    lv <- length(v)
    vn <- v[!is.na(v)]
    uniques <- length(unique(vn))
    typ <- class(v)

    if (num) {
      qv <- stats::quantile(
        vn,
        probs = c(0, 0.25, 0.5, 0.75, 1))
      sdv <- stats::sd(vn)
      muv <- mean(vn)
      zero_count = sum(vn == 0)
      lvls <- NA
    } else {
      qv <- rep(NA, 5)
      sdv <- NA
      muv <- NA
      zero_count = NA
      lvls <- names(sort(table(v), decreasing = TRUE))
      lvls <- paste0(lvls[1:min(10, length(lvls))], collapse = ', ')
    }

    qvr <- data.frame(
      row.names = i,
      column_index = i,
      column = names(dataframe)[i],
      type = paste(typ, collapse = " "),
      min = qv[1],
      q25 = qv[2],
      median = qv[3],
      mean = muv,
      q75 = qv[4],
      max = qv[5],
      sd = sdv,
      zero_count,
      # sd2ratio = sum(abs(vn - muv) < 2 * sdv) / length(vn),
      na_count = lv - length(vn),
      unique_values = uniques,
      levels = lvls)

    if (is.null(out)) {
      out <- qvr } else { out <- rbind(out, qvr) }

  }

  if (!is.null(attr(dataframe, 'original_header'))) {
    original_header <- attr(dataframe, 'original_header')
    if (ncol(dataframe) == length(original_header)) {
      out$original_header <- original_header
    } else {
      warning('dataframe has an original_header attribute, but it is the wrong length')
    }
  }

  return(out)
}




#' Table function where `useNA` is defaulted to `TRUE`
#'
#' @description
#' Identical to `table(..., useNA = "always")`.
#' The name is inspired by `paste0`.
#'
#' @param	...   arguments passed through to the `table` function
#'
#'
#' @return
#' Returns output of `table` but forces `NA` to always be counted
#'
#' @examples
#' x <- sample(c(letters, NA), 1000, replace = TRUE)
#' table(x)
#' table(x, useNA = "always")
#' table0(x)
#'
#' @export
table0 <- function(...) {
  table(..., useNA = "always")
}




#' Replace all quote-like characters with straight quotes
#'
#' @description
#' Use `gsub` to replace all quote-like characters,
#' including smart quotes and non-English quote characters,
#' with straight English quotes: `"` or `'`.
#' See https://stackoverflow.com/a/47173868.
#'
#' @param x a character vector to normalize
#'
#' @return
#' Returns a character vector with quote-likes replaced.
#'
#' @examples
#' x <- c(
#'   '\u00AB',  # \u00AB  LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
#'   '\u00BB',  # \u00BB  RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
#'   '\u05F4',  # \u05F4  HEBREW PUNCTUATION GERSHAYIM
#'   '\u201C',  # \u201C  LEFT DOUBLE QUOTATION MARK
#'   '\u201D',  # \u201D  RIGHT DOUBLE QUOTATION MARK
#'   '\u201E',  # \u201E  DOUBLE LOW-9 QUOTATION MARK
#'   '\u201F',  # \u201F  DOUBLE HIGH-REVERSED-9 QUOTATION MARK
#'   '\u226A',  # \u226A  MUCH LESS-THAN
#'   '\u226B',  # \u226B  MUCH GREATER-THAN
#'   '\u300A',  # \u300A  LEFT DOUBLE ANGLE BRACKET
#'   '\u300B',  # \u300B  RIGHT DOUBLE ANGLE BRACKET
#'   '\u301D',  # \u301D  REVERSED DOUBLE PRIME QUOTATION MARK
#'   '\u301E',  # \u301E  DOUBLE PRIME QUOTATION MARK
#'   '\u301F',  # \u301F  LOW DOUBLE PRIME QUOTATION MARK
#'   '\uFF02',  # \uFF02  FULLWIDTH QUOTATION MARK
#'   '\u2033',  # \u2033  DOUBLE PRIME
#'   '\u2036',  # \u2036  REVERSED DOUBLE PRIME
#'   '\u02BB',  # \u02BB  MODIFIER LETTER TURNED COMMA
#'   '\u02BC',  # \u02BC  MODIFIER LETTER APOSTROPHE
#'   '\u02BD',  # \u02BD  MODIFIER LETTER REVERSED COMMA
#'   '\u066C',  # \u066C  ARABIC THOUSANDS SEPARATOR
#'   '\u2018',  # \u2018  LEFT SINGLE QUOTATION MARK
#'   '\u2019',  # \u2019  RIGHT SINGLE QUOTATION MARK
#'   '\u201A',  # \u201A  SINGLE LOW-9 QUOTATION MARK
#'   '\u201B',  # \u201B  SINGLE HIGH-REVERSED-9 QUOTATION MARK
#'   '\u055A',  # \u055A  ARMENIAN APOSTROPHE
#'   '\uFE10',  # \uFE10  PRESENTATION FORM FOR VERTICAL COMMA
#'   '"',
#'   "'")
#'
#' y <- data.frame(
#'   all_quotes = x,
#'   straight_quotes = normalize_quote_characters(x))
#'
#' print(y)
#' table(y$straight_quotes)
#'
#' @export
normalize_quote_characters <- function(x) {
  x <- gsub(
    pattern = '[\u00AB\u00BB\u05F4\u201C\u201D\u201E\u201F\u226A\u226B\u300A\u300B\u301D\u301E\u301F\uFF02\u2033\u2036]',
    replacement = '"',
    x = x)
  x <- gsub(
    pattern = '[\u02BB\u02BC\u02BD\u066C\u2018\u2019\u201A\u201B\u055A\uFE10]',
    replacement = "'",
    x = x)
  return(x)
}




#' Fix column names to be like conventional relational database names
#'
#' @description
#' Fix column names to be like conventional relational database names
#'
#' @param	x   names to convert
#'
#'
#' @return
#' Returns fixed names guaranteed to be unique
#'
#' @examples
#' x <- c(
#'   "DR_NO", "Quarter", "Date Rptd",
#'   "DATE OCC", "TIME OCC", "AREA", "AREA NAME",
#'   "Rpt Dist No", "Part 1-2", "Crm Cd", "Crm Cd Desc", "Mocodes",
#'   "Vict Age", "Vict Sex", "Vict Descent", "Premis Cd", "Premis Desc",
#'   "Weapon Used Cd", "Weapon Desc", "Status", "Status Desc", "Crm Cd 1",
#'   "Crm Cd 2", "Crm Cd 3", "Crm Cd 4", "LOCATION|().,{}''", "Cross Street",
#'   "LAT", "LON", "FXEXCHANGERATE...COM",
#'   "Currency Symbols     ", "_Currency Symbols - FX Exchange Rate",
#'   "Home#", "Currency___Converter!",
#'   "World__Countries", "Gold%", '    ', "Currency Codes(ISO)",
#'   "100", "m$", "£", "€", "QUARTER")
#' repair_header(x)
#'
#' @export
repair_header <- function(x) {
  y <- toupper(x)
  y <- alrtools::trim(y)
  y <- gsub('\\s*#\\s*', '_NUMBER_', y)
  y <- gsub('\\s*%\\s*', '_PERCENT_', y)
  y <- gsub('\\s*&\\s*', '_AND_', y)
  y <- gsub('\\s*[$]\\s*', '_USD_', y)
  y <- gsub('\\s*\u00a3\\s*', '_GBP_', y)
  y <- gsub('\\s*\u20ac\\s*', '_EUR_', y)
  y <- gsub('[^A-Z0-9_]', '.', y)
  y <- gsub('[.]+', '.', y)
  y <- gsub('_{3,}', '__', y)
  y <- gsub('[.]', '_', y)
  y <- gsub('(^_+|_+$)', '', y)
  y <- gsub('^X{0,1}[_0-9]*$', 'X', y)

  ifelse(
    duplicated(y) | duplicated(y, fromLast = TRUE) | y == 'X',
    paste(y, 1:length(x), sep = '___'),
    y)
}




#' Load CSV with info about original header
#'
#' @description
#' A wrapper for readr::read_csv that uses alrtools::repair_header
#' to fix the header, but keeps a copy of the original values in an attribute.
#'
#' @param	path        path to the CSV file to load
#' @param col_types   One of NULL, a cols() specification, or a string. See vignette("readr") for more details.
#' @param na          values to replace with NA -- defaults to Excel errors
#' @param ...         other arguments passed to readr::read_csv
#'
#'
#' @return
#' Returns a tibble of the CSV file
#'
#' @examples
#' my_data <- data.frame(
#'   'Seq No' = 1:26,
#'   'Uppercase Letters' = LETTERS,
#'   'Lowercase Letters' = letters,
#'   check.names = FALSE)
#'
#' temp_path <- tempfile(fileext = '.csv')
#' write.csv(x = my_data, file = temp_path, row.names = FALSE)
#'
#' my_data_reloaded <- load_csv(temp_path)
#'
#' # Fixed Names
#' names(my_data_reloaded)
#'
#' # Original Names
#' attr(my_data_reloaded, 'original_header')
#'
#' # Clean Up
#' unlink(temp_path)
#'
#' @export
load_csv <- function(
    path,
    col_types = NULL,
    na = c('', 'NA', '#N/A', '#DIV/0!', '#NAME?', '#REF!', '#VALUE!', '#NULL!'),
    ...) {

  # Load un-edited header
  h <- utils::read.csv(path, header = FALSE, nrows = 1)
  h <- unname(unlist(h))

  if (is.null(col_types))
    col_types <- readr::cols(.default = readr::col_guess())

  d <- readr::read_csv(
    file = path,
    col_types = col_types,
    name_repair = alrtools::repair_header,
    na = na, ...)

  attr(d, 'original_header') <- h
  return(d)
}




#' Excel-like \code{XLOOKUP} function
#'
#' @description
#' Works like Excel's \code{XLOOKUP} function
#'
#' @param	x               a vector of values you want to match in \code{lookup_vector}
#' @param	lookup_vector   the vector to match in -- get the index for \code{return_vector}
#' @param	return_vector   the vector to return from
#' @param	warn            TRUE will list values of \code{x} that are not found in \code{lookup_vector}
#' @param	ignore_case     TRUE will do a case insensitive match of \code{x} on \code{lookup_vector}
#'
#' @return
#' Returns a vector of values with the same length as \code{lookup_vector}.
#' If a value is not found, then NA is returned.
#' NA can be mapped to a non-NA value.
#'
#' @examples
#' ref <- data.frame(
#'   state = c('UT', 'SD', 'FL', NA, 'NY', 'CA'),
#'   category = c(1, 2, 5, 10, 6, 7)
#' )
#'
#' xlookup('CA', ref$state, ref$category)
#' xlookup('KY', ref$state, ref$category)
#' xlookup(NA, ref$state, ref$category)
#'
#' @export
xlookup <- function(
    x, lookup_vector,
    return_vector = NULL,
    warn = TRUE,
    ignore_case = TRUE) {

  if (length(x) == 0)
    return(character(0))

  if (length(lookup_vector) == 0) {
    warning('lookup_vector is empty')
    return(rep(NA_character_, length(x)))
  }

  if (sum(duplicated(lookup_vector)) > 0)
    stop('lookup_vector has duplicate entries')

  if (is.null(return_vector))
    return_vector <- 1:length(lookup_vector)

  if (length(lookup_vector) != length(return_vector))
    stop('lookup_vector and return_vector must be the same length')

  NA_index <- which(is.na(lookup_vector))
  has_NA <- length(NA_index) == 1

  if (has_NA) {
    return_NA <- return_vector[NA_index]
    lookup_vector <- lookup_vector[-NA_index]
    return_vector <- return_vector[-NA_index]
  } else {
    return_NA <- NA
  }

  ux <- as.character(x)
  ulookup <- as.character(lookup_vector)

  if (ignore_case) {
    ux <- toupper(ux)
    ulookup <- toupper(ulookup)
  }

  if (warn) {
    missing <- setdiff(ux, c(ulookup, NA))
    if (length(missing) > 0) {
      warning(
        '\nMissing values:\n',
        paste0(missing, collapse = '\n'))
    }
  }

  output <- return_vector[as.integer(factor(ux, levels = ulookup))]
  output[is.na(ux)] <- return_NA
  return(output)

}

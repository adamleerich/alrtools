# alrtools

A collection of small, dependency-light utility functions for everyday R work: string manipulation, date handling, data cleaning, environment/functional-programming helpers, and package development tools.

## Installation

```r
# install.packages("devtools")
devtools::install_github("adamleerich/alrtools")
```

## Usage

```r
library(alrtools)
```

## Function Reference

### String utilities

| Function | Description |
|---|---|
| `left(string, n)` | Get the first `n` characters of a string (like Excel's `LEFT`) |
| `right(string, n)` | Get the last `n` characters of a string (like Excel's `RIGHT`) |
| `mid(string, start, length)` | Get a substring starting at a position (like Excel's `MID`) |
| `trim(x)` | Remove leading and trailing whitespace (like Excel's `TRIM`) |
| `flatten_whitespace(x)` | Collapse all whitespace/newlines into single spaces so text is copy-paste safe |
| `normalize_quote_characters(x)` | Replace smart quotes and other quote-like Unicode characters with straight `"` and `'` |
| `cnumeric(v)` | Convert strings that look like numbers (with commas, `%`, accounting-style negatives, etc.) into numerics |

```r
left("lazy dog", 4)
#> "lazy"

right("lazy dog", 3)
#> "dog"

mid("lazy dog", 3, 2)
#> "zy"

trim("  leading and trailing spaces   ")
#> "leading and trailing spaces"

cnumeric(c("1,000,000", "(4)", "28.3%"))
#> 1e+06  -4  0.283
```

### Dates

| Function | Description |
|---|---|
| `quarter_name(d)` | Return a date's year and quarter, e.g. `"2023q2"` |
| `as.serialdate(x)` | Convert a date to its Excel serial number |

```r
quarter_name(as.Date("2022-01-14"))
#> "2022q1"

as.serialdate(as.Date("2025-02-28"))
#> 45716
```

### Data frame / CSV utilities

| Function | Description |
|---|---|
| `repair_header(x)` | Convert messy column names into clean, unique, database-friendly names |
| `load_csv(path, ...)` | Wrapper around `readr::read_csv()` that repairs headers while preserving the original names as an attribute |
| `info(dataframe)` | Tabular column-by-column summary (type, min/max, quartiles, mean, SD, NA count, unique values) — like `summary()` but easier to read |
| `table0(...)` | Same as `table()`, but with `useNA = "always"` by default |
| `xlookup(x, lookup_vector, return_vector, ...)` | Excel-style `XLOOKUP` — match values in `x` against `lookup_vector` and return the corresponding values from `return_vector` |

```r
info(iris)

xlookup("CA", ref$state, ref$category)
```

### Math / vectors

| Function | Description |
|---|---|
| `pmean(..., na.rm = TRUE)` | Row-wise mean across vectors — what `pmax`/`pmin` do for max/min, `pmean` does for mean |
| `intersection(...)` | Unique values common to all supplied vectors |
| `matrix2latex(M, ...)` | Convert a matrix into LaTeX (`bmatrix`) code, handy for RMarkdown |

```r
pmean(1:10, 5, 11:20)

intersection(1:5, 2:10, c("1", "2", "3"))
```

### Environments & functional programming

| Function | Description |
|---|---|
| `load_env(RData, env)` | Load an `.RData` file into a new (or specified) environment instead of the global environment |
| `source_env(RScript, env)` | Source an R script into a new (or specified) environment instead of the global environment |
| `execute_in(f, env, ...)` | Run a function with its environment temporarily reassigned — useful for running someone else's code that depends on global objects |
| `curry(FUN, ...)` | Pre-evaluate ("curry") some of a function's arguments, returning a new function |
| `HFactory(name, ignore.case = TRUE)` | Build a function that searches the `names()` of an object — handy for interactively exploring wide data frames |

```r
add_one <- curry(function(a, b) a + b, b = 1)
add_one(5)
#> 6

hi <- HFactory(iris)
hi("length")
#> "Sepal.Length" "Petal.Length"
```

### Package development tools

| Function | Description |
|---|---|
| `open_test(test, pkg, engine = "testthat")` | Open (or create) a test file for a given object under `tests/<engine>/` |
| `write_function(f, file, name)` | Write a function's source code to a sourceable `.R` file |
| `write_package(pkg, folder)` | Write every function in a package's namespace out to individual `.R` files |

```r
# open_test(lm)
# write_package("alrtools", "some/folder/")
```


### Constants
```r
e <- exp(1)
```


## Note
Claude helped write this README.

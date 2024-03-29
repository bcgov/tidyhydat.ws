
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![img](https://img.shields.io/badge/Lifecycle-Stable-97ca00)](https://github.com/bcgov/repomountie/blob/master/doc/lifecycle-badges.md)
\[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)

# tidyhydat.ws

## Project Status

This package is maintained by the Data Science and Analytics Branch of
the [British Columbia Ministry of Citizens’
Services](https://www2.gov.bc.ca/gov/content/governments/organizational-structure/ministries-organizations/ministries/citizens-services).

## Installation

``` r
#install.packages("remotes")
remotes::install_github("bcgov/tidyhydat.ws")
```

## Water Office web service - `realtime_ws()`

The National Hydrological Service has recently introduced an efficient
service from which to query real-time data. The `realtime_ws()`
function, which provides a convenient way to import this data into R,
introduces two new arguments that impact the data that is returned. The
web service provides additional data beyond simply hydrometric
information. This is specified using the `parameters` argument as an
integer code. The corresponding parameters can be examined using the
internal `param_id` dataset:

``` r
library(tidyhydat.ws)
data("param_id")
param_id
#> # A tibble: 42 x 7
#>    Parameter Code  Unit  Name_En   Name_Fr    Description_En    Description_Fr  
#>        <dbl> <chr> <chr> <chr>     <chr>      <chr>             <chr>           
#>  1        46 HG    m     Water le~ Niveau d'~ Height, stage, e~ Hauteur, niveau~
#>  2        16 HG2   m     Water le~ Niveau d'~ Height, stage, a~ Hauteur, niveau~
#>  3        11 HG22  m     Water le~ Niveau d'~ Height, stage, a~ Hauteur, niveau~
#>  4        52 HG3   m     Water le~ Niveau d'~ Height, stage, a~ Hauteur, niveau~
#>  5        13 HG33  m     Water le~ Niveau d'~ Height, stage, a~ Hauteur, niveau~
#>  6         3 HGD   m     Water le~ Niveau (m~ Provisional Dail~ niveau d'eau qu~
#>  7        39 HGH   m     Water le~ Niveau (m~ Provisional hour~ Niveau d'eau ho~
#>  8        14 HL    m     Elevatio~ Élévation~ Elevation, natur~ Élévation, lac ~
#>  9        42 HR    m     Elevatio~ Élévation~ Elevation, lake ~ Élévation, cour~
#> 10        17 PA    kPa   Atmosphe~ Pression ~ Pressure, atmosp~ Pression, atmos~
#> # ... with 32 more rows
```

The `parameters` argument will take any value in the
`param_id$Parameter` column. The web service requires credentials to
access which can only be requested from ECCC. To retrieve data in this
manner, `tidyhydat.ws` employs a two stage process whereby we get a
token from the web service using our credentials then use that token to
access the web service. Therefore the second new argument is `token` the
value of which is provided by `token_ws()`:

``` r
## Get token
token_out <- token_ws()

## Input station_number, parameters and date range
ws_test <- realtime_ws(station_number = "08LG006",
                       parameters = c(46,5), ## Water level and temperature
                       start_date = "2017-06-25",
                       end_date = "2017-07-24",
                       token = token_out)
```

Tokens only last for 10 minutes and users can only have 5 tokens at
once. Therefore it is best to query the web service a little as possible
by being efficient and strategic with your queries. `realtime_ws()` will
only return data that is available. A message is returned if a
particular station was not available. `parameters`, `start_date` and
`end_date` fail silently if the station does not collect that parameter
or data on that date. The web service constrains queries to be under 60
days and fewer than 300 stations. If more data is required, multiple
queries should be made and combined using a function like `rbind()` or
`dplyr::bind_rows()`.

### Managing your credentials in R

Because you are accessing the web service using credentials and
potentially will be sharing your code will others, it is important that
you set up some method so that your secrets aren’t shared widely. Please
read [this article](http://httr.r-lib.org/articles/secrets.html) to
familiarize yourself with credential management. [This
section](http://httr.r-lib.org/articles/secrets.html#environment-variables)
is summarized here specific to `tidyhydat.ws`. If you receive your
credentials from ECCC it not advisable to directly include them in any
code. Rather these important values are again stored in the `.Renviron`
file. Run the following in a console:

``` r
file.edit("~/.Renviron")
```

This opens your `.Renviron` file which where you enter the credentials
given to you by ECCC. The code that you paste into the `.Renviron` file
should look like something like this:

``` r
## Credentials for ECCC web service
WS_USRNM = "here is the username that ECCC gave you"
WS_PWD = "here is the password that ECCC gave you"
```

Now these values can be accessed within an R session without giving away
your secrets (Using `Sys.getenv()`). For `token_ws()` they are called
automatically each time you use the function.

## Compare `realtime_ws` and `realtime_dd`

`tidyhydat.ws` provides two methods to download real-time data.
`realtime_ws()`, coupled with `token_ws()`, is an API client for a web
service hosted by ECCC. `realtime_dd()` provides a function to import
openly accessible .csv files from
[here](http://dd.weather.gc.ca/hydrometric/). `realtime_ws()` has
several difference to `realtime_dd()`. These include:

-   *Speed*: `realtime_ws()` is much faster for larger queries
    (i.e. many stations). For single station queries `realtime_dd()` if
    more appropriate.
-   *Length of record*: `realtime_ws()` records goes back further though
    only two months of data can accessed at one time. Though it varies
    for each station, typically the last 18 months of data are available
    with the web service.  
-   *Type of parameters*: `realtime_dd()` is restricted to river flow
    (either LEVEL and FLOW) data. In contrast `realtime_ws()` can
    download several different parameters depending on what is available
    for that station. See `data("param_id")` for a list and explanation
    of the parameters.
-   *Date/Time filtering*: `realtime_ws()` provides argument to select a
    date range. Selecting a data range with `realtime_dd()` is not
    possible until after all files have been downloaded.
-   *Accessibility*: `realtime_dd()` downloads data that openly
    accessible. `realtime_ws()` downloads data using a username and
    password which must be provided by ECCC.

## How to Contribute

If you would like to contribute to the package, please see our
[CONTRIBUTING](CONTRIBUTING.md) guidelines.

Please note that this project is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree
to abide by its terms.

## License

Copyright 2017 Province of British Columbia

Licensed under the Apache License, Version 2.0 (the “License”); you may
not use this file except in compliance with the License. You may obtain
a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an “AS IS” BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

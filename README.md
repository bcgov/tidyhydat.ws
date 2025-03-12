
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![Lifecycle: deprecated](https://img.shields.io/badge/lifecycle-deprecated-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#deprecated)
![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)

# tidyhydat.ws

## Project Status

This project is now deprecated. The functionality previously provided by this package is now available directly in [`tidyhydat`](https://docs.ropensci.org/tidyhydat/) as [version 0.6.0](https://docs.ropensci.org/tidyhydat/news/index.html#tidyhydat-060). Usage of the webservice is almost identical in `tidyhydat`. The sole difference is the exclusion of a `token` parameter. Instead, `tidyhydat` makes use of unathenticated calls to the webservice: 

```r
library(tidyhydat)
realtime_ws(
  station_number = "08MF005",
  parameters = c(46, 5), 
  start_date = Sys.Date() - 14,
  end_date = Sys.Date()
)
```

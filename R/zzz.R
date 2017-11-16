.onLoad <-
  function(libname = find.package("tidyhydat"),
           pkgname = "tidyhydat") {
    # CRAN Note avoidance
    if (getRversion() >= "2.15.1")
      utils::globalVariables(
        # Vars used in Non-Standard Evaluations, declare here to avoid CRAN warnings
        ## This is getting ridiculous
        c("ID",
          "param_id",
          "Name_Fr",
          "STATION_NUMBER",
          "Date",
          "Name_En",
          "Value",
          "Unit",
          "Grade",
          "Symbol",
          "Approval",
          "Parameter",
          "Code",
          "." # piping requires '.' at times
        )
      )
    invisible()
  }

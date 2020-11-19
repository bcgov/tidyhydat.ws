#' Download realtime data from the ECCC web service [EXPERIMENTAL]
#'
#' Function to actually retrieve data from ECCC web service. Before using this function,
#' a token from \code{token_ws()} is needed. \code{realtime_ws} will let you know if the token has expired.
#' The maximum number of days that can be queried depends on other parameters being requested.
#' If one station is requested, 18 months of data can be requested. If you continually receiving
#' errors when invoking this function, reduce the number of observations (via station_number,
#' parameters or dates) being requested.
#'
#' @param station_number Water Survey of Canada station number.
#' @param parameters parameter ID. Can take multiple entries. Parameter is a numeric code. See \code{param_id} for options. Defaults to all parameters.
#' @param start_date Need to be in YYYY-MM-DD. Defaults to 30 days before current date.
#' @param end_date Need to be in YYYY-MM-DD. Defaults to current date.
#' @param token generate by \code{token_ws()}
#'
#'
#' @format A tibble with 6 variables:
#' \describe{
#'   \item{STATION_NUMBER}{Unique 7 digit Water Survey of Canada station number}
#'   \item{Date}{Observation date and time. Formatted as a POSIXct class as UTC for consistency.}
#'   \item{Name_En}{Code name in English}
#'   \item{Value}{Value of the measurement.}
#'   \item{Unit}{Value units}
#'   \item{Grade}{future use}
#'   \item{Symbol}{future use}
#'   \item{Approval}{future use}
#'   \item{Parameter}{Numeric parameter code}
#'   \item{Code}{Letter parameter code}
#' }
#'
#' @examples
#' \dontrun{
#' token_out <- token_ws()
#'
#' stations_ws(station_number = "08MF005", token = token_out)
#'
#' }
#' @family realtime functions
#' @export


stations_ws <- function(station_number, parameters = c(46, 16, 52, 47, 8, 5, 41, 18),
                        start_date = Sys.Date() - 30, end_date = Sys.Date(), token) {


  ## Check to see if the token is expired
  time_token <- attr(token, 'time')
  if(format(time_token + 10 * 60) < Sys.time()){
    stop("Your token has expired. Retrieve a new one using token_ws()")
  }



  ### Check date is in the right format
  #if (is.na(as.Date(start_date, format = "%Y-%m-%d")) | is.na(as.Date(end_date, format = "%Y-%m-%d"))) {
  #  stop("Invalid date format. Dates need to be in YYYY-MM-DD format")
  #}



  ## Build link for GET
  baseurl <- "https://wateroffice.ec.gc.ca/services/real_time_data/csv/inline?"
  station_string <- paste0("stations[]=", station_number, collapse = "&")
  parameters_string <- paste0("parameters[]=", parameters, collapse = "&")
  date_string <- paste0("start_date=", start_date, "%2000:00:00&end_date=", end_date, "%2023:59:59")
  token_string <- paste0("token=", token[1])

  ## paste them all together
  url_for_GET <- paste0(
    baseurl,
    station_string, "&",
    parameters_string, "&",
    date_string, "&",
    token_string
  )

  ## Get data
  get_ws <- httr::GET(url_for_GET)

  ## Give webservice some time
  Sys.sleep(1)

  if (httr::status_code(get_ws) == 403) {
    stop("403 Forbidden: the web service is denying your request. Try any of the following options:
         -Ensure you are not currently using all 5 tokens
         -Wait a few minutes and try again
         -Copy the token_ws call and paste it directly into the console
         -Try using realtime_ws if you only need water quantity data
         ")
  }

  ## Check the GET status
  httr::stop_for_status(get_ws)

  if (httr::headers(get_ws)$`content-type` != "text/csv; charset=utf-8") {
    stop("GET response is not a csv file")
  }

  ## Turn it into a tibble and specify correct column classes
  csv_df <- httr::content(
    get_ws,
    type = "text/csv",
    encoding = "UTF-8",
    col_types = "cTidcci")

  ## Check here to see if csv_df has any data in it
  if (nrow(csv_df) == 0) {
    stop("No data exists for this station query")
  }

  ## Rename columns to reflect tidyhydat naming
  colnames(csv_df) <- c("STATION_NUMBER","Date","Parameter","Value","Grade","Symbol","Approval")

  csv_df <- dplyr::left_join(
    csv_df,
    dplyr::select(tidyhydat.ws::param_id, -Name_Fr),
    by = c("Parameter")
  )
  csv_df <- dplyr::select(csv_df, STATION_NUMBER, Date, Name_En, Value, Unit, Grade, Symbol, Approval, Parameter, Code)

  ## What stations were missed?
  differ <- setdiff(unique(station_number), unique(csv_df$STATION_NUMBER))
  if (length(differ) != 0) {
    if (length(differ) <= 10) {
      message("The following station(s) were not retrieved: ", paste0(differ, sep = " "))
      message("Check station number for typos or if it is a valid station in the network")
    }
    else {
      message("More than 10 stations from the initial query were not returned. Ensure realtime and active status are correctly specified.")
    }
  } else {
    message("All station successfully retrieved")
  }

  ## Return it
  csv_df

  ## Need to output a warning to see if any stations weren't retrieved
  }

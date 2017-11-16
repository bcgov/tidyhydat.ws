context("Testing realtime functions")

test_that("realtime_ws returns the correct data header", {
  skip_on_cran()
  skip_on_travis()
  token_out <- token_ws()
  
  ws_test <- realtime_ws(station_number = "08MF005",
                         parameters = c(46),  ## Water level and temperature
                         start_date = Sys.Date(),
                         end_date = Sys.Date(),
                         token = token_out)
  
  expect_identical(colnames(ws_test),
                   c("STATION_NUMBER", "Date", "Name_En", "Value", "Unit", "Grade",
                     "Symbol", "Approval", "Parameter", "Code"))
  
  ## Turned #42 into a test
  expect_is(ws_test$Value, "numeric")
})

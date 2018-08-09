context("Testing realtime functions")

test_that("realtime_ws returns the correct data header", {
  skip_on_cran()
  skip_on_travis()
  token_out <- token_ws()

  ws_test <- realtime_ws(station_number = "08MF005",
                         parameters = c(46),  ## Water level
                         start_date = Sys.Date(),
                         end_date = Sys.Date(),
                         token = token_out)

  expect_identical(colnames(ws_test),
                   c("STATION_NUMBER", "Date", "Name_En", "Value", "Unit", "Grade",
                     "Symbol", "Approval", "Parameter", "Code"))

  ## Turned #42 into a test
  expect_is(ws_test$Value, "numeric")
})


test_that("realtime_ws fails with incorrectly specified date",{
  skip_on_cran()
  skip_on_travis()
  token_out <- token_ws()

  expect_error(realtime_ws(station_number = "08MF005",
                           parameters = 46,
                           start_date = "01-01-2017 00:00:00",
                           token = token_out))
  expect_error(realtime_ws(station_number = "08MF005",
                           parameters = 46,
                           end_date = "01-01-2017 00:00:00",
                           token = token_out))
})

test_that("realtime_ws succeed specifying only date; no time",{
  skip_on_cran()
  skip_on_travis()
  token_out <- token_ws()

  sdate <- Sys.Date() - 1
  edate <- Sys.Date()

  output <- realtime_ws(station_number = "08MF005",
                           parameters = 46,
                           start_date = sdate,
                           end_date = edate,
                           token = token_out)

  expect_equal(as.Date(max(output$Date)), edate)
  expect_equal(as.Date(min(output$Date)), sdate)

})

test_that("realtime_ws succeed specifying  time",{
  skip_on_cran()
  skip_on_travis()
  token_out <- token_ws()

  stime <- as.POSIXlt(Sys.time()- 1E5, tz = "UTC")
  etime <- as.POSIXlt(Sys.time(), tz = "UTC")

  output <- realtime_ws(station_number = "08MF005",
                        parameters = 46,
                        start_date = stime,
                        end_date = etime,
                        token = token_out)

  expect_true(max(output$Date) <= etime)
  expect_true(min(output$Date) >= stime)

})

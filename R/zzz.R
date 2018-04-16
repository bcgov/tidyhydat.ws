.onLoad <-
 function(libname = find.package("tidyhydat"),
          pkgname = "tidyhydat") {
  if(!nzchar(Sys.getenv("WS_USRNM")) | !nzchar(Sys.getenv("WS_PWD"))){
    packageStartupMessage("You do not have your webservice credentials setup. For directions please run:")
    packageStartupMessage("vignette('setup_webservice_credentials', package = 'tidyhydat.ws')")
  }
 }


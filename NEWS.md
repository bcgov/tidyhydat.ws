tidyhydat.ws 0.1.5
=========================
* Make `realtime_ws` more flexible by allowing any numeric parameter input. 
* Expand `param_id`

tidyhydat.ws 0.1.4
=========================
* Added the ability to request times to `realtime_ws`.


tidyhydat.ws 0.1.3
=========================

### Minor improvement

* Added user agent to identify HTTP requests coming from tidyhydat.ws



tidyhydat.ws 0.1.2
=========================

### Minor improvement

* Removed 300 station limit
* Using rlang internally
* Added package level documentation
* Adding a check at package load if the password env variables are set

tidyhydat.ws 0.1.1 
=========================

### Bug Fixes

* Modify some column headings to accomodate changes to webservice
* Add time attribute to token object so that `realtime_ws()` can check if the token is expired. 

tidyhydat.ws 0.1.0 
=========================

### NEW FEATURES

* Split off from main tidyhydat package

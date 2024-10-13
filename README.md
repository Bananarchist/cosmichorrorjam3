

## Dependencies
To build the project:
* Elm 0.19.1
* Tcl 8.5 (to use provided build script)

To run, a web server is necessary as assets are loaded from disk, and security protocals will forbid simply opening the html file and loading all the assets locally. The `scripts/serve.tcl` script provided has the following requirements:
* Tcl 8.5
* Python 3
* Unused port 8000

#!/usr/bin/tclsh

# FUCKING CALL PYTHON FROM TCL BIIIIITCH

exec python3 -m http.server 8000 --directory dist

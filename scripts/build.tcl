#!/usr/bin/tclsh

file mkdir dist
file mkdir dist/js
file mkdir dist/css
file mkdir dist/assets/bgm
file mkdir dist/assets/sprites
file mkdir dist/assets/sfx

# compile Elm
exec elm make --debug src/elm/Main.elm --output=dist/js/main.js

# copy html and css
file copy -force src/css/style.css dist/css/style.css
file copy -force src/html/index.html dist/index.html

# copy js
file copy -force src/js/audio.js dist/js/audio.js

# copy bgm assets
foreach f [glob -nocomplain -directory assets/bgm -type f *.m4a] {
		file copy -force $f dist/assets/bgm/
}

# copy sfx assets
foreach f [glob -nocomplain -directory assets/sfx -type f *.wav] {
		file copy -force $f dist/assets/sfx/
}

# copy sprites
foreach f [glob -nocomplain -directory assets/sprites -type f *.png] {
		file copy -force $f dist/assets/sprites/
}

#!/usr/bin/env bash

echo "Make directory 'build'"
mkdir -p build

echo "Cleanup directory 'build'"
rm -rf build/*

echo "Build project enterpoint src/Main.elm"
temp_file=$(mktemp)
elm make src/Main.elm --optimize --output="$temp_file.js"

echo "Copy public"
rsync -a --exclude='index.html' public/* build

echo "Optimize"
uglifyjs "$temp_file.js" --compress "pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe" \
    | uglifyjs --mangle --output=build/application.min.js
rm "$temp_file.js"
cat public/index.html > "$temp_file.html"
sed -i '/<\/head>/i <script src="application.min.js"></script>' "$temp_file.html"
htmlmin "$temp_file.html" -o build/index.html
rm "$temp_file.html"

echo "Done"

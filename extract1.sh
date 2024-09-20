#!/bin/bash

#
# install 7zip before you try to run this script.
# install it via sudo apt-get install p7zip-full
# dont get to set the paths for executable and rootdir below
#
sevenZipPath="/usr/bin/7z"  # Set the path to 7-Zip executable
rootDir="/path/to/your/root/directory"  # Set the root directory where you want to start the operation

echo "Script started at: $(date)"

cd "$rootDir" || { echo "Failed to change directory to $rootDir"; exit 1; }

for dir in */; do
    dir="${dir%/}"
    echo "Checking folder: $dir"
    rarFound=0
    for file in "$dir"/*.rar; do
        if [[ -e "$file" ]]; then
            rarFound=1
            echo "Extracting \"$file\"..."
            "$sevenZipPath" x "$file" -o"$dir"
            if [[ $? -eq 0 ]]; then
                echo "Extraction successful: \"$file\""
                echo "Deleting .rar and .rXX files in $dir..."
                find "$dir" -maxdepth 1 -type f \( -name "*.rar" -o -name "*.r??" -o -name "*.sfv" \) -exec echo "Deleting {}" \; -exec rm -f {} \;
            else
                echo "Failed to extract \"$file\"."
            fi
        fi
    done
    if [[ -d "$dir/Sample" ]]; then
        echo "Deleting Sample folder in $dir..."
        rm -rf "$dir/Sample"
    fi
    if [[ $rarFound -eq 0 ]]; then
        echo "No .rar files found in $dir"
    fi
done

echo "Script completed at: $(date)"

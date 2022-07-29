#!/usr/bin/env bash

echo "Cleaning output from previous run"
rm -r output

# The program should work as follows:
# 1. for every colorscheme:
#   (a) go to src and find a directory with the scheme name, does it exist?
#     (yes) for every file in general dir, see if it's also in scheme-specific dir,
#           if it's, build scheme-specific one, if not, build general one, both
#           to output/theme-name/specific/.
#     (no)  this should be done in both cases. build every file in general to
#           output/theme-name/general/ 

# get colorscheme name in format {repo-name}-{yaml-name} without the .yaml at the end
for scheme in $(fd '.yaml' schemes/); do
   echo "building with $scheme:"
   scheme_alt="$(echo "$scheme" | sed -e 's/^schemes\///' -e 's/\//-/g' -e 's/.yaml$//')"

   # get every config file in format {section}/{config-file-can-be-in-nested-dirs}
   for config_file in $(fd -t file . 'src/' | sed -e 's/src\///'); do
       indent="\t"
       echo -e "${indent}Building $config_file"

       echo -e "${indent}making $(dirname output/"$scheme_alt"/"$config_file")"
       mkdir -p "$(dirname output/"$scheme_alt"/"$config_file")"
       hbs -d "$scheme" "src/$config_file" -o "output/$scheme_alt/$config_file"
   done
done

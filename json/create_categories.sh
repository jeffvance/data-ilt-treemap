#!/bin/bash
# Convert the "convertcvs.json" file to separate files for each db category.
#
# constants
CONV_JSON_FILE='convertcsv.json'

# 1st create a file containing all of the categories
grep type\": $CONV_JSON_FILE | \
	uniq | \
	cut -d: -f2 | \
	sed -e 's/\r//g' -e 's/"//g' >/tmp/uniq_categories

# define an array containing these categories
readarray categories </tmp/uniq_categories

# write each category to a separate file
for c in "${categories[@]}"; do
   f="subset_${c// /_}"
   grep -h -B5 -A1 "$c" $CONV_JSON_FILE >$f
done

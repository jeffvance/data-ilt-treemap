#!/bin/bash
# Convert the "raw-data.json" file to separate files for each db category.
#
# constants -- should only need to change these values to accomodate new json
#              records
RAW_DIR='raw-data'
CONV_JSON_FILE="$RAW_DIR/raw-data.json"
SUBSET_JSON_PREFIX="$RAW_DIR/subset_"
TMP_UNIQ_FILE='/tmp/uniq_categories'
# json file layout constants
CATEGORY_FIELD_NAME='Type'
CATEGORY_FIELD_POS=6 # above category row num (1-relative) in the json entry
NUM_FIELDS_PER_ENTRY=8 # num fields within each {...} json entry

cat <<EOF

 This script extracts json content from the $CONV_JSON_FILE file 
 and creates separate json files -- one per data category.

EOF

[[ ! -d $RAW_DIR ]] && {
  echo "ERROR: the raw data dir, \"$RAW_DIR\", is missing.";
  echo "Most likely you are in the wrong working directory...";
  exit 1 ; }

[[ ! -f $CONV_JSON_FILE ]] && {
  echo "ERROR: file \"$CONV_JSON_FILE\" is missing!";
  echo "This file is the master JSON file containing all of the categories.";
  exit 1; }

# 1st create a file containing all of the categories
# remove \r, remove double-quotes and trailing commas
grep $CATEGORY_FIELD_NAME\": $CONV_JSON_FILE \
	| sort -u \
	| cut -d: -f2 \
	| sed -e 's/\r//g' -e 's/"//g' -e 's/,$//' \
	>$TMP_UNIQ_FILE

# define an array containing these categories
readarray -t categories <$TMP_UNIQ_FILE

echo " There are ${#categories[@]} unique categories..."
echo

# compute before/after grep values in order to extract the entire json record
let after=NUM_FIELDS_PER_ENTRY-CATEGORY_FIELD_POS+1
let before=CATEGORY_FIELD_POS

# write each category to a separate file
for c in "${categories[@]}"; do
   f="$SUBSET_JSON_PREFIX${c// /_}.json"
   echo "... creating file: \"$f\""
   echo "[" >$f #overwrites file
   grep --no-group-separator -B$before -A$after \
	"${CATEGORY_FIELD_NAME}\":\"$c" $CONV_JSON_FILE >>$f
   # remove trailing comma if present
   sed -i '$ s/,.*$//' $f
   echo "]" >>$f
done

echo
exit 0

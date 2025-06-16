#!/bin/bash

WEEK=${1:-$(date +%W)}
YEAR=${2:-$(date +%G)}

FILENAME="tt_${WEEK}_${YEAR}.R"


if [ -e "$FILENAME" ]; then
    echo "File '$FILENAME' already exists."

elif [ "$WEEK" -lt 1 ] || [ "$WEEK" -gt 53 ]; then
    echo "Please enter a valid week (1-53)."

elif [ "$YEAR" -lt 2018 ] || [ "$YEAR" -gt "$(date +%G)" ]; then
    echo "Please enter a valid year (2018-$(date +%G))."

else
    echo "library(tidyverse)
library(tidytuesdayR)

tuesdata <- tt_load(${YEAR}, ${WEEK})

list2env(tuesdata, envir = .GlobalEnv)" > "$FILENAME"

    chmod +x "$FILENAME"
    echo "Created '$FILENAME'"
fi



#!/bin/bash

current_year=$(date +%Y)
selected_year=$current_year

extract_table() {
    local year=$1
    local url
    
    if [ "$year" -eq "$current_year" ]; then
        url="https://api.github.com/repos/rfordatascience/tidytuesday/contents/README.md"
    else
        url="https://api.github.com/repos/rfordatascience/tidytuesday/contents/data/${year}/readme.md"
    fi
    
    curl -s "$url" | jq -r '.content' | base64 -d | \
      awk '/^\| *Week/,/^\*\*\*/' | \
      grep -v '^\*\*\*' | grep -v '^[[:space:]]*$' | \
      grep -v '^|.*----' | tail -n +2 
}

clean_table() {
    while IFS='|' read -r _ week date data _; do
        week=$(echo "$week" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        date=$(echo "$date" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        data_clean=$(echo "$data" | sed 's/\[//g; s/\](.*\.md)//g; s/\](.*))//g' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        
        # Print without the trailing |
        printf "|  %-2s  |  %-10s  |  %-60s\n" "$week" "$date" "$data_clean"
    done
}

while true; do
    printf "⏳ Loading TidyTuesday data for %d..." "$selected_year"
    
    table_data=$(extract_table "$selected_year" | clean_table)
    
    # Clear the loading line
    printf "\r%*s\r" 50 ""
    
    if [ -z "$table_data" ]; then
        echo "❌ No data found for $selected_year. Returning to $current_year."
        selected_year=$current_year
        continue
    fi
    
    selected=$(echo "$table_data" | fzf \
        --prompt="📅 $selected_year | p=prev, n=next, q=quit: " \
        --bind 'p:abort' \
        --bind 'n:abort' \
        --bind 'q:abort' \
        --expect=p,n,q \
        --header="P: Previous year | N: Next year | Q: Quit | Enter: Select")
    
    key=$(echo "$selected" | head -n1)
    choice=$(echo "$selected" | tail -n+2)
    
    case "$key" in
        "p")
            selected_year=$(($selected_year - 1))
            [ $selected_year -lt 2018 ] && selected_year=2018
            ;;
        "n")
            selected_year=$(($selected_year + 1))
            [ $selected_year -gt $current_year ] && selected_year=$current_year
            ;;
        "q")
          #  echo "👋 Goodbye!"
            exit 0
            ;;
        "")
            if [ -n "$choice" ]; then
                week=$(echo "$choice" | cut -d'|' -f2 | tr -d ' ')
                date_field=$(echo "$choice" | cut -d'|' -f3 | tr -d ' ')
                year=$(echo "$date_field" | cut -d'-' -f1)
                filename="week_${week}_${year}.R"
                if [ -e "$filename" ]; then
                echo "'$filename' already exists."
                exit 0
                fi

                echo "
library(tidyverse)
library(tidytuesdayR)
                

<<<<<<< HEAD
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
=======
tuesdata <- tt_load(${year}, ${week})
>>>>>>> bbec908 (updated install script)

list2env(tuesdata, envir = .GlobalEnv)

readme(tuesdata)
                
                " > "$filename"
                echo "✅ Created file: $filename"
                exit 0
            else
                echo "❌ No selection made. Goodbye!"
                exit 0
            fi
            ;;
    esac
done
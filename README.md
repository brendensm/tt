## tt -- A TidyTuesday Command Line Utility

This repo contains a simple script to streamline the creation of weekly TidyTuesday scripts.

To install the script with one line, run this in bash/zsh:

```
curl -sSL https://raw.githubusercontent.com/brendensm/tt/refs/heads/master/tt.sh -o /usr/local/bin/tt && chmod +x /usr/local/bin/tt
```

## Overview

By default, running tt will create a basic TidyTuesday script for the current year and week. A specific week can be specified in the first argument, and a specific year in the second. 

The basic shell of the script will look like this:

```
library(tidyverse)
library(tidytuesdayR)

tuesdata <- tt_load(2025, 24)

list2env(tuesdata, envir = .GlobalEnv)"
```
But please customize this to load in your desired packages.
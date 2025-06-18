## tt: A TidyTuesday Command Line Tool

This repo contains a simple script to streamline the creation of weekly TidyTuesday scripts.

To install the script with one line, run this in bash/zsh:

```
curl -sSL https://raw.githubusercontent.com/brendensm/tt/refs/heads/master/install.sh | bash
```

## Overview

By default, running tt will create a basic TidyTuesday script for the selected year and week. 

To use it, simply run the command 'tt'.

The basic shell of the script will look like this:

```
library(tidyverse)
library(tidytuesdayR)

tuesdata <- tt_load(2025, 24)

list2env(tuesdata, envir = .GlobalEnv)"

readme(tuesdata)
```
But please customize this to load in your desired packages.
# Global

# ---- Paquetes ----
library(tidyverse)
library(lubridate)
library(readxl)
library(scales)
library(shiny)
library(shinydashboard)
library(plotly)

# ---- Data ----
dbSuper <- read_csv('./data/dbSuper.csv', show_col_types = FALSE)

# ---- Shiny ----
#source('./R/modules.R')
source('ui.R')
source('server.R')

shinyApp(ui = ui, server = server)

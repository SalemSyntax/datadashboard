# Interactive Data Dashboard

An interactive Shiny dashboard that lets users upload CSV data files and explore the dataset through dynamic visualizations, summary statistics, and interactive tables.

---

## Features

- Upload any CSV file to analyze your data instantly
- Select columns for X-axis, Y-axis, and optional color grouping
- Choose plot types: Histogram, Boxplot, or Scatter plot
- Adjust plot parameters (e.g., number of bins for histograms)
- View data in an interactive paginated table
- See quick summary statistics of your dataset

---

## Demo

[Live Demo Link (if deployed)](https://your-shinyapps-url.shinyapps.io/data-dashboard)

---

## Getting Started

### Prerequisites

Make sure you have R installed (version 4.0 or higher recommended) along with the following R packages:

- shiny
- ggplot2
- DT
- dplyr
- readr

You can install them using:

```r
install.packages(c("shiny", "ggplot2", "DT", "dplyr", "readr", "rsconnect"))

```
## Navigate to the application

## Running the application

```
Rscript -e "shiny::runApp('.')"
```

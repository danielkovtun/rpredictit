---
output: 
  html_document: 
    df_print: tibble
    theme: lumen
---
# An R interface to the Predictit API
This package provides an interface to the Predictit public API (). License to use data made available via the API is for non-commercial use and PredictIt is the sole source of such data. In addition to providing a wrapper to retrieve market data, this package includes visualization and analysis functions.

## Installation

You may install the stable version from CRAN, or the development version using *remotes*:
```{r}
# install from CRAN
# install.packages('pRedictit')

# or the development version
# devtools::install_github('danielkovtun/predictit')
```

## Usage

To start off, try pRedictit::get_predictit_market_data() to return a tbl containing bid and ask data for all Predictit markets:

```{r}
library(pRedictit)
get_predictit_markets()
```

Alternatively, to return an interactive htmlwidget (DT::datatable) table containing HTML formatted market data:

```{r}
library(pRedictit)
get_predictit_markets_table()
```
![](README_files/figure-markdown_github/markets_table.png)

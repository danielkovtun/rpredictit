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
# A tibble: 1,096 x 20
      id name  shortName image url   timeStamp status contract_id dateEnd contract_image contract_name contract_shortN… contract_status
   <int> <chr> <chr>     <chr> <chr> <chr>     <chr>        <int> <chr>   <chr>          <chr>         <chr>            <chr>          
 1  2721 Whic… Which pa… http… http… 2019-12-… Open          4390 N/A     https://az620… Democratic    Democratic       Open           
 2  2721 Whic… Which pa… http… http… 2019-12-… Open          4389 N/A     https://az620… Republican    Republican       Open           
 3  2721 Whic… Which pa… http… http… 2019-12-… Open          4388 N/A     https://az620… Libertarian   Libertarian      Open           
 4  2721 Whic… Which pa… http… http… 2019-12-… Open          4391 N/A     https://az620… Green         Green            Open           
 5  2747 Will… Will Cub… http… http… 2019-12-… Open          4495 2020-1… https://az620… Will Mark Cu… Will Cuban run … Open           
 6  2875 Will… Will Cuo… http… http… 2019-12-… Open          5121 2020-1… https://az620… Will Andrew … Will Cuomo run … Open           
 7  2901 Will… Woman pr… http… http… 2019-12-… Open          5215 N/A     https://az620… Will a woman… Woman president… Open           
 8  2902 Will… Will the… http… http… 2019-12-… Open          5216 N/A     https://az620… Will the 202… Will the 2020 D… Open           
 9  2903 Will… Will the… http… http… 2019-12-… Open          5217 N/A     https://az620… Will the 202… Will the 2020 G… Open           
10  2992 Will… Will Zuc… http… http… 2019-12-… Open          5534 2020-1… https://az620… Will Faceboo… Will Zuckerberg… Open           
# … with 1,086 more rows, and 7 more variables: lastTradePrice <dbl>, bestBuyYesCost <dbl>, bestBuyNoCost <dbl>, bestSellYesCost <dbl>,
#   bestSellNoCost <dbl>, lastClosePrice <dbl>, displayOrder <int>
```

Alternatively, to return an interactive htmlwidget (DT::datatable) table containing HTML formatted market data:

```{r}
library(pRedictit)
get_predictit_markets_table()
```
![](README_files/figure-markdown_github/markets_table.png)

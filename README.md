# An R interface to the PredictIt API
This package provides an interface to the PredictIt public API (https://www.predictit.org/api/). License to use data made available via the API is for non-commercial use and PredictIt is the sole source of such data. In addition to providing a wrapper to retrieve market data, this package includes visualization and analysis functions.

## Installation

You may install the stable version from CRAN, or the development version using *devtools*:
```{r}
# install from CRAN
install.packages('predictit')

# or the development version, via devtools
devtools::install_github('danielkovtun/predictit')
```

## Usage

To start off, try predictit::all_markets() to return a tibble containing bid and ask data for all PredictIt markets:

```{r}
library(predictit)
all_markets()

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

To return data for a specific market, use `predictit::single_market(id)`, where `id` refers to the numerical code pertaining to the market of interest. 
You can find a market's numerical code by consulting its URL or by first calling the all markets API (`all_markets()`)
```{r}
library(predictit)
markets <- all_markets()
id <- markets$id[1]
single_market(id)

# A tibble: 4 x 20
     id name  shortName image url   timeStamp status contract_id dateEnd contract_image contract_name contract_shortN… contract_status lastTradePrice bestBuyYesCost bestBuyNoCost
  <int> <chr> <chr>     <chr> <chr> <chr>     <chr>        <int> <chr>   <chr>          <chr>         <chr>            <chr>                    <dbl>          <dbl>         <dbl>
1  2721 Whic… Which pa… http… http… 2019-12-… Open          4390 N/A     https://az620… Democratic    Democratic       Open                      0.53           0.53          0.48
2  2721 Whic… Which pa… http… http… 2019-12-… Open          4389 N/A     https://az620… Republican    Republican       Open                      0.49           0.49          0.52
3  2721 Whic… Which pa… http… http… 2019-12-… Open          4388 N/A     https://az620… Libertarian   Libertarian      Open                      0.02           0.03          0.98
4  2721 Whic… Which pa… http… http… 2019-12-… Open          4391 N/A     https://az620… Green         Green            Open                      0.02           0.03          0.98
# … with 4 more variables: bestSellYesCost <dbl>, bestSellNoCost <dbl>, lastClosePrice <dbl>, displayOrder <int>
```

Alternatively, to return an interactive htmlwidget (DT::datatable) table containing HTML formatted market data:

```{r}
library(predictit)
markets_table()
```
![](docs/markets_table.png)


See the full documentation at https://danielkovtun.github.io/predictit. 

#' @title Get bids and asks for all PredictIt markets
#' @description Wrapper function to get all available PredictIt markets and contract prices.
#'
#' @examples
#' markets <- all_markets()
#' markets
#'
#' @importFrom magrittr "%>%"
#' @export
all_markets <- function(){
  url <- "https://www.predictit.org/api/marketdata/all/"
  response <- tryCatch({
    r <- httr::GET(url)
    r <- jsonlite::fromJSON(rawToChar(r$content))
  },
    error = function(error_message) {
      return(NA)
    }
  )
  if(class(response) == "list"){
    markets <- r$markets %>% dplyr::as.tbl()

    market_contracts <- lapply(1:nrow(markets), function(x){
      market <- markets[x,] %>% dplyr::select(-contracts)

      contracts <- markets$contracts[[x]] %>%
        dplyr::rename(contract_id = "id") %>%
        dplyr::rename(contract_image = "image") %>%
        dplyr::rename(contract_name = "name") %>%
        dplyr::rename(contract_shortName = "shortName") %>%
        dplyr::rename(contract_status = "status")

      mc <- lapply(1:nrow(contracts), function(y){
        market %>% dplyr::bind_cols(contracts[y,])
      }) %>% dplyr::bind_rows()

      mc
    }) %>% dplyr::bind_rows()
    return(market_contracts)

  } else{
    cat("Error fetching PredictIt market data \nCheck your internet connection and try again \n")
    cat("Note: do not abuse the API by requesting data more than once every 60 seconds\n")
    return(response)
  }
}


#' @title Get bids and asks for a specific PredictIt market
#' @description Wrapper function to get data for a specific market.
#'
#' @param id Numerical code pertaining to the market. You can find a market's numerical code by consulting its URL or by first calling the all markets API.
#' @examples
#' markets <- all_markets()
#' id <- markets$id[1]
#' single_market(id)
#'
#' @importFrom magrittr "%>%"
#' @export
single_market <- function(id){
  base_url <- "https://www.predictit.org/api/marketdata/markets/"
  url <- paste0(base_url, id)

  r <- httr::GET(url)
  r <- jsonlite::fromJSON(rawToChar(r$content))

  contracts <- r$contracts

  r <- r[-which(names(r) == "contracts")]
  market <- dplyr::bind_rows(r)

  contracts <- contracts %>%
    dplyr::rename(contract_id = "id") %>%
    dplyr::rename(contract_image = "image") %>%
    dplyr::rename(contract_name = "name") %>%
    dplyr::rename(contract_shortName = "shortName") %>%
    dplyr::rename(contract_status = "status")

  contracts <- lapply(1:nrow(contracts), function(x){
    market %>% dplyr::bind_cols(contracts[x,])
  }) %>% dplyr::bind_rows()

  return(contracts)
}


create_hyperlinked_df <- function(links, titles) {
  df <- data.frame(matrix(ncol = 1, nrow = length(links)))
  if(nrow(df) > 0){
    colnames(df) <- "hyperlink"
    df$hyperlink <- paste0('<a href="', links, '" target="_blank">', titles, '</a>')
    return(df)
  }
  else{return(NA)}
}


#' @title Format bid and ask market data with HTML
#' @description Wrapper function to apply HTML formatting to PredictIt market data. Can be displayed in a shiny app, or standalone in an htmlwidget (e.g. DT::datatable).
#'
#' @param data PredictIt market data, of class data.frame or tibble, as returned by predictit::all_markets().
#' @examples
#' data <- all_markets()
#' format_market_data(data)
#'
#' @importFrom magrittr "%>%"
#' @export
format_market_data <- function(data){

  df <- create_hyperlinked_df(data$url, data$shortName)

  market_html <- lapply(1:length(data$image), function(i){
    htmltools::HTML(paste0("<img src='", data$image[i], "' width='50' height='50' />", '<br>', df$hyperlink[i]))
  }) %>% unlist()

  contract_html <- lapply(1:length(data$contract_image), function(x){
    cname <- data$contract_shortName[x]
    img <- data$contract_image[x]
    htmltools::HTML(paste0("<img src='", img, "' width='50' height='50' />", '<br>', cname))
  }) %>% unlist()

  data <- data %>%
    dplyr::select(-c("name", "shortName", "image", "url", "contract_image", "contract_name", "contract_shortName", "contract_status", "displayOrder"))
  data <- dplyr::bind_cols('contract' = contract_html, data)
  data <- dplyr::bind_cols('market' = market_html, data)
  data <- data %>%
    dplyr::mutate_if(is.character, trimws) %>%
    dplyr::mutate_at(dplyr::vars("timeStamp"), ~gsub("T", " ", .)) %>%
    dplyr::mutate_at(dplyr::vars("timeStamp"), ~as.POSIXct(strptime(., format = "%Y-%m-%d %H:%M:%OS", tz = "EST")))


  return(data)
}


#' @title Get JavaScript datatable containing bids and asks for all PredictIt markets
#' @description Wrapper function to return a DT::datatable containing PredictIt market data. Can be displayed in a shiny app, RMarkdown document, or exported via htmlwidgets::saveWidget.
#'
#' @examples
#' markets_table()
#'
#' @importFrom magrittr "%>%"
#' @export
markets_table <- function(){
  data <- format_market_data(all_markets())
  data <- data %>%
    dplyr::mutate(Yes = paste0(data$bestBuyYesCost, " / ",  data$bestSellYesCost)) %>%
    dplyr::mutate(No = paste0(data$bestBuyNoCost, " / ",  data$bestSellNoCost)) %>%
    dplyr::select(
      c("market",
        "contract",
        "Yes",
        "No",
        "lastTradePrice",
        "lastClosePrice",
        "dateEnd",
        "timeStamp",
        "id",
        "contract_id",
        "status"
        )
      )

  colnames(data) <- c(
    'Market', 'Contract',
    'Yes (Bid/Ask)',
    'No (Bid/Ask)',
    'Last Trade Price',
    'Last Close Price',
    'Expiry',
    'Timestamp',
    'Market id', 'Contract id',
    'Status'
    )
  DT::datatable(data,
                class ='cell-border stripe',
                escape = F,
                rownames = F,
                extensions = 'Scroller',
                options = list(
                  autoWidth = TRUE,
                  deferRender = TRUE,
                  scrollY = 400,
                  scrollX = T,
                  scroller = TRUE,
                  columnDefs = list(
                    list(width = '10%', targets = list(2, 3, 4, 5))
                  )
                ))
}

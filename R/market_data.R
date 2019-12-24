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
    markets <- markets %>%
      dplyr::mutate_if(is.character, trimws) %>%
      dplyr::mutate_at(dplyr::vars("timeStamp"), ~gsub("T", " ", .)) %>%
      dplyr::mutate_at(dplyr::vars("timeStamp"), ~as.POSIXct(strptime(., format = "%Y-%m-%d %H:%M:%OS", tz = "EST")))


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


#' @title Get bids and asks for all PredictIt "Tweet" markets
#' @description Wrapper function to get all available PredictIt "Tweet count" markets and contract prices.
#'
#' @examples
#' tweet_markets()
#'
#' @importFrom magrittr "%>%"
#' @export
tweet_markets <- function(){
  markets <- all_markets()
  tweet <- markets %>%
    dplyr::filter_at(dplyr::vars("name"), ~stringr::str_detect(., 'tweet'))

  return(tweet)
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
  market <- dplyr::bind_rows(r) %>%
    dplyr::mutate_if(is.character, trimws) %>%
    dplyr::mutate_at(dplyr::vars("timeStamp"), ~gsub("T", " ", .)) %>%
    dplyr::mutate_at(dplyr::vars("timeStamp"), ~as.POSIXct(strptime(., format = "%Y-%m-%d %H:%M:%OS", tz = "EST")))


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
#' @param data PredictIt market data, of class data.frame or tibble, as returned by predictit::all_markets() or predictit::tweet_markets()
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

  return(data)
}


#' @title Get JavaScript datatable containing bids and asks for all PredictIt markets
#' @description Wrapper function to return a DT::datatable containing PredictIt market data. Can be displayed in a shiny app, RMarkdown document, or exported via htmlwidgets::saveWidget.
#'
#' @param data PredictIt market data, of class data.frame or tibble, as returned by predictit::all_markets() or predictit::tweet_markets()
#'
#' @examples
#' data <- all_markets()
#' markets_table(data)
#'
#' @importFrom magrittr "%>%"
#' @export
markets_table <- function(data){
  data <- format_market_data(data)
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

#' @title Parse csv file containing historical OHLCV data
#' @description Helper function to parse a csv file obtained from the PredictIt website, containing historical OHLCV data, into an object of class xts.
#'
#' @param csv_path Path to a csv file containing historical OHLCV data for a specific contract (Open, High, Low, Close, Volume)
#' @param filename Optional name to give the csv file when the filepath is derived from a temporary directory
#'
#' @examples
#' filename <- "What_will_be_the_balance_of_power_in_Congress_after_the_2020_election.csv"
#' csv_path <- system.file("extdata", filename, package = "predictit")
#' parse_historical_csv(csv_path)
#'
#' @importFrom magrittr "%>%"
#' @importFrom xts "as.xts"
#' @importFrom quantmod "Cl"
#' @importFrom utils "read.csv"
#' @export
parse_historical_csv <- function(csv_path, filename = NA){
  ohlcv <- tryCatch({
    read.csv(csv_path, stringsAsFactors = F)
  },
    error = function(error_message) {
      return(NA)
    }
  )

  if(is.na(filename)){
    filename <- csv_path
  }

  filename <- gsub("\\.csv", "", basename(filename))
  filename <- gsub("_", " ", filename)

  if(class(ohlcv) == "data.frame"){
    colnames(ohlcv) <- c("contract", "date", "open", "high", "low", "close", "volume")

    ohlcv <- ohlcv %>%
      dplyr::as.tbl() %>%
      dplyr::mutate_if(is.character, trimws) %>%
      dplyr::mutate_at(dplyr::vars("open", "high", "low", "close"), ~as.numeric(gsub("\\$", "", .))) %>%
      dplyr::mutate_at(dplyr::vars("date"), ~as.POSIXct(strptime(., tz = "EST", format = "%m/%d/%Y %H:%M"))) %>%
      as.data.frame() %>%
      dplyr::group_by(ohlcv$contract)

    contracts <- unique(as.character(ohlcv$contract))

    ohlcv <- dplyr::group_split(ohlcv)


    xts_list <- lapply(1:length(ohlcv), function(x){
      dat <- ohlcv[[x]] %>% as.data.frame()

      rownames(dat) <- dat$date
      dat <- dat %>% dplyr::select(-c("contract", "date"))
      colnames(dat) <- c("Open", "High", "Low", "Close", "Volume")
      xts::as.xts(dat)
    })

    names(xts_list) <- contracts

    data <- do.call(merge, lapply(xts_list, function(x) quantmod::Cl(x)))

    colnames(data) <- contracts

    return(list('data' = data, 'contract' = filename))

  } else{
    cat("Error parsing csv for PredictIt market data \n")
    cat("Check that the file path is correct and the format is consistent with the csv file obtained from the PredictIt website.\n")
    return(ohlcv)
  }
}

#' @title Plot historical contract data obtained from the PredictIt website
#' @description FUnction to make an interactive dygraph plot of historical contract data.
#'
#' @param contract_data Named list containing contract name and data of class xts, as returned by predictit::parse_historical_csv()
#'
#' @examples
#' filename <- "What_will_be_the_balance_of_power_in_Congress_after_the_2020_election.csv"
#' csv_path <- system.file("extdata", filename, package = "predictit")
#' contract_data <- parse_historical_csv(csv_path)
#' historical_plot(contract_data)
#'
#' @importFrom magrittr "%>%"
#' @importFrom dygraphs "dyHighlight"
#' @export
historical_plot <- function(contract_data){
  dygraphs::dygraph(
    contract_data$data,
    main = contract_data$contract,
    group = "contract"
  ) %>%
    dyHighlight(
      highlightCircleSize = 5,
      highlightSeriesBackgroundAlpha = 0.2,
      hideOnMouseOut = T
    )
}

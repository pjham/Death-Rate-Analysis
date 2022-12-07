library(httr)
library(jsonlite)
#Using API to extract data from WHO website
res <- GET("https://ghoapi.azureedge.net/api/Indicator?$filter=contains(IndicatorName,%20%27Death%27)")
data <- res$content
data <- rawToChar(data)
data <- fromJSON(data)
indiNames <- as.data.frame(data[["value"]][["IndicatorName"]])
save(data,file="Raw data/data.Rdata")
# indiNames contains topic headings regarding which data is available to extract, we have filtered it contain the word 'death'
extractData <- function(n)
{
  link <- paste0("https://ghoapi.azureedge.net/api/",data[["value"]][["IndicatorCode"]][n])
  indiRes <- GET(link)
  indiData <- fromJSON(rawToChar(indiRes$content))
  df <- data.frame(indiData$value$SpatialDim,indiData$value$TimeDim,indiData$value$NumericValue)
  colnames(df) <- c("Country Code","Year","Value")
  return(indiData)
}
#extractData function extracts data for indicator name whose serial number is n
viewCC <- function()
{
  ccres <- GET("https://ghoapi.azureedge.net/api/DIMENSION/COUNTRY/DimensionValues")
  ccdata <- ccres$content
  ccdata <- rawToChar(ccdata)
  ccdata <- fromJSON(ccdata)
  df <- data.frame(ccdata$value)
  return(df)
}# thic function shows country codes and countries
#indices of relatable data are stored in i
i <- array(c(13,20,22,29,32,39,41,49,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,72,73,74,75,76,78,85,91,94,95,97,103,109,112,113,120))
for (x in i)
{
  extracted <- extractData(x)
  save(extracted,file = paste0(data[["value"]][["IndicatorCode"]][x],".Rdata"))
}  
#relatable data extracted and saved using the loop


## code to prepare `GDPEEUU` dataset goes here

usethis::use_data(GDPEEUU, overwrite = TRUE)

if (!require(httr)) install.packages("httr", dependencies = TRUE)
if (!require(readxl)) install.packages("readxl", dependencies = TRUE)
if (!require(zoo)) install.packages("zoo", dependencies = TRUE)
if (!require(xts)) install.packages("xts", dependencies = TRUE)

library(httr)
library(readxl)
suppressPackageStartupMessages(library(zoo))
library(xts)

file_url <- "https://fred.stlouisfed.org/graph/fredgraph.xls?bgcolor=%23e1e9f0&chart_type=line&drp=0&fo=open%20sans&graph_bgcolor=%23ffffff&height=450&mode=fred&recession_bars=on&txtcolor=%23444444&ts=12&tts=12&width=1138&nt=0&thu=0&trc=0&show_legend=yes&show_axis_titles=yes&show_tooltip=yes&id=GDP&scale=left&cosd=1947-01-01&coed=2024-04-01&line_color=%234572a7&link_values=false&line_style=solid&mark_type=none&mw=3&lw=2&ost=-99999&oet=99999&mma=0&fml=a&fq=Quarterly&fam=avg&fgst=lin&fgsnd=2020-02-01&line_index=1&transformation=lin&vintage_date=2024-07-30&revision_date=2024-07-30&nd=1947-01-01"
response <- GET(file_url)
temp_file <- tempfile(fileext = ".xls")
writeBin(content(response, "raw"), temp_file)
data <- read_excel(temp_file)
data <- data[-c(1:10),-1]
colnames(data) <- "GDP"
start_date <- as.Date("1947-01-01")
end_date <- Sys.Date()
date <- seq(from = start_date, to = end_date, by = "3 months")
date <- date[-length(date)]
rownames(data) <- date
data <- cbind(Date = rownames(data), GDP = data$GDP)
unlink(temp_file)
write.csv(data,"data-raw/GDPEEUU.csv",row.names = FALSE)
df_GDPEEUU <- read.csv("data-raw/GDPEEUU.csv", sep = ",", header = T)
df_GDPEEUU$Date <- as.Date(df_GDPEEUU$Date)
GDPEEUU <- xts(df_GDPEEUU$GDP, order.by = df_GDPEEUU$Date)
colnames(GDPEEUU) <- "GDP"

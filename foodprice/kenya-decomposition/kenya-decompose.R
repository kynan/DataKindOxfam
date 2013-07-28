raw_ken <- read.csv('data/Kenya (without comma).csv', as.is=TRUE)
raw_ken_rows_nb <- length(raw_ken[,1])

# remove headers (5 lines)
ken <- raw_ken[-(1:5),]

# renaming columns
colnames(ken)[c(3, 4)] <- c("Month", "Year")

# reformat, and convert before plotting
ken$Date <- as.Date(paste0("01", "-", ken$Month, "-", ken$Year), format="%d-%m-%Y")

plotColumn <- function(colnb) {
	colname <- paste0("Kenya.", colnb)
	colvals <- as.numeric(ken[[colname]])
	
	# R expert : find better way to concat plz
	titl = paste0(raw_ken[1, colname], " - ", raw_ken[2, colname], " - ", raw_ken[3, colname], " - ", raw_ken[4, colname], " - ", raw_ken[5, colname])
	
	# actual plotting
	plot(ken$Date, colvals, type="l", xlab = "Date", ylab = paste0("Price - ", raw_ken[5, colname]))
	title(paste0("Kenya : ", titl))	
}

getColname <- function(colnb) { 
	paste0("Kenya.", colnb) 
}

decomposeColumn <- function(colnb) {
	vals <- as.numeric(ken[[getColname(colnb)]]) 
	col_ts <- ts(vals[!is.na(vals)], frequency=12, start=c(2000,1), end=c(2012,9))	
	col_dec <- decompose(col_ts)
	plot(col_dec)
	col_dec
}

for(i in 1:48) {
	plotColumn(i)
	decomposeColumn(i)
}

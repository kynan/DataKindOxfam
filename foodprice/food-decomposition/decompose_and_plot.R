library(data.table)

raw_food_prices <- read.csv('data/Oxfam_05July2013_concatenated_and_normalized_to_USD.csv', as.is=TRUE)

# full data table of all Food Prices (USD per tonne) by Price.Type, Country, Market, Commodity and Original Currency (not useful)
data_table <- data.table(raw_food_prices)

# Do your shopping (e.g: Price.Type=ALL, Country="Kenya", Market="ALL", Commodity="Maize")
selection <- data_table[Country=="Kenya"][Commodity=="Maize"] # CHANGE THIS LINE AS YOU WISH

# Next we need to aggregate properly

# Let's aggregate and compute the mean over ALL Price.Types, ALL Markets
agg <- aggregate(selection$USD.per.tonne, by=unique(list(selection$Date)), FUN=mean) # CHANGE THE FUN IF NEEDED HERE ALSO

# Note (for above line): 
# 	We should probably use a WEIGHTED MEAN instead of MEAN when aggregating over prices, 
#	because each commodity is sold in different quantity in the markets
#	But to do so, we need extra data : quantity sold for each type of food

# remove NAs after aggregation, meaning a line is removed if MEAN could not be computed because at least one NA was encountered when trying to compute the MEAN
agg_narm <- na.omit(agg)

# add proper Date column
agg_narm$Date <- as.Date(paste0("01", "-", agg_narm$Group.1), format="%d-%y-%b")

# sort by the Date column for plotting, decomposition, etc...
sorted <- agg_narm[order(agg_narm$Date),]

# compute the ts
start_date <- sorted$Date[1]

start_month <- as.numeric(format(start_date, "%m"))
start_year <- as.numeric(format(start_date, "%Y"))

final_ts <- ts(sorted$x, frequency=12, start=c(start_year, start_month))

# decompose the ts
dec <- decompose(final_ts)

# finally, plot the decomposition
plot(dec)
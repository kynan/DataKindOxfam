# DataKind kackathon 27 July 2013
# Derek Jones

# Note for future events:

#   o Provide data in csv format


# Kenya data by cities, each with own specific crops

# Election causes uncertainty, results in large fluctuations in prices.



# Take Oxfam data (after conversion from xls ro csv)
# 

librray(plyr)

raw_ken=read.csv("c:/web/Kenya.csv", as.is=TRUE)
# raw_ken$Country=as.Date(paste0("01-", raw_ken$Country), format="%d-%b-%y")

ken=raw_ken[-(1:5), ]

# Date is missing a day-of-month, so assume 1st of the mont
ken$Country=as.Date(paste0("01-", ken$Country), format="%d-%b-%y")

plot(ken$Country, ken$Kenya.1)


# Create dataframe with columns containing price, commodity, location, units
map_col=function(df)
{
#print(str(df))
t=data.frame(q=df[-(1:5), 1])
# print(t)
names(t)="price"
t$commodity=df[2, 1]
t$location=df[1, 1]
t$units=df[4, 1]
t$date=ken$Country

return(t)
}


# tk=raw_ken[, -(1:5)]

kenmap=adply(raw_ken[, -(1:5)], 2, map_col)

# Clean things up
kenmap$X1=NULL

write.csv(kenmap, file="c:/web/ken_data.csv", row.names=FALSE)



# Various data cleaning on Country retail data

librray(plyr)

ret=read.csv("c:/web/oxfam-retail.csv", as.is=TRUE)
ret$Price.Type=NULL
ret$Date=paste0("01-", ret$Date)

q=aaply(ret$Commodity.full, 1, function(df) strsplit(df, " ")[[1]][1])
ret$Commodity=q

write.csv(ret, file="c:/web/country-food.csv", row.names=FALSE)


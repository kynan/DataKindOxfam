# Food Decomposition

This subfolder is about decomposing any food prices found in the _data/Oxfam_05July2013_concatenated_and_normalized_to_USD.csv_ file

The goal here is to allow OxfamGB to be able to decompose a timeserie for whatever commodity, market, country etc...

## R Code

It's also possible to aggregate and decompose the timeserie of Maize Prices in Kenya for ALL Markets and ALL price type (Export, Retail, etc...)

Only line 9 of the _decompose_and_plot.R_ function has to be edited to match their need.

Example : 

This will aggregate over all Price.Type, all markets. Using the MEAN function for aggregation (see code)
One (bad) appoximation is to use the mean, and not a weighted mean when aggregating because a MEAN prices depends on the quantity sold in each market to weight the mean. So take this into consideration.

It would be nice to have the quantity sold for each market to prevent this (bad ?) approximation from happening

```
selection <- data_table[Country=="Kenya"][Commodity=="Maize"]
```

## Usage

This command will output Rplots.pdf if script run successfully
Console output is in file _decompose_and_plot.Rout_

```
R CMD BATCH decompose_and_plot.R
```

or just copy paste the code in RStudio or RConsole given your working directory is this subfolder...



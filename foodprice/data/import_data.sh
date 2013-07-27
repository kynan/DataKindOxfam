#!/bin/bash

# Import the Kenya food price data into a MongoDB database

# Requires the following environment variables to be set (exported):
# DB_HOST - MongoDB server host name or IP address
# DB_PORT - MongoDB server port
# DB_NAME - MondoDB database name
# DB_USER - MongoDB user name
# DB_PASS - MongoDB password

mongoimport -u $DB_USER -p $DB_PASS -h $DB_HOST:$DB_PORT -d $DB_NAME \
  -c kenya_foodprice --type csv --headerline --file ken_geodata.csv 
mongo $DB_HOST:$DB_PORT/$DB_NAME -u $DB_USER -p $DB_PASS process_fields.js

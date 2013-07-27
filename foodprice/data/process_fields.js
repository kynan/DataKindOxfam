// Convert the date field to a Date object and add a location field
db.kenya_foodprice.find().forEach( function(doc) {
  db.kenya_foodprice.update({_id: doc._id},
                            {$set: {date: ISODate(doc.date),
                                    location: [doc.lon, doc.lat]}});
});
// Create a 2d geospatial index on the location field
db.kenya_foodprice.ensureIndex({location: '2d'});

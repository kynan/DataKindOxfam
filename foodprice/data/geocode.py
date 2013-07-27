#!/usr/bin/env python

"""
Geocode the locations of the location column.

  Usage: geocode.py infile.csv outfile.csv
"""

from csv import DictReader, DictWriter
from pygeocoder import Geocoder

_locations = {}


def geocode(location):
    """Geolocate a given location using Google's geocoding API and return the
    coordinates."""
    # We don't want to call the API if we have already looked up this location
    # before, so we check the cache first
    if location in _locations:
        return _locations[location]
    # We're only interested in the coordinates of the first result for now
    loc = _locations[location] = Geocoder.geocode(location)[0].coordinates
    return loc


def process(row):
    row['lat'], row['lng'] = geocode(row['location'])
    return row


def main(infile, outfile):
    with open(infile) as inf, open(outfile, 'w') as outf:
        r = DictReader(inf)
        rows = [process(row) for row in r]
        w = DictWriter(outf, fieldnames=rows[0].keys())
        w.writeheader()
        w.writerows(rows)


if __name__ == '__main__':
    import sys
    if len(sys.argv) < 3:
        print __doc__
        sys.exit(1)
    main(sys.argv[1], sys.argv[2])

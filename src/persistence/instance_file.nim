#[
Loads a TSP instance from a file.

The instance file contains city identifiers separated by commas. This module
maps those identifiers to their corresponding City objects and returns the
resulting sequence of cities.
]#

import strutils
import ../models/city


#[
Reads a TSP instance from the given file path and builds the corresponding
sequence of cities using the provided city collection.
]#
proc loadInstance*(path: string, cities: seq[City]): seq[City] =
    let content = readFile(path).strip()
    let values = content.split(",")

    result = newSeq[City](values.len)

    for i in 0 ..< values.len:
        let cityId = parseInt(values[i].strip())
        result[i] = cities[cityId - 1]
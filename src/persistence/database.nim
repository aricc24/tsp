#[
Provides access to the TSP database.

This module retrieves cities and connections from the SQLite database
and converts the query results into the corresponding data structures.
]#

import db_connector/db_sqlite
import ../models/city 
import ../models/connection
import std/strutils

#[
Retrieves all cities stored in the database.

Returns a sequence of City objects containing their identifiers,
descriptive information, population, and geographic coordinates.
]#
proc getCities*(databasePath: string): seq[City] =
    let db = open(databasePath, "", "", "")
    defer: db.close()

    let rows = db.getAllRows(
        sql"SELECT id, name, country, population, latitude, longitude FROM cities"

    )

    var cities = newSeq[City](rows.len)

    for i in 0 ..< rows.len:
        let row = rows[i]
        cities[i] = City(
            id: parseInt(row[0]),
            name: row[1], 
            country: row[2], 
            population: parseInt(row[3]), 
            latitude: parseFloat(row[4]), 
            longitude: parseFloat(row[5])
        )

    return cities


#[
Retrieves all connections stored in the database.

Returns a sequence of Connection objects containing the identifiers
of the connected cities and the distance between them.
]#
proc getConnections*(databasePath: string): seq[Connection] =
    let db = open(databasePath, "", "", "")
    defer: db.close()

    let rows = db.getAllRows(
        sql"SELECT id_city_1, id_city_2, distance FROM connections"
    )

    var connections = newSeq[Connection](rows.len)

    for i in 0 ..< rows.len:
        let row = rows[i]
        connections[i] = Connection(
            city1Id: parseInt(row[0]),
            city2Id: parseInt(row[1]), 
            distance: parseFloat(row[2])
        )

    return connections
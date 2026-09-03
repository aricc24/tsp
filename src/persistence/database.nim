import db_connector/db_sqlite
import ../models/city 
import ../models/connection
import std/strutils

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
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

    var cities: seq[City] = @[]

    for row in rows: 
        let city = City(
            id: parseInt(row[0]),
            name: row[1], 
            country: row[2], 
            population: parseInt(row[3]), 
            latitude: parseFloat(row[4]), 
            longitude: parseFloat(row[5])
        )

        cities.add(city)

    return cities

proc getConnections*(databasePath: string): seq[Connection] =
    let db = open(databasePath, "", "", "")
    defer: db.close()

    let rows = db.getAllRows(
        sql"SELECT id_city_1, id_city_2, distance FROM connections"
    )

    var connections: seq[Connection] = @[]

    for row in rows: 
        let connection = Connection(
            city1Id: parseInt(row[0]),
            city2Id: parseInt(row[1]), 
            distance: parseFloat(row[2])
        )

        connections.add(connection)

    return connections
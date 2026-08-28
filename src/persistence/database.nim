import db_connector/db_sqlite
import ../models/city 
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
import db_connector/db_sqlite
import ../models/city 

proc getCities*(databasePath: string): seq[City] =
    let db = open(databasePath, "", "", "")
    defer: db.close()

    let rows = db.getAllRows(
        sql"SELECT id, name, country, population, latitude, longitude FROM cities"

    )

    for row in rows:
        echo row
    
    return @[]
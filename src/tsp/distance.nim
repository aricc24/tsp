import std/math
import ../models/city

const EarthRadius = 6_373_000.0

proc degreesToRadians(degrees: float): float =
    return degrees * PI / 180.0

proc naturalDistance*(u: City, v: City): float =
    let latU = degreesToRadians(u.latitude)
    let longU = degreesToRadians(u.longitude)
    let latV = degreesToRadians(v.latitude)
    let longV = degreesToRadians(v.longitude)

    let deltaLat = latV - latU
    let deltaLong = longV - longU

    let a = sin(deltaLat / 2.0)^2 + cos(latU) * cos(latV) * sin(deltaLong / 2.0)^2
    let c = 2.0*arctan2(sqrt(a), sqrt(1.0 - a ))

    return EarthRadius * c


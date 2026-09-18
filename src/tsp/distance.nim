#[
Provides geographic distance utilities for cities.

This module converts geographic coordinates from degrees to radians and
computes the natural distance between two cities using the Haversine formula.
]#
import std/math
import ../models/city

const EarthRadius = 6_373_000.0


#[
Converts an angle from degrees to radians.
]#
proc degreesToRadians(degrees: float): float =
    return degrees * PI / 180.0


#[
Calculates the natural distance between two cities using their geographic
coordinates and the Haversine formula.
]#
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


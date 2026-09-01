import unittest
import ../src/models/city
import ../src/tsp/distance
#import ../src/persistence/database
import std/math

const Epsilon = 1e-7

suite "Natural Distance": 

  test "Natural Distance between a city and itself": 
    let city = City(
      id: 1, 
      name: "CityA",
      country: "X", 
      population: 0, 
      latitude: 19.4326,
      longitude: -99.1332
    )
    
    let result = naturalDistance(city, city)

    check abs(result) <= Epsilon
  
  test "Natural distance for a quarter of the equator":
    let cityA = City(
      id: 1, 
      name: "A",
      country: "X",
      population: 0,
      latitude: 0.0,
      longitude: 0.0
    )

    let cityB = City( 
      id: 2,
      name: "B",
      country: "X",
      population: 0,
      latitude: 0.0,
      longitude: 90.0
    )

    let result = naturalDistance(cityA, cityB)
    let expected = 6_373_000.0 * PI / 2.0

    check abs(result - expected) <= Epsilon

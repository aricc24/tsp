import unittest
import ../src/models/city
import ../src/tsp/distance
#import ../src/persistence/database


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

  



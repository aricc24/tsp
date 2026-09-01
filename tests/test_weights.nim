import unittest
import std/math
import ../src/models/connection
import ../src/models/city
import ../src/tsp/weights

const Epsilon = 1e-7

suite "Maximum Distance":

    test "Returns the largest connection inside the instance":
        let cities = @[
            City(id:1, name:"A"), 
            City(id:2, name:"B"), 
            City(id:3, name:"C")
        ]

        let connections = @[
            Connection(
                city1Id: 1, 
                city2Id: 2, 
                distance: 100.0
            ), 
            Connection(
                city1Id: 1, 
                city2Id: 3, 
                distance: 300.0
            ),
            Connection(
                city1Id: 2, 
                city2Id: 3, 
                distance: 200.0
            )
        ]

        let result = maximumDistance(cities, connections)
        let expected = 300.0

        check abs(result - expected) <= 0
    
    test "Ignores connections with citues outside the instance": 
        let cities = @[
            City(id:1, name:"A"), 
            City(id:2, name:"B"), 
            City(id:3, name:"C")
        ]

        let connections = @[
            Connection(
                city1Id: 1, 
                city2Id: 2, 
                distance: 100.0
            ), 
            Connection(
                city1Id: 2, 
                city2Id: 3, 
                distance: 777.0
            ),
            Connection(
                city1Id: 1, 
                city2Id: 99, 
                distance: 1000.0
            )
        ]

        let result = maximumDistance(cities, connections)
        let expected = 777.0

        check abs(result - expected) <= 0

    
    test "Returns the distance when there is one valid connection": 
        let cities = @[
            City(id:1, name:"A"), 
            City(id:2, name:"B")
        ]

        let connections = @[
            Connection(
                city1Id: 1, 
                city2Id: 2, 
                distance: 67.0
            )
        ]

        let result = maximumDistance(cities, connections)
        let expected = 67.0

        check abs(result - expected) <= 0

    
    test "Returns zero when there are no valid connections": 
        let cities = @[
            City(id:1, name:"A"), 
            City(id:2, name:"B")
        ]

        let connections = @[
            Connection(
                city1Id: 3, 
                city2Id: 4, 
                distance: 2411.0
            )
        ]

        let result = maximumDistance(cities, connections)
        let expected = 0.0

        check abs(result - expected) <= 0









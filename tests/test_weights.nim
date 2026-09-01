import unittest
import std/math
import ../src/models/connection
import ../src/models/city
import ../src/models/graph
import ../src/tsp/weights
import ../src/tsp/distance

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

suite "Augmented Weight":

    test "Returns original weight when connection exits": 
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

        let graph = Graph(
            adjacencyMatrix: @[
                @[0.0, 100.0], 
                @[100.0, 0.0]
            ]
        )

        let maxDist = 500.0

        let result = augmentedWeight(cityA, cityB, graph, maxDist)
        let expected = 100.0

        check abs(result - expected) <= 0
    

    test "Uses natural distance times maximum distance when connection does not exists": 
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

        let graph = Graph(
            adjacencyMatrix: @[
                @[0.0, 0.0], 
                @[0.0, 0.0]
            ]
        )

        let maxDist = 500.0
        let expected = naturalDistance(cityA, cityB) * maxDist
        let result = augmentedWeight(cityA, cityB, graph, maxDist)

        check abs(result - expected) <= 0


suite "Normalizer": 
    test "Sums the largest n minus one weight": 
        let cities = @[
            City(id:1), 
            City(id:2), 
            City(id:3), 
            City(id:4)
        ]

        let graph = Graph(
            adjacencyMatrix: @[
                @[0.0, 100.0, 400.0, 50.0],
                @[100.0, 0.0, 300.0, 200.0],
                @[400.0, 300.0, 0.0, 250.0],
                @[50.0, 200.0, 250.0, 0.0]
            ]
        )

        let result = normalizer(cities, graph)
        let expected = 950.0 

        check abs(result - expected) <= 0

    test "Ignores missing connections": 
        let cities = @[
            City(id:1), 
            City(id:2), 
            City(id:3)
        ]

        let graph = Graph(
            adjacencyMatrix: @[
                @[0.0, 100.0, 0.0],
                @[100.0, 0.0, 250.0],
                @[0.0, 250.0, 0.0]
            ]
        )

        let result = normalizer(cities, graph)
        let expected = 350.0

        check abs(result - expected) <= 0

    
    test "Slects the largest weights regardless of their order":
        let cities = @[
            City(id:1), 
            City(id:2), 
            City(id:3), 
            City(id:4)
        ]

        let graph = Graph(
            adjacencyMatrix: @[
                @[0.0, 10.0, 500.0, 20.0],
                @[10.0, 0.0, 300.0,40.0],
                @[500.0, 300.0, 0.0, 200.0],
                @[20.0,40.0, 200.0, 0.0]
            ]
        )

        let result = normalizer(cities, graph)
        let expected = 1000.0 

        check abs(result - expected) <= 0






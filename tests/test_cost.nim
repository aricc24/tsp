import unittest
import ../src/models/city
import ../src/models/graph
import ../src/tsp/cost
import ../src/tsp/distance


const Epsilon = 1e-7

suite "Cost": 

    test "Compute cost using existing connections": 
        let path = @[
            City(id:1), 
            City(id:2), 
            City(id:3)
        ]

        let graph = Graph(
            adjacencyMatrix: @[
                @[0.0, 100.0, 0.0],
                @[100.0, 0.0, 200.0],
                @[0.0, 200.0, 0.0]
            ]
        )

        let maxDist = 200.0
        let norm = 300.0

        let result = cost(path, graph, maxDist, norm)
        let expected = 1.0

        check abs(result - expected) <= Epsilon

    test "Uses augmented weight for missimg conections": 
        let path = @[
            City(
                id: 1, 
                latitude: 0.0, 
                longitude: 0.0
            ),
            City(
                id: 2, 
                latitude: 0.0, 
                longitude: 90.0
            )
        ]

        let graph = Graph(
            adjacencyMatrix: @[
                @[0.0, 0.0], 
                @[0.0, 0.0]
            ]        
        )

        let maxDist = 2.0
        let norm = 10.0

        let expected = (naturalDistance(path[0], path[1]) * maxDist) / norm
        let result = cost(path, graph, maxDist, norm)
        check abs(result - expected) <= 0
    
    test "Does not add an edge from last city back to fist": 
        let path = @[
            City(id:1),
            City(id:2), 
            City(id:3)
        ]

        let graph = Graph(
            adjacencyMatrix: @[
                @[0.0, 100.0, 1000.0],
                @[100.0, 0.0, 200.0],
                @[1000.0, 200.0, 0.0]
            ]
        )
        
        let maxDist = 1000.0
        let norm = 300.0

        let expected = 1.0
        let result = cost(path, graph, maxDist, norm)

        check abs(result - expected) <= Epsilon



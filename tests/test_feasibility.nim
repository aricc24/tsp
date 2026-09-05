import unittest
import ../src/models/city
import ../src/models/graph
import ../src/tsp/feasibility


suite "Feasibility":

    test "Returns true when all consecutive connections exist":
        let graph = Graph(
            adjacencyMatrix: @[
                @[0.0, 100.0, 0.0],
                @[100.0, 0.0, 200.0],
                @[0.0, 200.0, 0.0]
            ]
        )

        let path = @[
            City(id: 1),
            City(id: 2),
            City(id: 3)
        ]

        check isFeasible(path, graph) 

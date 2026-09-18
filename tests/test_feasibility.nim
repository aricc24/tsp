#[
Tests the feasibility verification of TSP paths.

The tests verify that a path is considered feasible when all consecutive
cities are connected and infeasible when at least one required connection
is missing.
]#

import unittest
import ../src/models/graph
import ../src/tsp/feasibility
import ../src/models/matrix

#[
Test suite for TSP path feasibility.

It checks both feasible paths with all required connections and infeasible
paths containing a missing connection.
]#
suite "Feasibility":

    test "Returns true when all consecutive connections exist":
        let graph = Graph(
            adjacencyMatrix: toMatrix(@[
                @[0.0, 100.0, 0.0],
                @[100.0, 0.0, 200.0],
                @[0.0, 200.0, 0.0]
            ])
        )

        let path = @[0, 1, 2]

        check isFeasible(path, graph) 
    
    test "Returns false when a consecutive connection is missing":
        let graph = Graph(
            adjacencyMatrix: toMatrix(@[
                @[0.0, 100.0, 0.0],
                @[100.0, 0.0, 0.0],
                @[0.0, 0.0, 0.0]
            ])
        )

        let path = @[0, 1, 2]

        check not isFeasible(path, graph)
#[
Provides feasibility verification for TSP solutions.

This module checks whether every consecutive pair of cities in a path
is connected by an edge in the original graph.
]#

import ../models/graph
import ../models/matrix

#[
Checks whether a path is feasible by verifying that every consecutive
pair of cities has a connection in the graph.

Returns true if the complete path is feasible, and false otherwise.
]#
proc isFeasible*(path: seq[int], graph: Graph): bool =
    
    for i in 1 ..< path.len: 
        let u = path[i - 1]
        let v = path[i]

        if graph.adjacencyMatrix[u, v] == 0.0: 
            return false 

    return true


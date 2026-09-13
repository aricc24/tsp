import ../models/graph
import ../models/matrix

proc isFeasible*(path: seq[int], graph: Graph): bool =
    
    for i in 1 ..< path.len: 
        let u = path[i - 1]
        let v = path[i]

        if graph.adjacencyMatrix[u, v] == 0.0: 
            return false 

    return true


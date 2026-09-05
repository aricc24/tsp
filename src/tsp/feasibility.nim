import ../models/city
import ../models/graph

proc isFeasible*(path: seq[City], graph: Graph): bool =
    
    for i in 1 ..< path.len: 
        let u = path[i - 1]. id - 1
        let v = path[i]. id - 1

        if graph.adjacencyMatrix[u][v] == 0.0: 
            return false 

    return true


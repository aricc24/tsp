import ../models/city
import ../models/graph
import ./weights

proc edgeCost(u: City, v: City, graph: Graph, maxDist: float, norm: float): float =
    augmentedWeight(u, v, graph, maxDist) / norm


proc affectedEdges*(pathLen: int, i: int, j: int): seq[int] =
    var edges: seq[int] = @[]

    proc addEdge(index: int) =
        if index >= 0 and index < pathLen - 1 and index notin edges:
            edges.add(index)

    addEdge(i - 1)
    addEdge(i)
    addEdge(j - 1)
    addEdge(j)

    return edges

proc cost*(path: seq[City], graph: Graph, maxDist: float, norm: float): float =
    var cost = 0.0

    for i in 1 ..< path.len: 
        let u = path[i - 1]
        let v = path[i]

        cost += edgeCost(u, v, graph, maxDist, norm)

    return cost
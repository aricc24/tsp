import ../models/city
import ../models/graph
import ./weights

proc cost*(path: seq[City], graph: Graph, maxDist: float, norm: float): float =
    var cost = 0.0

    for i in 1 ..< path.len: 
        let u = path[i - 1]
        let v = path[i]

        cost += augmentedWeight(u, v, graph, maxDist)

    return cost / norm
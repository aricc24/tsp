import ../models/matrix

proc edgeCost*(u: int, v: int, augmentedWeights: Matrix, norm: float): float =
    augmentedWeights[u, v] / norm


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

proc cost*(path: seq[int], augmentedWeights: Matrix, norm: float): float =
    var cost = 0.0

    for i in 1 ..< path.len: 
        let u = path[i - 1]
        let v = path[i]

        cost += edgeCost(u, v, augmentedWeights, norm)

    return cost

proc swappedCity(path: seq[int], index: int, i: int, j: int): int =
    if index == i:
        return path[j]

    if index == j:
        return path[i]

    return path[index]


proc incrementalCost*(path: seq[int], currentCost: float, i: int, j:int, 
        augmentedWeights:Matrix, norm: float): float = 
     
     var oldEdgesCost = 0.0
     var newEdgesCost = 0.0

     let edges = affectedEdges(path.len, i, j)

     for edge in edges: 
        let newU = path[edge]
        let newV = path[edge + 1]

        newEdgesCost += edgeCost(newU, newV, augmentedWeights, norm)

        let oldU = swappedCity(path, edge, i, j)
        let oldV = swappedCity(path, edge + 1, i, j)

        oldEdgesCost += edgeCost(oldU, oldV, augmentedWeights, norm)

     return currentCost - oldEdgesCost + newEdgesCost
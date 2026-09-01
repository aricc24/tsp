import ../models/city
import ../models/connection
import ../models/graph

proc buildGraph*(cities: seq[City], connections: seq[Connection]) : Graph =
    let n = cities.len
    var matrix = newSeq[seq[float]](n)

    for i in 0 ..< n: 
        matrix[i] = newSeq[float](n)

    for connection in connections: 
        let i = connection.city1Id - 1
        let j = connection.city2Id - 1

        matrix[j][i] = connection.distance
        matrix[i][j] = connection.distance

    return Graph(
        adjacencyMatrix: matrix
    )



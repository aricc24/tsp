import ../models/city
import ../models/connection
import ../models/graph
import ../models/matrix

proc buildGraph*(cities: seq[City], connections: seq[Connection]) : Graph =
    let n = cities.len
    var matrix = newMatrix(n)

    for connection in connections: 
        let i = connection.city1Id - 1
        let j = connection.city2Id - 1

        matrix[i, j] = connection.distance
        matrix[j, i] = connection.distance

    return Graph(
        adjacencyMatrix: matrix
    )



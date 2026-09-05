import unittest
import ../src/persistence/database
import ../src/persistence/instance_file
import ../src/tsp/graph
import ../src/tsp/weights
import ../src/tsp/cost

const Epsilon = 1e-6
const DatabasePath = "data/tsp.db"

let cities = getCities(DatabasePath)
let connections = getConnections(DatabasePath)
let graphi = buildGraph(cities, connections)


suite "Reference instances":

  test "input-40 matches results":
    let instance = loadInstance("data/instances/input-40.tsp",cities)
    let maxDist = maximumDistance(instance,connections)
    let norm = normalizer(instance,graphi)

    let evaluation = cost(instance,graphi,maxDist,norm)

    let refMaxDist = 4970123.960000000
    let refNorm = 181500915.920000017
    let refEvaluation = 4037072.073965357
    
    #[
    echo "\ninput-40:"
    echo "Maximum:"
    echo "mine:", maxDist
    echo "ref:",refMaxDist
    echo "diff:", abs(maxDist - refMaxDist)
    
    echo "Normalizer:"
    echo "mine:", norm
    echo "ref:", refNorm
    echo "diff:", abs(norm - refNorm)
    
    echo "Evaluation:"
    echo "mine:", evaluation
    echo "ref:", refEvaluation
    echo  "diff", abs(evaluation - refEvaluation)
    ]#

    check abs(maxDist - refMaxDist) <= Epsilon
    check abs(norm - refNorm) <= Epsilon
    check abs(evaluation - refEvaluation) <= Epsilon
    


  test "input-150 matches results":
    let instance = loadInstance("data/instances/input-150.tsp", cities)
    let maxDist = maximumDistance(instance, connections)
    let norm = normalizer(instance, graphi)

    let evaluation = cost(instance, graphi, maxDist, norm)

    let refMaxDist = 4978506.480000000
    let refNorm = 722598785.020000100
    let refEvaluation = 6092371.483582111

    #[
    echo "\ninput-150:"
    echo "Maximum:"
    echo "mine:", maxDist
    echo "ref:",refMaxDist
    echo "diff:", abs(maxDist - refMaxDist)
    
    echo "Normalizer:"
    echo "mine:", norm
    echo "ref:", refNorm
    echo "diff:", abs(norm - refNorm)
    
    echo "Evaluation:"
    echo "mine:", evaluation
    echo "ref:", refEvaluation
    echo  "diff", abs(evaluation - refEvaluation)
    ]#

    check abs(maxDist - refMaxDist) <= Epsilon
    check abs(norm - refNorm) <= Epsilon
    check abs(evaluation - refEvaluation) <= Epsilon

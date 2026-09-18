#[
Tests the implementation against reference TSP instances.

The tests load predefined instances from the database and instance files,
compute the maximum distance, normalization factor, augmented weights, and
final path evaluation, and compare the results with known reference values.
]#

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


#[
Test suite for validating predefined TSP instances against reference results.

It checks the maximum distance, normalization factor, and path evaluation
for the input-40 and input-150 instances.
]#
suite "Reference instances":

  test "input-40 matches results":
    let instance = loadInstance("data/instances/input-40.tsp",cities)
    let maxDist = maximumDistance(instance,connections)
    let norm = normalizer(instance,graphi)
    let augmentedWeights = buildAugmentedWeights(instance, graphi, maxDist)

    var path = newSeq[int](instance.len)
    for i in 0 ..< instance.len:
        path[i] = instance[i].id - 1

    let evaluation = cost(path, augmentedWeights, norm)

    let refMaxDist = 4970123.962350251
    let refNorm = 181500915.901503116
    let refEvaluation = 4037072.076285812
    
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
    let augmentedWeights = buildAugmentedWeights(instance, graphi, maxDist)

    var path = newSeq[int](instance.len)
    for i in 0 ..< instance.len:
        path[i] = instance[i].id - 1

    let evaluation = cost(path, augmentedWeights, norm)

    let refMaxDist = 4978506.478459956
    let refNorm = 722598784.973402858
    let refEvaluation = 6092371.482090380

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
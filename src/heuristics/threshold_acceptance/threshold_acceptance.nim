import std/random
import ./batch
import ./config

proc thresholdAcceptance*[T](solution: var seq[T], config: ThresholdConfig, rng: var Rand, costFunction: proc(solution: seq[T]): float, 
        neighborCostFunction: proc(solution: seq[T], currentCost: float, i: int, j: int): float): 
            tuple[bestSolution: seq[T], bestCost: float] =
    
    var temperature = config.initialTemperature
    var currentAverage = 0.0
    var bestSolution = solution[0 .. ^1]
    var bestCost = costFunction(solution)

    while temperature > config.epsilon: 
        var previousAverage = Inf
        var batches = 0

        while currentAverage <= previousAverage and
                batches < config.maxBatchesPerTemperature: 
            previousAverage = currentAverage

            let batchResult = calculateBatch(
                solution, 
                temperature, 
                config, 
                rng,
                costFunction, 
                neighborCostFunction
            )

            inc batches

            if batchResult.bestCost < bestCost: 
                bestCost = batchResult.bestCost
                bestSolution = batchResult.bestSolution
            
            if batchResult.accepted == 0: 
                break

            currentAverage = batchResult.average
 
        temperature *= config.coolingFactor
    
    return(bestSolution: bestSolution, bestCost: bestCost)
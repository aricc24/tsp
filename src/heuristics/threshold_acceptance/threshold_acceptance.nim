import std/random
import ./batch
import ./config

proc thresholdAcceptance*[T](solution: var seq[T], config: ThresholdConfig, rng: var Rand, costFunction: proc(solution: seq[T]): float): 
       tuple[bestSolution: seq[T], bestCost: float] =
    
    var temperature = config.initialTemperature
    var currentAverage = 0.0
    var bestSolution = solution[0 .. ^1]
    var bestCost = costFunction(solution)

    while temperature > config.epsilon: 
        var previousAverage = Inf

        while currentAverage <= previousAverage: 
            previousAverage = currentAverage

            let batchResult = calculateBatch(
                solution, 
                temperature, 
                config, 
                rng,
                costFunction
            )

            currentAverage = batchResult.average

            if batchResult.bestCost < bestCost: 
                bestCost = batchResult.bestCost
                bestSolution = batchResult. bestSolution
        
        temperature *= config.coolingFactor
    
    return(bestSolution: bestSolution, bestCost: bestCost)
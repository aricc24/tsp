import std/random
import ./neighbor
import ./config

proc calculateBatch*[T](solution: var seq[T], temperature: float, config:ThresholdConfig, rng: var Rand, costFunction: proc(solution: seq[T]): float): 
                        tuple[average: float, accepted:int] =

    var accepted = 0
    var attempts = 0
    var totalCost = 0.0
    var currentCost = costFunction(solution)

    while accepted < config.batchSize and attempts < config.maxAttempts: 
        let move = neighbor(solution, rng)
        let neighborCost = costFunction(solution)

        if neighborCost <= currentCost + temperature: 
            currentCost = neighborCost
            inc accepted
            totalCost += neighborCost
        else: 
            swapPositions(solution, move.i, move.j)
        
        inc attempts

        if accepted == 0: 
            return(currentCost, 0)

    return(totalCost/float(accepted), accepted)



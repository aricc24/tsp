import std/random
import ./neighbor
import ./config

proc calculateBatch*[T](
        solution: var seq[T], temperature: float, config:ThresholdConfig, rng: var Rand, currentCost: float, 
            bestSolution: var seq[T], bestCost: var float, 
                neighborCostFunction: proc(solution: seq[T], currentCost: float, i: int, j: int): float): 
                    tuple[average: float, accepted:int, currentCost: float] =

    var currentCost = currentCost
    var accepted = 0
    var attempts = 0
    var totalCost = 0.0

    while accepted < config.batchSize and attempts < config.maxAttempts: 
        let move = neighbor(solution, rng)
        let neighborCost = neighborCostFunction(solution, currentCost, move.i, move.j)

        if neighborCost <= currentCost + temperature: 
            currentCost = neighborCost
            inc accepted
            totalCost += neighborCost

            if neighborCost < bestCost: 
                bestCost = neighborCost
                bestSolution = solution[0 .. ^1]

        else: 
            swapPositions(solution, move.i, move.j)
        
        inc attempts

        if accepted == 0: #soy consciente
            return(average: currentCost, accepted: 0, currentCost: currentCost)

    return(average: totalCost/float(accepted), accepted: accepted, 
            currentCost: currentCost)




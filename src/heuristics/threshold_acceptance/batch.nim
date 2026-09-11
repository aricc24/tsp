import std/random
import ./neighbor
import ./config

proc calculateBatch*[T](solution: var seq[T], temperature: float, config:ThresholdConfig, rng: var Rand, costFunction: proc(solution: seq[T]): float): 
                        tuple[average: float, accepted:int, bestSolution: seq[T], bestCost: float] =

    var accepted = 0
    var attempts = 0
    var totalCost = 0.0
    var currentCost = costFunction(solution)

    var bestSolution = solution[0 .. ^1]
    var bestCost = currentCost

    while accepted < config.batchSize and attempts < config.maxAttempts: 
        let move = neighbor(solution, rng)
        let neighborCost = costFunction(solution)

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

        if accepted == 0: 
            return(average: currentCost, accepted: 0, 
                    bestSolution: bestSolution, bestCost: bestCost)

    return(average: totalCost/float(accepted), accepted: accepted, 
            bestSolution: bestSolution, bestCost: bestCost)



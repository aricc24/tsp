#[
Provides the batch evaluation logic used by the Threshold Acceptance heuristic.

This module generates and evaluates neighboring solutions, accepts moves
according to the current temperature, updates the best solution found, and
computes the average cost of the accepted solutions.
]#

import std/random
import ./neighbor
import ./config

#[
Processes a batch of neighboring solutions at a given temperature.

The procedure accepts neighbors that satisfy the Threshold Acceptance
condition, updates the current and best costs, records accepted evaluations,
and reverts rejected moves.

Returns the average accepted cost, the number of accepted neighbors, and
the final cost of the current solution.
]#
proc calculateBatch*[T](
        solution: var seq[T], temperature: float, config:ThresholdConfig, 
        rng: var Rand, currentCost: float, 
        bestSolution: var seq[T], bestCost: var float, 
        neighborCostFunction: proc(solution: seq[T], currentCost: float, i: int, j: int): float
        ): 
                tuple[average: float, accepted:int, currentCost: float] =

    var currentCost = currentCost
    var accepted = 0
    var attempts = 0
    var totalCost = 0.0
    
    var file = open("evaluations.txt", fmAppend) 

    while accepted < config.batchSize and attempts < config.maxAttempts: 
        let move = neighbor(solution, rng)
        let neighborCost = neighborCostFunction(solution, currentCost, move.i, move.j)

        if neighborCost <= currentCost + temperature: 
            currentCost = neighborCost
            inc accepted
            totalCost += neighborCost

            file.writeLine(currentCost) 

            if neighborCost < bestCost: 
                bestCost = neighborCost
                bestSolution = solution[0 .. ^1]

        else: 
            swapPositions(solution, move.i, move.j)
        
        inc attempts
        
    file.close()

    if accepted == 0:
        return(average: currentCost, accepted: 0, currentCost: currentCost)

    return(average: totalCost/float(accepted), accepted: accepted, 
            currentCost: currentCost)




#[
Implements the Threshold Acceptance heuristic.

This module controls the complete optimization process, including the initial
temperature selection, batch execution, thermal equilibrium, temperature
cooling, and tracking of the best solution found.
]#

import std/random
import ./batch
import ./config
import ./initial_temperature

#[
Applies the Threshold Acceptance heuristic to a given solution.

The procedure processes batches of neighboring solutions at decreasing
temperatures until the stopping condition is reached. It keeps track of the
best solution and cost found during the search.

Returns the best solution and its associated cost.
]#
proc thresholdAcceptance*[T](
        solution: var seq[T], config: ThresholdConfig, rng: var Rand, 
        costFunction: proc(solution: seq[T]): float, 
        neighborCostFunction: proc(solution: seq[T], currentCost: float, i: int, j: int): float
        ): 
                tuple[bestSolution: seq[T], bestCost: float] =
    
    var temperature = config.initialTemperature
    var currentAverage = 0.0
    var currentCost: float

    if config.searchTemperature:
        let temperatureResult = initialTemperature(solution, costFunction, config.initialTemperature,
                                config.targetAcceptance, config.batchSize, rng, neighborCostFunction)

        temperature = temperatureResult.temperature
        currentCost = temperatureResult.currentCost
    else:
        currentCost = costFunction(solution)

    var bestSolution = solution[0 .. ^1]
    var bestCost = currentCost


    while temperature > config.epsilon: 
        var previousAverage = Inf
        var batches = 0

        while currentAverage <= previousAverage and
                batches < config.maxBatchesPerTemperature: 
            previousAverage = currentAverage

            let batchResult = calculateBatch(solution, temperature, config, rng, currentCost, 
                              bestSolution, bestCost, neighborCostFunction)

            currentCost = batchResult.currentCost

            inc batches

            if batchResult.accepted == 0: 
                break

            currentAverage = batchResult.average
 
        temperature *= config.coolingFactor
    
    return(bestSolution: bestSolution, bestCost: bestCost)
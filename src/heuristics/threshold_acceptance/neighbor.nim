#[
Provides utilities for generating neighboring solutions.

A neighbor is created by randomly selecting two different positions in the
current solution and swapping their elements. The selected positions are
returned so the move can be reverted if necessary.
]#

import std/random


#[
Swaps two elements of the solution using their positions.
]#
proc swapPositions*[T](solution: var seq[T], i:int, j:int) = 
    swap(solution[i], solution[j])

#[
Generates a random neighbor by selecting two different positions
and swapping their elements. Returns the positions used in the swap.
]#
proc neighbor*[T](solution: var seq[T], rng: var Rand): tuple[i: int, j: int] =

    if solution.len < 2: 
        raise newException(ValueError, "Two elements are neded")

    let i = rng.rand(solution.high)
    var j = rng.rand(solution.high - 1)

    if j >= i: 
        inc j

    swapPositions(solution, i, j)

    return(i, j)
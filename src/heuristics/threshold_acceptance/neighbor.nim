import std/random

proc swapPositions*[T](solution: var seq[T], i:int, j:int) = 
    swap(solution[i], solution[j])

proc neighbor*[T](solution: var seq[T], rng: var Rand): tuple[i: int, j: int] =

    if solution.len < 2: 
        raise newException(ValueError, "Two elements are neded")

    let i = rng.rand(solution.high)
    var j = rng.rand(solution.high - 1)

    if j >= i: 
        inc j

    swapPositions(solution, i, j)

    return(i, j)
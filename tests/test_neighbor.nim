
import unittest
import std/random
import ../src/heuristics/threshold_acceptance/neighbor
import ../src/models/city

suite "Neighbor": 
    test "Swaps two positions": 
        var solution = @[1, 2, 3, 4, 5]
        swapPositions(solution, 1, 3)

        check solution == @[1, 4, 3, 2, 5]

    test "Swapping twice restores original solution":
        var solution = @[1, 2, 3, 4, 5]
        let original = solution
        
        swapPositions(solution, 1, 3)
        swapPositions(solution, 1, 3)
        check solution == original

    test "Swaps cities in a permutation":
        let city1 = City(id: 1)
        let city2 = City(id: 2)
        let city3 = City(id: 3)
        let city4 = City(id: 4)

        var solution = @[city1, city2, city3, city4]

        swapPositions(solution, 0, 2)

        check solution[0].id == 3
        check solution[1].id == 2
        check solution[2].id == 1
        check solution[3].id == 4
    
    test "Neighbor preserves the permutation": 
        var solution = @[1, 2, 3, 4, 5]
        let original = solution

        var rng = initRand(123)

        discard neighbor(solution, rng)
        
        check solution != original
        
        for value in original: 
            check value in solution
    
    test "Neighbor swaps exactly two positions": 
        var solution = @[1, 2, 3, 4, 5]
        var rng = initRand(123)
        let move = neighbor(solution, rng)

        check move.i != move.j
        check solution[move.i] != move.i + 1
        check solution[move.j] != move.j + 1

    test "Neighbor returns the swapped positions":
        var solution = @[1, 2, 3, 4, 5]
        let original = solution
        var rng = initRand(123)
        let move = neighbor(solution, rng)
        
        check move.i != move.j
        check solution[move.i] == original[move.j]
        check solution[move.j] == original[move.i]
    
    test "Neighbor can be reverted":
        var solution = @[1, 2, 3, 4, 5]
        let original = solution
        var rng = initRand(123)
        let move = neighbor(solution, rng)

        swapPositions(solution, move.i, move.j)
        check solution == original
    
    test "Same seed generates the same neighbor":
        var solution1 = @[1, 2, 3, 4, 5]
        var solution2 = @[1, 2, 3, 4, 5]

        var rng1 = initRand(123)
        var rng2 = initRand(123)

        let move1 = neighbor(solution1, rng1)
        let move2 = neighbor(solution2, rng2)

        check move1 == move2
        check solution1 == solution2
    




    

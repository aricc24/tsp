
import unittest
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
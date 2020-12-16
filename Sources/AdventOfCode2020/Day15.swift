//
//  Day15.swift
//  
//
//  Created by BJ Homer on 12/5/20.
//

import Foundation
import AdventCore
import Algorithms

func day15(input: Data) {
    let string = String(decoding: input, as: UTF8.self)

    let numbers = string.split(separator: ",").compactMap { Int($0) }


    let part1 = playGame(startingNumbers: numbers, steps: 2020)
    print("Part 1: \(part1)")

    let part2 = playGame(startingNumbers: numbers, steps: 30_000_000)
    print("Part 2: \(part2)")
}

private func playGame(startingNumbers numbers: [Int], steps: Int) -> Int {
    var history: [Int: Int] = [:]

    for (turn, number) in numbers.enumerated().dropLast() {
        history[number] = turn+1
    }

    var currentNumber = numbers.last!
    for step in (numbers.count)..<steps {
        let result: Int
        if let previousLocation = history[currentNumber] {
            result = step - previousLocation
        }
        else {
            result = 0
        }

        history[currentNumber] = step

        currentNumber = result
    }
    return currentNumber
}




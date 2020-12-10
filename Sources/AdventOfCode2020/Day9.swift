//
//  Day9.swift
//  
//
//  Created by BJ Homer on 12/5/20.
//

import Foundation
import AdventCore
import Algorithms

private let windowSize = 25

func day9(input: Data) {
    let numbers = String(decoding: input, as: UTF8.self)
        .split(separator: "\n")
        .compactMap({ Int($0) })

    let wrongNumber = part1(numbers: numbers)
    print("Part 1:", wrongNumber)

    let range = part2(numbers: numbers, target: wrongNumber)
    let weakRange = numbers[range]
    print("Part 2:", weakRange.min()! + weakRange.max()!)

}

private func part1(numbers: [Int]) -> Int {
    var windowStart = numbers.startIndex
    var windowEnd = windowStart+windowSize

    while windowEnd != numbers.endIndex {
        let window = numbers[windowStart..<windowEnd]


        let numberToCheck = numbers[windowEnd]

        let validSums = window.combinations(ofCount: 2)
            .map { $0.reduce(0, +) }
            .pipe({ Set($0) })

        if validSums.contains(numberToCheck) == false {
            return numberToCheck
        }

        windowStart += 1
        windowEnd += 1
    }

    fatalError("You should have found a number")
}

private func part2(numbers: [Int], target: Int) -> Range<Int> {
    var start = 0
    var end = 2

    while end < numbers.endIndex {
        let currentSum = numbers[start..<end].reduce(0, +)

        if currentSum == target {
            // We found it!
            return start..<end
        }
        else if currentSum > target {
            start += 1
            if end - start < 2 {
                end += 1
            }
        }
        else if currentSum < target {
            end += 1
        }
    }
    fatalError()
}

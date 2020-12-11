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

func day10(input: Data) {
    let numbers = String(decoding: input, as: UTF8.self)
        .split(separator: "\n")
        .compactMap({ Int($0) })

    let sorted = [0] + numbers.sorted() + [numbers.max()!+3]
    let pairs = Array(zip(sorted, sorted.dropFirst()))

    let ones = pairs.filter({ $0.1 - $0.0 == 1 }).count
    let threes = pairs.filter({ $0.1 - $0.0 == 3 }).count

    let part1 = ones * threes
    print("Part 1: \(ones) * \(threes) = \(part1)")


    assert(numberOfPaths(numbers: [1, 2]) == 1)
    assert(numberOfPaths(numbers: [1, 2, 3]) == 2)
    assert(numberOfPaths(numbers: [1, 2, 3, 4]) == 4)

    let part2 = numberOfPaths(numbers: sorted)
    print("Part 2: \(part2)")

}


private func numberOfPaths(numbers: [Int]) -> Int {
    var numberOfPaths: [Int: Int] = [:]

    for (i, thisNumber) in numbers.indexed() {
        let pathsToThis = numberOfPaths[thisNumber] ?? 1
        for x in numbers[(i+1)...].prefix(3) {
            if x - thisNumber <= 3 { numberOfPaths[x, default:0] += pathsToThis }
            else { break }
        }
    }

    return numberOfPaths[numbers.last!]!
}

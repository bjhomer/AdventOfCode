//
//  day1.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/1/19.
//  Copyright © 2019 Bloom Built, Inc. All rights reserved.
//

import Foundation

func runPuzzle1(_ inputFile: URL) throws {

    let input = try String(contentsOf: inputFile, encoding: .utf8)
    let lines = input.split(separator: "\n")

    let masses = lines.lazy.compactMap { Int($0) }
    let fuels = masses.map { ($0 / 3) - 2 }
    print("Sum of fuel needed for modules:")
    print(fuels.reduce(0, +))

    let totalFuels = masses.map { calculateTotalFuel(mass: $0) }

    print("Sum of total fuel needed for modules:")
    print(totalFuels.reduce(0, +))

}


func calculateTotalFuel(mass: Int) -> Int {
    var total = 0
    var nextAmount = mass
    while nextAmount > 0 {
        total += nextAmount
        nextAmount = (nextAmount / 3) - 2
    }
    total -= mass
    return total

}

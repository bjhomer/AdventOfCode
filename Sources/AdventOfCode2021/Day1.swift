//
//  Day1.swift
//
//  Created by BJ Homer on 12/1/20.
//

import Foundation
import Algorithms
import AdventCore

func day1(input: URL) {
    await day1part1(input: input)
    await day1part2(input: input)
}

private func day1part1(input: URL)  {
    print("------")
    print("Part 1:")
    let depths = try! await input.lines
        .map { Int($0)! }
        .collect()

    let increasingCount = depths.adjacentPairs()
        .filter { $0.0 < $0.1 }
        .count

    print(increasingCount)

    print("")
}

private func day1part2(input: URL)  async {
    print("------")
    print("Part 2:")
}

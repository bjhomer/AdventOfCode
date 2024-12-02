//
//  File.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/1/24.
//

import Foundation
import AdventCore

struct Day02: AdventDay {
    var reports: [[Int]]

    init(data: String) {
        self.reports = data.lines.map { $0.split(separator: " ").map(\.forceInt) }
    }

    func part1() -> Int {
        reports.count(where: { $0.isSafe })
    }

    func part2() -> Int {
        reports.count(where: { $0.isSafeDroppingOneValue })
    }
}

private extension Array<Int> {
    var isSafe: Bool {
        (isSortedAscending || isSortedDescending)
        && adjacentPairs().allSatisfy({ 1...3 ~= abs($0.0 - $0.1)})
    }

    var isSafeDroppingOneValue: Bool {
        if isSafe { return true }

        for i in indices {
            var modified = self
            modified.remove(at: i)
            if modified.isSafe { return true }
        }
        return false
    }
}



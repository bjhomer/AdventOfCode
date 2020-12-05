//
//  Day3.swift
//  
//
//  Created by BJ Homer on 12/3/20.
//

import Foundation

struct Day3: DailyChallenge {
    static func run(input: Data) {

        let lines = String(decoding: input, as: UTF8.self)
            .split(separator: "\n")
            .map { Array($0) }

        let forest = RepeatingForest(rows: lines)
        let treeCount = forest.diagonalTreeCount(dx: 3, dy: 1)

        print("------")
        print("Part 1:")
        print(treeCount)

        print("")
        print("------")
        print("Part 2:")


        let slopes = [
            (1, 1),
            (3, 1),
            (5, 1),
            (7, 1),
            (1, 2),
        ]
        let multipliedCounts = slopes.map { forest.diagonalTreeCount(dx: $0.0, dy: $0.1) }
            .reduce(1, *)
        print(multipliedCounts)
    }
}

private struct RepeatingForest {
    var rows: [[Character]]
    var width: Int { rows.first!.count }

    init(rows: [[Character]]) {
        self.rows = rows.filter { $0.isEmpty == false }
    }

    func diagonalTreeCount(dx: Int, dy: Int) -> Int {
        let relevantRows = stride(from: 0, to: rows.count, by: dy)
        let relevantPoints = relevantRows.enumerated()
            .map { (tuple) -> (Int, Int) in
                let (i, rowNumber) = tuple
                let column = (i * dx) % width
                return (rowNumber, column)
            }

        let terrain = relevantPoints.map { self[$0] }
        let treeCount = terrain.filter { $0 == "#" }.count
        return treeCount
    }

    subscript(_ tuple: (Int, Int)) -> Character? {
        return rows[tuple.0][tuple.1]
    }
}

//
//  Day5.swift
//  
//
//  Created by BJ Homer on 12/3/22.
//

import Foundation
import Algorithms
import AdventCore

struct Day8: Day {

    private var grid: Grid<Int>

    init(input: URL) async throws {
        let rows = try input.allLines
            .filter { !$0.isEmpty }
            .map { line in
                line.map { Int(String($0))! }
            }

        grid = Grid(rows: rows)
    }
    
    func part1() async {

        let visibleCount = grid.indices
            .filter( { grid.isVisible(row: $0.r, column: $0.c) })
            .count
        print(visibleCount)
    }
    
    func part2() async {
        let result = grid.indices
            .map { (r, c) in (r, c, grid.scenicScore(row: r, column: c)) }
            // All the below could just be `.max()!`, but I wanted to be able to see
            // which item it picked.
            .sorted(on: \.2)
            .reversed()
            .first!
        print(result.2)
    }
}

extension Grid<Int> {
    func isVisible(row r: Int, column c: Int) -> Bool {
        let item = self[row: r, column: c]

        let (up, down) = self[column: c].divided(around: r)
        let (left, right) = self[row: r].divided(around: c)

        return [up, down, left, right].contains(where: { $0.allSatisfy({ $0 < item })})
    }

    func scenicScore(row r: Int, column c: Int) -> Int {
        let item = self[row: r, column: c]

        let (up, down) = self[column: c].divided(around: r)
        let (left, right) = self[row: r].divided(around: c)

        let lines: [any Collection<Int>] = [up.reversed(), down, left.reversed(), right]
        let counts = lines.map { ($0.prefixThroughFirst(where: { $0 >= item }) as any Collection).count }
        let result = counts.reduce(1, *)
        return result
    }

}

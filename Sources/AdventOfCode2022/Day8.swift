//
//  Day5.swift
//  
//
//  Created by BJ Homer on 12/3/22.
//

import Foundation
import Algorithms

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
        var visibleCount: Int = 0

        for (r, c) in product(0..<grid.width, 0..<grid.height) {
            if grid.isVisible(row: r, column: c) {
                visibleCount += 1
            }
        }
        print(visibleCount)
    }
    
    func part2() async {
        let result = product(0..<grid.width, 0..<grid.height)
            .map { (i, j) in (i, j, grid.scenicScore(row: i, column: j)) }
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

private struct Grid<T> {
    private var rows: [[T]]

    init(rows: [[T]]) {
        self.rows = rows
    }

    var width: Int { rows[0].count }
    var height: Int { rows[0].count }

    subscript(row r: Int, column c: Int) -> T {
        get { rows[r][c] }
        set { rows[r][c] = newValue }
    }

    subscript(column c: Int) -> [T] {
        rows.map { $0[c] }
    }

    subscript(row r: Int) -> [T] {
        rows[r]
    }
}

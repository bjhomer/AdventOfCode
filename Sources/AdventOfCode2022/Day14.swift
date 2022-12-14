//
//  Day14.swift
//  
//
//  Created by BJ Homer on 12/13/22.
//

import Foundation
import AdventCore
import Algorithms

struct Day14: Day {

    private var paths: [Path]
    private var grid: SparseGrid<Character>

    init(input: URL) async throws {
        paths = try input.allLines
            .compactMap { Path($0) }

        grid = SparseGrid<Character>()
        for point in paths.flatMap({ $0.allPoints }) {
            grid[r: point.r, c: point.c] = "#"
        }
    }

    func part1() async {
        let ingress = Point(r: 0, c: 500)
        var grid = self.grid

        var count = 0
        while let floor = grid.restingPlace(from: ingress) {
            grid[floor] = "o"
            count += 1
        }
        print(count)
    }

    func part2() async {
        let ingress = Point(r: 0, c: 500)
        var grid = self.grid


        let floorRow = grid.rowRange!.upperBound + 2
        let height = grid.rowRange!.upperBound

        // Add the floor
        for c in (ingress.c - height - 3)...(ingress.c + height + 3) {
            grid[r: floorRow, c: c] = "-"
        }

        var count = 0
        while grid[ingress] == nil,
              let floor = grid.restingPlace(from: ingress) {
            grid[floor] = "o"
            count += 1
        }
//        print(grid)
        print(count)
    }
}

private typealias Point = SparseGrid<Character>.Index

private struct Path: CustomStringConvertible {
    var nodes: [Point]

    var description: String {
        nodes.map(\.description).joined(separator: " -> ")
    }

    init?(_ line: some StringProtocol) {
        nodes = line.split(separator: " -> ")
            .compactMap { Point($0) }
    }

    var allPoints: [Point] {
        let result = nodes.adjacentPairs().flatMap { (a, b)->[Point] in
            if a.r == b.r {
                return product([a.r], (a.c).through(b.c))
                    .map { Point(r: $0.0, c: $0.1)}
                => Array.init
            }
            else if a.c == b.c {
                return product((a.r).through(b.r), [a.c])
                    .map { Point(r: $0.0, c: $0.1)}
                => Array.init
            }
            else { return [] }
        }
        return result
    }
}

private extension Int {
    func through(_ other: Int) -> ClosedRange<Int> {
        let a = Swift.min(self, other)
        let b = Swift.max(self, other)
        return a...b
    }
}

private extension SparseGrid.Index {
    init?(_ line: some StringProtocol) {
        guard let (c, r) = line.split(separator: ",").map({ Int($0)! }).explode()
        else { return nil }
        self.init(r: r, c: c)
    }
}


private struct SparseGrid<T> {
    typealias Column = [Int: T]
    private var columns: [Int: Column] = [:]

    struct Index: Hashable, CustomStringConvertible {
        var r: Int
        var c: Int

        var description: String { "(\(r), \(c))"}

        func offset(r: Int, c: Int) -> Index {
            return Index(r: self.r+r, c: self.c+c)
        }
    }

    subscript(r r: Int, c c: Int) -> T? {
        get { columns[c]?[r] }
        set { columns[c, default: Column()][r] = newValue }
    }

    subscript(_ index: Index) -> T? {
        get { self[r: index.r, c: index.c] }
        set { self[r: index.r, c: index.c] = newValue }
    }

    var rowRange: ClosedRange<Int>? {
        guard let minRow = columns.values.compactMap({ $0.keys.min() }).min(),
              let maxRow = columns.values.compactMap({ $0.keys.max() }).max()
        else { return nil }

        return minRow...maxRow
    }

    var colRange: ClosedRange<Int>? {
        guard let (minCol, maxCol) = columns.keys.minAndMax()
        else { return nil }

        return minCol...maxCol
    }
}

extension SparseGrid: CustomStringConvertible {
    var description: String {
        guard let rowRange, let colRange else { return "(Empty Grid)" }
        var lines: [String] = []
        for row in rowRange {
            let line = colRange.map { self[r: row, c: $0].map {String(describing: $0)} ?? " " }.joined()
            lines.append(line)
        }
        return lines.joined(separator: "\n")
    }
}


private extension SparseGrid {
    func lastOpenIndex(below index: Index) -> Index? {
        guard let firstOpenSpot = topOccupiedIndex(below: index)?.offset(r: -1, c: 0)
        else { return nil }

        if firstOpenSpot.r >= index.r { return firstOpenSpot }
        else { return nil }
    }

    func topOccupiedIndex(below index: Index) -> Index? {
        guard let column = columns[index.c],
              let row = column.keys.lazy.filter({ $0 > index.r }).min()
        else { return nil }

        return Index(r: row, c: index.c)
    }

    func restingPlace(from index: Index) -> Index? {
        guard let floor = lastOpenIndex(below: index) else { return nil }
        let downLeft = floor.offset(r: 1, c: -1)
        let downRight = floor.offset(r: 1, c: 1)

        if self[downLeft] == nil {
            return restingPlace(from: downLeft)
        }
        else if self[downRight] == nil {
            return restingPlace(from: downRight)
        }
        else {
            return floor
        }
    }
}



//
//  Day08.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/10/24.
//

import Foundation
import AdventCore

struct Day08: AdventDay {
    typealias Grid = AdventCore.Grid<Character>

    let grid: Grid
    var antennas: [Antenna]

    init(data: String) {
        let grid = Grid(data.lines)
        antennas = grid.indices.compactMap { idx -> Antenna? in
            let value = grid[idx]
            switch value {
            case ".", "#": return nil
            case let x: return Antenna(frequency: x, point: idx)
            }
        }
        self.grid = grid
    }

    func part1() -> Int {
        return findAntinodesPart1().count
    }

    func part2() -> Int {
        return findAntinodesPart2().count
    }

    func findAntinodesPart1() -> Set<GridPoint> {
        var nodes: Set<GridPoint> = []

        let groups = antennas.grouped(by: \.frequency)
        for (_, antennas) in groups {
            for pair in antennas.combinations(ofCount: 2) {
                let antinodes = pair[0].antinodes(with: pair[1])
                if grid.isValidIndex(antinodes.0) {
                    nodes.insert(antinodes.0)
                }
                if grid.isValidIndex(antinodes.1) {
                    nodes.insert(antinodes.1)
                }
            }
        }
        return nodes
    }

    func findAntinodesPart2() -> Set<GridPoint> {
        var nodes: Set<GridPoint> = []

        let groups = antennas.grouped(by: \.frequency)
        for (_, antennas) in groups {
            for pair in antennas.combinations(ofCount: 2) {
                let antinodes = pair[0].resonantAntinodes(with: pair[1], bounds: grid.bounds)
                nodes.formUnion(antinodes)
            }
        }
        return nodes
    }

    func sortedAntinodes(mode: Mode) -> [GridPoint] {
        switch mode {
        case .part1:
            findAntinodesPart1().sorted(on: { $0.r * 1000 + $0.c })
        case .part2:
            findAntinodesPart2().sorted(on: { $0.r * 1000 + $0.c })
        }
    }
}

extension Day08 {
    enum Mode {
        case part1, part2
    }

    struct Antenna: Hashable {
        var frequency: Character
        var point: GridPoint

        func antinodes(with other: Antenna) -> (GridPoint, GridPoint) {
            let dx = point.x - other.point.x
            let dy = point.y - other.point.y

            let node1 = GridPoint(x: point.x + dx, y: point.y + dy)
            let node2 = GridPoint(x: other.point.x - dx, y: other.point.y - dy)
            return (node1, node2)
        }

        func resonantAntinodes(with other: Antenna, bounds: GridBounds) -> [GridPoint] {
            let dx = point.x - other.point.x
            let dy = point.y - other.point.y

            var nodes: [GridPoint] = []
            for multiplier in 0... {
                let node = GridPoint(x: point.x + dx * multiplier, y: point.y + dy * multiplier)
                if bounds.isValid(node) {
                    nodes.append(node)
                }
                else {
                    break
                }
            }
            for index in 1... {
                let multiplier = -1 * index
                let node = GridPoint(x: point.x + dx * multiplier, y: point.y + dy * multiplier)
                if bounds.isValid(node) {
                    nodes.append(node)
                }
                else {
                    break
                }
            }
            return nodes
        }
    }
}

//
//  Day12.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/13/24.
//

import Foundation
import AdventCore


struct Day12: AdventDay {
    typealias Grid = AdventCore.Grid<Character>
    var grid: Grid

    init(data: String) {
        grid = Grid(data.lines)
    }

    func regions() -> [Region] {
        return grid.allContiguousRegions()
    }

    func part1() -> Int {
        regions().map(\.fenceCostPart1).reduce(0, +)
    }
}

private extension Day12.Grid {
    func allContiguousRegions() -> [Day12.Region] {
        var visited: Set<GridPoint> = []
        var regions: [Day12.Region] = []
        for index in indices {
            if visited.contains(index) { continue }
            let region = contiguousRegion(from: index)
            visited.formUnion(region.points)
            regions.append(region)
        }
        return regions
    }

    func contiguousRegion(from start: GridPoint) -> Day12.Region {
        let startValue = self[start]
        return contiguousRegion(from: start, isIncluded: { self[$0] == startValue })
    }

    func contiguousRegion(from start: GridPoint, isIncluded: (GridPoint) -> Bool) -> Day12.Region {
        var tested: Set<GridPoint> = []

        var regionPoints: Set<GridPoint> = []
        var queue: [GridPoint] = [start]

        while let point = queue.popFirst() {
            regionPoints.insert(point)
            let neighbors = self.cardinalNeighbors(of: point)
            for neighbor in neighbors {
                guard !tested.contains(neighbor) else { continue }
                if isIncluded(neighbor) {
                    queue.append(neighbor)
                }
                tested.insert(neighbor)
            }
        }
        let regionName = self[start]
        return Day12.Region(name: regionName, points: regionPoints)
    }
}

extension Day12 {
    struct Region {
        var name: Character
        var points: Set<GridPoint>

        var area: Int { points.count }
        var perimeter: Int {
            var perimeter: Int = 0
            for point in points {
                for neighbor in point.cardinalNeighbors {
                    if points.contains(neighbor) == false {
                        perimeter += 1
                        
                    }
                }
            }
            return perimeter
        }

        var sideCount: Int {
            0
        }

        var fenceCostPart1: Int {
            return area * perimeter
        }

    }
}

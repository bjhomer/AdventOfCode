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

    func part2() -> Int {
        regions().map(\.fenceCostPart2).reduce(0, +)
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

        func boundingGrid() -> AdventCore.Grid<Int> {
            let (top, bottom) = points.map(\.y).minAndMax()!
            let (left, right) = points.map(\.x).minAndMax()!
            let topLeft = GridPoint(x: left, y: top)
            let bottomRight = GridPoint(x: right, y: bottom)

            var grid = AdventCore.Grid<Int>(topLeft: topLeft, bottomRight: bottomRight, defaultValue: -1)
            for point in points {
                grid[point] = 1
            }
            return grid
        }

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

        enum BooleanTest {
            case x
            case o
            case a

            var convolutionValue: Int {
                switch self {
                case .x: return 1
                case .o: return -1
                case .a: return 0
                }
            }

            func evaluate(_ value: Bool) -> Bool {
                switch self {
                case .x: return value
                case .o: return !value
                case .a: return true
                }
            }
        }

        struct RegionTest: CustomStringConvertible {
            let grid: Grid3<BooleanTest>

            typealias T = BooleanTest
            init(_ grid: Grid3<T>) {
                self.grid = grid
            }
            init(_ a: (T, T, T), _ b: (T, T, T), _ c: (T, T, T)) {
                grid = Grid3(a, b, c)
            }

            var rotated: RegionTest {
                return RegionTest(grid.rotatedCounterClockwise)
            }

            var rotations: [RegionTest] {
                return [
                    self,
                    self.rotated,
                    self.rotated.rotated,
                    self.rotated.rotated.rotated
                ]
            }

            var convolutionInput: Grid3<Int> {
                grid.map { $0.convolutionValue }
            }

            var valueCount: Int {
                grid.map { $0 == .a ? 0 : 1}.sum()
            }

            var description: String {
                grid.description
            }
        }

        private func cornerCounts() -> Int {

            let interiorCorners = RegionTest( (.o, .x, .a),
                                              (.x, .x, .a),
                                              (.a, .a, .a)
            ).rotations

            let exteriorCorners = RegionTest( (.a, .o, .a),
                                              (.o, .x, .a),
                                              (.a, .a, .a)
            ).rotations
            
            let cornerTests = interiorCorners + exteriorCorners

            let grid = self.boundingGrid()

            var result = 0
            for test in cornerTests {
                let correlation = grid.crossCorrelation(with: test.convolutionInput)
                let expectedCorrelation = test.valueCount
                result += correlation.indices.reduce(0) {
                    $0 + (correlation[$1] == expectedCorrelation ? 1 : 0)
                }
            }

            return result
        }

        var sideCount: Int {
            // count the number of corners
            return cornerCounts()
        }

        var fenceCostPart1: Int {
            return area * perimeter
        }

        var fenceCostPart2: Int {
            return area * sideCount
        }

    }
}

struct Grid3<T> {
    let ul: T
    let u: T
    let ur: T
    let l: T
    let m: T
    let r: T
    let dl: T
    let d: T
    let dr: T
}

extension Grid3 {
    init(_ a: (T, T, T), _ b: (T, T, T), _ c: (T, T, T)) {
        (ul, u, ur) = a
        (l, m, r) = b
        (dl, d, dr) = c
    }

    func map<U>(_ transform: (T) throws -> U) rethrows -> Grid3<U> {
        Grid3<U>(
            ul: try transform(ul),
            u: try transform(u),
            ur: try transform(ur),
            l: try transform(l),
            m: try transform(m),
            r: try transform(r),
            dl: try transform(dl),
            d: try transform(d),
            dr: try transform(dr)
        )
    }

    var rotatedCounterClockwise: Grid3<T> {
        Grid3( (ur, r, dr),
               (u, m, d),
               (ul, l, dl) )
    }
}

extension Grid3 where T: Numeric {
    func crossCorrelation(with other: Grid3<T>) -> T {
        let result = (ul * other.ul + u * other.u + ur * other.ur
                      + l * other.l + m * other.m + r * other.r
                      + dl * other.dl + d * other.d + dr * other.dr)
        return result
    }

    func sum() -> T {
        ul + u + ur + l + m + r + dl + d + dr
    }
}

extension Grid3: CustomStringConvertible {
    var description: String {
        "\(ul)\(u)\(ur)\n\(l)\(m)\(r)\n\(dl)\(d)\(dr)"
    }
}

extension Grid {
    func grid3(at point: GridPoint, defaultValue: T) -> Grid3<T> {
        let neighbors = point.neighborPoints()
        func value(at point: GridPoint) -> T {
            if isValidIndex(point) {
                return self[point]
            }
            else {
                return defaultValue
            }
        }
        return neighbors.map { value(at: $0) }
    }
}

extension Grid where T: Numeric {
    func crossCorrelation(with input: Grid3<T>, at point: GridPoint) -> T {
        let values = self.grid3(at: point, defaultValue: -1)
        let result = input.crossCorrelation(with: values)
        return result
    }

    func crossCorrelation(with input: Grid3<T>) -> Grid<T> {
        return mapByIndex { crossCorrelation(with: input, at: $0) }
    }
}

extension GridPoint {
    typealias NeighborPoints = Grid3<GridPoint>

    func neighborPoints() -> NeighborPoints {
        NeighborPoints(
            ul: self.moved(.upLeft),
            u: self.moved(.up),
            ur: self.moved(.upRight),
            l: self.moved(.left),
            m: self,
            r: self.moved(.right),
            dl: self.moved(.downLeft),
            d: self.moved(.down),
            dr: self.moved(.downRight)
        )
    }
}


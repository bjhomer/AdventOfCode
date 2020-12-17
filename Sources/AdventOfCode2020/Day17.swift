//
//  Day15.swift
//  
//
//  Created by BJ Homer on 12/5/20.
//

import Foundation
import AdventCore
import Algorithms

func day17(input inputData: Data) {

    let realInput = String(decoding: inputData, as: UTF8.self)

//    let sampleInput = """
//    .#.
//    ..#
//    ###
//    """
//
//    let mitchellInput = """
//    .###..#.
//    ##.##...
//    ....#.#.
//    #..#.###
//    ...#...#
//    ##.#...#
//    #..##.##
//    #.......
//    """

    let input = realInput

    var space3d = SparseSpace<Point3D>(input)

    for _ in 0..<6 {
        space3d = space3d.step()
    }

    let part1 = space3d.activeCount
    print("Part 1: \(part1)")

    var space4d = SparseSpace<Point4D>(input)

    for _ in 0..<6 {
        space4d = space4d.step()
    }

    let part2 = space4d.activeCount
    print("Part 2: \(part2)")
}

protocol DimensionalPoint: Hashable {
    var neighbors: [Self] { get }

    init(x: Int, y: Int)
}

struct Point3D: DimensionalPoint {
    var x: Int
    var y: Int
    var z: Int

    init(x: Int, y: Int) {
        self.init(x: x, y: y, z: 0)
    }

    init(x: Int, y: Int, z: Int = 0) {
        self.x = x
        self.y = y
        self.z = z
    }

    var neighbors: [Point3D] {
        var result: [Point3D] = []
        for x in -1...1 {
            for y in -1...1 {
                for z in -1...1 {
                    if x == 0 && y == 0 && z == 0 { continue }
                    result.append(Point3D(x: self.x + x,
                                          y: self.y + y,
                                          z: self.z + z))
                }
            }
        }
        return result
    }
}

struct Point4D: DimensionalPoint {
    var x: Int
    var y: Int
    var z: Int
    var w: Int

    init(x: Int, y: Int) {
        self.init(x: x, y: y, z: 0)
    }

    init(x: Int, y: Int, z: Int = 0, w: Int = 0) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }

    var neighbors: [Point4D] {
        var result: [Point4D] = []
        for x in -1...1 {
            for y in -1...1 {
                for z in -1...1 {
                    for w in -1...1 {
                        if x == 0 && y == 0 && z == 0 && w == 0 { continue }
                        result.append(Point4D(x: self.x + x,
                                              y: self.y + y,
                                              z: self.z + z,
                                              w: self.w + w))
                    }
                }
            }
        }
        return result
    }
}

struct SparseSpace<T: DimensionalPoint> {
    var activePoints: Set<T>

    init(_ string: String) {

        self.activePoints = string.split(separator: "\n")
            .enumerated()
            .flatMap { (lineNumber, line) in
                line.enumerated().compactMap {
                    $0.1 == "#"
                        ? T(x: $0.0, y: lineNumber)
                        : nil
                }
            }
            .pipe(Set.init)
    }

    var activeCount: Int { return activePoints.count }

    /// All points at or adjacent to an active point
    var potentialPoints: Set<T> {
        let result = Set(activePoints.flatMap { $0.neighbors }).union(activePoints)
        return result
    }

    func step() -> SparseSpace {
        var copy = self

        /*
         During a cycle, all cubes simultaneously change their state according to the following rules:

         If a cube is active and exactly 2 or 3 of its neighbors are also active, the cube remains active. Otherwise, the cube becomes inactive.
         If a cube is inactive but exactly 3 of its neighbors are active, the cube becomes active. Otherwise, the cube remains inactive.
         */

        for point in potentialPoints {
            let isActive = activePoints.contains(point)
            let neighborCount = activeNeighborCount(at: point)

            switch (isActive, neighborCount) {
            case (true, 2...3): break
            case (true, _): copy.activePoints.remove(point)
            case (false, 3): copy.activePoints.insert(point)
            default: break
            }
        }
        return copy
    }

    func activeNeighborCount(at point: T) -> Int {
        return point.neighbors
            .lazy
            .filter { activePoints.contains($0) }
            .count
    }
}

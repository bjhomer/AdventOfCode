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

    let start = Date()

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

    let interval = Date().timeIntervalSince(start)
    print(String(format: "time: %0.2f", interval))
}


protocol DimensionalPoint: Hashable {
    static var zero: Self { get }

    typealias IntPath = WritableKeyPath<Self, Int>
    static var paths: [IntPath] { get }
}


struct Point3D: DimensionalPoint, Sendable {
    var x: Int
    var y: Int
    var z: Int

    nonisolated(unsafe) static let paths: [IntPath] =  [\.x, \.y, \.z]
    static let zero = Point3D(x: 0, y: 0, z: 0)
}

struct Point4D: DimensionalPoint {

    var x: Int
    var y: Int
    var z: Int
    var w: Int

    nonisolated(unsafe) static let paths: [IntPath] = [\.x, \.y, \.z, \.w]
    static let zero = Point4D(x: 0, y: 0, z: 0, w: 0)
}

struct SparseSpace<T: DimensionalPoint> {
    var activePoints: Set<T>

    init(_ string: String) {

        self.activePoints = string.split(separator: "\n")
            .enumerated()
            .flatMap { (y, line) in
                line.enumerated()
                    .compactMap { (x, char) in
                    char == "#"
                        ? T([x, y])
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



extension DimensionalPoint {

    /**
     Creates a point given a sequence of values. Each value is assigned in the order
     specified by the `paths` static property. Any remaining properties are left at 0
     */
    init(_ values: [Int]) {
        self.init(zip(Self.paths, values))
    }

    /**
     Creates a point given a sequece of path-value pairs. Any unspecified paths
     are left at zero

     For example, a 3-dimensional point could be created like this:
     ```
     Point3D([\.x: 3, \.y: 4, \.z: 7])
     ```
     */
    init<PathsAndValues>(_ pairs: PathsAndValues) where
        PathsAndValues: Sequence,
        PathsAndValues.Element == (IntPath, Int)
    {
        self = .zero
        for (path, x) in pairs {
            self[keyPath: path] = x
        }
    }

    /// Produces an array of all neighboring points to this point, including "hyper-diagonals"
    var neighbors: [Self] {
        let paths = Self.paths
        let myValues = paths.map { self[keyPath: $0] }
        let possibleOffsets = neighborOffsets(dimensionCount: paths.count)
        let neighborValues = possibleOffsets.map { (offsets) in zip(myValues, offsets).map { $0.0 + $0.1 } }
        let points = neighborValues.map { (values) in Self(zip(paths, values)) }
        return Array(points)
    }
}


/// Returns all possible offsets that can be applied to find the neighbors of a point.
///
/// In 2 dimensions, this would produce:
/// ```
/// [
///   [-1, -1],
///   [-1,  0],
///   [-1,  1],
///   [ 0, -1],
///   [ 0,  1],
///   [ 1, -1],
///   [ 1,  0],
///   [ 1,  1],
/// ]
/// ```
///
/// Note that the `[0, 0]` offset is not present, as appllying that offset
/// would not produce a neighbor.
///
private func neighborOffsets(dimensionCount count: Int) -> [[Int]] {
    if let cached = _neighborOffsetsByDimension[count] { return cached }
    let result = [-1, 0, 1]
        .combinationsWithReplacement(count: count)
        .filter { !($0.allSatisfy{ $0 == 0 }) }
    _neighborOffsetsByDimension[count] = result
    return result
}

nonisolated(unsafe) private var _neighborOffsetsByDimension: [Int: [[Int]] ] = [:]

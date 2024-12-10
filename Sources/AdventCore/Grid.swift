//
//  Grid.swift
//  
//
//  Created by BJ Homer on 12/8/22.
//

import Algorithms

public struct GridPoint: Hashable, Codable, CustomStringConvertible, Sendable {

    public var r: Int
    public var c: Int

    public var x: Int {
        get { c }
        set { c = newValue }
    }

    public var y: Int {
        get { r }
        set { r = newValue}
    }

    public init(r: Int, c: Int) {
        self.r = r
        self.c = c
    }

    public init(x: Int, y: Int) {
        self.r = y
        self.c = x
    }

    func offset(by delta: (r: Int, c: Int)) -> Self {
        return Self(r: r + delta.r, c: c + delta.c)
    }

    public func offset(x: Int, y: Int) -> Self {
        var copy = self
        copy.x += x
        copy.y += y
        return copy
    }

    public func offset(r: Int, c: Int) -> Self {
        var copy = self
        copy.r += r
        copy.c += c
        return copy
    }

    public var description: String {
        "(r\(r), c\(c))"
    }
}

public struct GridBounds: Hashable, Sendable {
    public var rowRange: Range<Int>
    public var colRange: Range<Int>

    public func isValid(_ point: GridPoint) -> Bool {
        rowRange.contains(point.r) && colRange.contains(point.c)
    }
}

public struct Grid<T: Sendable>: Sendable {
    public typealias Index = GridPoint

    public let width: Int
    public let height: Int

    public var minX: Int { topLeft.x }
    public var maxX: Int { topLeft.x + width - 1 }
    public var minC: Int { minX }
    public var maxC: Int { maxX }

    public var minY: Int { topLeft.y }
    public var maxY: Int { topLeft.y + height - 1 }
    public var minR: Int { minY }
    public var maxR: Int { maxY }

    public var xRange: Range<Int> { minX..<(maxX+1) }
    public var yRange: Range<Int> { minY..<(maxY+1) }
    public var rowRange: Range<Int> { minR..<(maxR+1) }
    public var colRange: Range<Int> { minC..<(maxC+1) }

    public var bounds: GridBounds { .init(rowRange: rowRange, colRange: colRange) }

    private var topLeft = GridPoint(r: 0, c: 0)
    private var rows: [[T]]

    public init(rows: [[T]]) {
        width = rows[0].count
        height = rows.count
        self.rows = rows
    }

    public init(_ lines: some Sequence<some Sequence<T>>) {
        self.init(rows: Array(lines.map { Array($0) }))
    }

    public init(topLeft: GridPoint, bottomRight: GridPoint, defaultValue: T) {
        assert(topLeft.x <= bottomRight.x)
        assert(topLeft.y <= bottomRight.y)

        self.topLeft = topLeft

        width = bottomRight.x - topLeft.x + 1
        height = bottomRight.y - topLeft.y + 1

        let defaultRow = Array(repeating: defaultValue, count: width)
        rows = Array(repeating: defaultRow, count: height)
    }

    public var indices: [Index] {
        return Array(product(rowRange, colRange).map { Index(r: $0.0, c: $0.1) })
    }

    public subscript(row r: Int, column c: Int) -> T {
        get { rows[r-minR][c-minC] }
        set { rows[r-minR][c-minC] = newValue }
    }

    public subscript(column c: Int) -> [T] {
        rows.map { $0[c-minC] }
    }

    public subscript(row r: Int) -> [T] {
        rows[r-minR]
    }

    public subscript(_ index: Index) -> T {
        get { self[row: index.r, column: index.c] }
        set { self[row: index.r, column: index.c] = newValue }
    }

    public func index(moved: Direction, from start: Index) -> Index? {
        let index = start.offset(by: moved.offsets)
        guard isValidIndex(index) else { return nil }
        return index
    }

    public func isValidIndex(_ index: Index) -> Bool {
        return (minR...maxR) ~= index.r && (minR...maxR) ~= index.c
    }
    
    /// Returs the four cardinal neighbors of this index
    public func cardinalNeighbors(of index: Index) -> [Index] {
        Direction.cardinals.compactMap { self.index(moved:$0, from: index) }
    }
    
    /// Returns all surrounding indices, including diagonals
    public func surroundingNeighbors(of index: Index) -> [Index] {
        Direction.allCases.compactMap { self.index(moved:$0, from: index) }
    }
    
    /// Walks from the start position in the indicated direction, testing
    /// each index along the way to see whether it satisfies the given test.
    /// - Returns: The last index in this walk that satisfied the test, or
    ///       nil if `start` did not even satisfy the test.
    public func lastIndex(from start: Index, direction: Direction, satisfying test: (Index)->Bool) -> Index? {
        guard test(start) else { return nil }

        var current = start
        while true {
            guard let next = index(moved: direction, from: current),
                  test(next) else { break }
            current = next
        }

        return current
    }

    public func values(from start: Index, direction: Direction, limit: Int? = nil) -> [T] {

        var result: [T] = []
        var current = start
        while true {
            if let limit, result.count >= limit { break }

            result.append(self[current])
            if let next = index(moved: direction, from: current) {
                current = next
            } else {
                break
            }
        }
        return result
    }

    public func indices(from start: Index, direction: Direction) -> some Sequence<Index> {
        return GridPointSequence(rowRange: rowRange, columnRange: colRange, direction: direction, currentValue: start)
    }
}

extension Grid where T: Equatable {
    public func firstIndex(of item: T) -> Index? {
        self.indices.first(where: { self[$0] == item })
    }

    public func hasSequence(_ sequence: some Sequence<T>, from start: Index, direction: Direction) -> Bool {
        var currentIndex: Index? = start
        for item in sequence {
            guard let index = currentIndex else {
                // We walked off the end without finding it
                return false
            }
            guard self[index] == item else {
                // We found a value that didn't match
                return false
            }
            currentIndex = self.index(moved: direction, from: index)
        }
        return true
    }
}

extension Grid: CustomStringConvertible where T == Character {
    public var description: String {
        zip((minR)...(maxR), rows).map { "\(String($0).padding(toLength: 3, withPad: " ", startingAt: 0)) \(String($1))" }.joined(separator: "\n")
    }
}

extension Grid {
    struct GridPointSequence: Sequence, IteratorProtocol {
        var rowRange: Range<Int>
        var columnRange: Range<Int>

        var direction: Grid.Direction
        var currentValue: GridPoint

        mutating func next() -> GridPoint? {
            let result = currentValue
            guard rowRange ~= result.r && columnRange ~= result.c else {
                return nil
            }
            let nextValue = currentValue.offset(by: direction.offsets)
            currentValue = nextValue
            return result
        }
    }
}

extension Grid {
    public typealias Direction = GridDirection
    public typealias Rotation = GridRotation
}

public enum GridRotation {
    case clockwise45
    case clockwise90
    case clockwise180
    case counterClockwise45
    case counterClockwise90
    case counterClockwise180
}


public enum GridDirection: CaseIterable, Equatable, Hashable, Sendable {
    case up, down, left, right
    case upLeft, upRight, downLeft, downRight

    public static var cardinals: [GridDirection] { [.up, .down, .left, .right] }
    public static var diagonals: [GridDirection] { [.upLeft, .upRight, .downLeft, .downRight] }

    var offsets: (r: Int, c: Int) {
        switch self {
        case .up:   return (r: -1, c: 0)
        case .down: return (r: 1, c: 0)
        case .left: return (r: 0, c: -1)
        case .right: return (r: 0, c: 1)
        case .upLeft:   return (r: -1, c: -1)
        case .upRight:  return (r: -1, c: 1)
        case .downLeft: return (r: 1, c: -1)
        case .downRight: return (r: 1, c: 1)
        }
    }

    public var inverse: GridDirection {
        self.rotated(.counterClockwise180)
    }

    static let clockwiseOrder: [GridDirection] = [.up, .upRight, .right, .downRight, .down, .downLeft, .left, .upLeft]

    public func rotated(_ rotation: Grid.Rotation) -> GridDirection {
        let clockwiseOrder = Self.clockwiseOrder
        let startIndex = clockwiseOrder.firstIndex(of: self)!

        let offset = switch rotation {
        case .clockwise45: 1
        case .clockwise90: 2
        case .clockwise180: 4
        case .counterClockwise45: 7
        case .counterClockwise90: 6
        case .counterClockwise180: 4
        }

        let newIndex = (startIndex + offset).positiveMod(clockwiseOrder.count)
        return clockwiseOrder[newIndex]
    }
}

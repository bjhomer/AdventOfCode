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
        return Array(product(minR...maxR, minC...maxC).map { Index(r: $0.0, c: $0.1) })
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

    public enum Direction: CaseIterable, Equatable {
        case up, down, left, right
        case upLeft, upRight, downLeft, downRight

        public static var cardinals: [Direction] { [.up, .down, .left, .right] }
        public static var diagonals: [Direction] { [.upLeft, .upRight, .downLeft, .downRight] }

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

        public var inverse: Direction {
            switch self {
            case .up:   return .down
            case .down: return .up
            case .left: return .right
            case .right: return .left
            case .upLeft:   return .downRight
            case .upRight:  return .downLeft
            case .downLeft: return .upRight
            case .downRight: return .upLeft
            }
        }
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
    public func neighbors(of index: Index) -> [Index] {
        Direction.allCases.compactMap { self.index(moved:$0, from: index) }
    }
    
    /// Returns all surrounding indices, including diagonals
    public func surroundingIndices(of index: Index) -> [Index] {
        let deltas = product((-1...1), (-1...1))

        let result = deltas
            .map { Index(x: index.x + $0.0, y: index.y + $0.1) }
            .filter { isValidIndex($0) && index != $0 }

        return result
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
}

extension Grid where T: Equatable {
    public func firstIndex(of item: T) -> Index? {
        self.indices.first(where: { self[$0] == item })
    }
}

extension Grid: CustomStringConvertible where T == Character {
    public var description: String {
        zip((minR)...(maxR), rows).map { "\(String($0).padding(toLength: 3, withPad: " ", startingAt: 0)) \(String($1))" }.joined(separator: "\n")
    }
}

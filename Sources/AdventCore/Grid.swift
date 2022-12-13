//
//  Grid.swift
//  
//
//  Created by BJ Homer on 12/8/22.
//

import Algorithms

public struct Grid<T> {
    public struct Index: Hashable, Codable, CustomStringConvertible {
        public var r: Int
        public var c: Int

        func offset(by delta: (r: Int, c: Int)) -> Index {
            return Index(r: r + delta.r, c: c + delta.c)
        }

        public var description: String {
            "(\(r), \(c))"
        }
    }

    private var rows: [[T]]

    public init(rows: [[T]]) {
        self.rows = rows
    }

    public init(_ lines: some Sequence<some Sequence<T>>) {
        self.rows = Array(lines.map { Array($0) })
    }

    public var width: Int { rows[0].count }
    public var height: Int { rows.count }

    public var indices: [Index] {
        return Array(product(0..<height, 0..<width).map { Index(r: $0.0, c: $0.1) })
    }

    public subscript(row r: Int, column c: Int) -> T {
        get { rows[r][c] }
        set { rows[r][c] = newValue }
    }

    public subscript(column c: Int) -> [T] {
        rows.map { $0[c] }
    }

    public subscript(row r: Int) -> [T] {
        rows[r]
    }

    public subscript(_ index: Index) -> T {
        get { rows[index.r][index.c] }
        set { rows[index.r][index.c] = newValue }
    }

    public enum Direction: CaseIterable, Equatable {
        case up, down, left, right

        var offsets: (r: Int, c: Int) {
            switch self {
            case .up:   return (r: -1, c: 0)
            case .down: return (r: 1, c: 0)
            case .left: return (r: 0, c: -1)
            case .right: return (r: 0, c: 1)
            }
        }
    }

    public func index(moved: Direction, from start: Index) -> Index? {
        let index = start.offset(by: moved.offsets)
        guard (0..<height) ~= index.r && (0..<width) ~= index.c else { return nil }
        return index
    }

    public func neighbors(of index: Index) -> [Index] {
        Direction.allCases.compactMap { self.index(moved:$0, from: index) }
    }
}

extension Grid where T: Equatable {
    public func firstIndex(of item: T) -> Index? {
        self.indices.first(where: { self[$0] == item })
    }
}

extension Grid: CustomStringConvertible where T == Character {
    public var description: String {
        rows.map { String($0) }.joined(separator: "\n")
    }
}

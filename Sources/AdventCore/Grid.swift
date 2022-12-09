//
//  Grid.swift
//  
//
//  Created by BJ Homer on 12/8/22.
//

import Algorithms

public struct Grid<T> {
    public typealias Index = (r: Int, c: Int)

    private var rows: [[T]]

    public init(rows: [[T]]) {
        self.rows = rows
    }

    public var width: Int { rows[0].count }
    public var height: Int { rows.count }

    public var indices: [Index] {
        return Array(product(0..<height, 0..<width))
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
}

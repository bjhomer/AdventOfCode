//
//  File.swift
//  
//
//  Created by BJ Homer on 12/6/20.
//

import Foundation
import AdventCore
import Algorithms



func day6(input: String) {
    let lines = input.split(separator: "\n")

    let instructions = lines.compactMap(Instruction.init)
    var grid1 = Grid(width: 1000, height: 1000, value: false)

    for inst in instructions {
        grid1.apply(inst)
    }
    let part1 = grid1.countLit
    print("Part 1:", part1)

    var grid2 = Grid(width: 1000, height: 1000, value: 0)
    for inst in instructions {
        grid2.apply(inst)
    }
    let part2 = grid2.sum
    print("Part 2:", part2)

}

private struct Grid<T> {
    var rows: [[T]]

    init(width: Int, height: Int, value: T) {
        let row = Array(repeating: value, count: width)
        rows = Array(repeating: row, count: height)
    }

    var allValues: FlattenSequence<[[T]]> {
        return rows.joined()
    }
}

extension Grid where T == Bool {
    var countLit: Int { self.allValues.filter({$0}).count }

    mutating func set(_ rect: Rect) {
        for (r, c) in product(rect.rows, rect.cols) {
            rows[r][c] = true
        }
    }

    mutating func clear(_ rect: Rect) {
        for (r, c) in product(rect.rows, rect.cols) {
            rows[r][c] = false
        }
    }

    mutating func toggle(_ rect: Rect) {
        for (r, c) in product(rect.rows, rect.cols) {
            rows[r][c].toggle()
        }
    }

    mutating func apply(_ instruction: Instruction) {
        switch instruction.command {
        case .toggle: toggle(instruction.rect)
        case .turnOn: set(instruction.rect)
        case .turnOff: clear(instruction.rect)
        }
    }
}

extension Grid where T == Int {
    var sum: Int { self.allValues.reduce(0, +) }

    mutating func inc(_ rect: Rect) {
        for (r, c) in product(rect.rows, rect.cols) {
            rows[r][c] += 1
        }
    }

    mutating func dec(_ rect: Rect) {
        for (r, c) in product(rect.rows, rect.cols) {
            rows[r][c] = max(0, rows[r][c] - 1)
        }
    }

    mutating func inc2(_ rect: Rect) {
        for (r, c) in product(rect.rows, rect.cols) {
            rows[r][c] += 2
        }
    }

    mutating func apply(_ instruction: Instruction) {
        switch instruction.command {
        case .toggle: inc2(instruction.rect)
        case .turnOn: inc(instruction.rect)
        case .turnOff: dec(instruction.rect)
        }
    }
}

private struct Rect {
    init(topLeft: Point, bottomRight: Point) {
        self.topLeft = topLeft
        self.bottomRight = bottomRight
    }

    init(top: Int, left: Int, bottom: Int, right: Int) {
        let topLeft = Point(x: left, y: top)
        let bottomRight = Point(x: right, y: bottom)
        self.init(topLeft: topLeft, bottomRight: bottomRight)
    }

    var topLeft: Point
    var bottomRight: Point


    var top: Int { topLeft.y }
    var bottom: Int { bottomRight.y }
    var left: Int { topLeft.x }
    var right: Int { bottomRight.x }

    var rows: ClosedRange<Int> { top...bottom }
    var cols: ClosedRange<Int> { left...right }
}

private struct Point: Hashable {
    var x, y: Int
}

private struct Instruction {
    enum Command: String {
        case turnOn = "turn on"
        case turnOff = "turn off"
        case toggle = "toggle"
    }
    var rect: Rect
    var command: Command

    init?<S>(_ line: S) where S: StringProtocol {
        let regex: Regex = #"^(toggle|turn on|turn off) (\d+),(\d+) through (\d+),(\d+)$"#

        guard let match = regex.match(line),
              let (c, t, l, b, r) = match.dropFirst().explode()
        else { return nil }

        self.rect = Rect(top: Int(t)!, left: Int(l)!, bottom: Int(b)!, right: Int(r)!)
        self.command = Command(rawValue: c)!
    }
}


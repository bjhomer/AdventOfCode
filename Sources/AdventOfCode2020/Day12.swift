//
//  Day15.swift
//  
//
//  Created by BJ Homer on 12/5/20.
//

import Foundation
import AdventCore
import Algorithms

func day12(input: Data) {
    let inputString = String(decoding: input, as: UTF8.self)

//    let exampleString = """
//    F10
//    N3
//    F7
//    R90
//    F11
//    """

    let instructions = inputString
        .split(separator: "\n")
        .compactMap(Instruction.init(_:))
    

    assert(Heading.north.rotated(left: 90) == Heading.west)
    assert(Heading.north.rotated(left: -90) == Heading.east)
    assert(Heading.east.rotated(left: 180) == Heading.west)
    assert(Heading.south.rotated(left: -90) == Heading.west)
    assert(Heading(x: -12, y: -1).rotated(left: 90) == Heading(x: 1, y: -12))

    var ship = Ship()
    for instruction in instructions {
        ship.execute_part1(instruction)
    }

    let part1 = abs(ship.position.x) + abs(ship.position.y)
    print("Part 1: \(part1)")

    var ship2 = Ship(heading: .init(x: 10, y: 1))
    for instruction in instructions {
        ship2.execute_part2(instruction)
    }

    let part2 = abs(ship2.position.x) + abs(ship2.position.y)
    print("Part 2: \(part2)")
}

private struct Heading: Equatable {

    var x: Int
    var y: Int

    static var north = Heading(x: 0, y: 1)
    static var south = Heading(x: 0, y: -1)
    static var east = Heading(x: 1, y: 0)
    static var west = Heading(x: -1, y: 0)

    internal init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    init(_ c: Character) {
        switch c {
        case "N": self = .north
        case "S": self = .south
        case "W": self = .west
        case "E": self = .east
        default: fatalError("Unexpected heading")
        }
    }

    mutating func rotate(left degrees: Int) {
        let radians = Double(degrees) / 180 * .pi

        let dx = Double(x)
        let dy = Double(y)

        // Poor man's matrix math
        let newX = cos(radians) * dx - sin(radians) * dy
        let newY = sin(radians) * dx + cos(radians) * dy

        self.x = Int(round(newX))
        self.y = Int(round(newY))
    }

    func rotated(left degrees: Int) -> Heading {
        var copy = self
        copy.rotate(left: degrees)
        return copy
    }


    // This isn't used anymore, but I kept it around because it was kinda interesting.
    mutating func rotate_part1(left degrees: Int) {
        assert(degrees.isMultiple(of: 90), "We can't handle rotations that aren't a multiple of 90 degrees")
        let rotations = degrees / 90

        let rotationOrder: [Heading] = [.north, .west, .south, .east]
        let currentIndex = rotationOrder.firstIndex(of: self)!
        let newIndex = (currentIndex + rotations)
        self = rotationOrder[newIndex.positiveMod(rotationOrder.count)]
    }
}


private struct Instruction {
    var action: Action
    var amount: Int

    enum Action: String {
        case moveNorth = "N"
        case moveSouth = "S"
        case moveEast  = "E"
        case moveWest  = "W"
        case turnLeft  = "L"
        case turnRight = "R"
        case moveForward = "F"

        init(_ c: Character) {
            self.init(rawValue: String(c))!
        }
    }

    init?<Str>(_ string: Str) where Str: StringProtocol {
        guard let actionChar = string.first,
              let amount = Int(string.dropFirst())
        else { return nil }

        self.action = Action(actionChar)
        self.amount = amount
    }

    init(action: Action, amount: Int) {
        self.action = action
        self.amount = amount
    }

    func execute_part1(on ship: inout Ship) {
        switch action {
        case .moveEast: ship.position.x += amount
        case .moveWest: ship.position.x -= amount
        case .moveNorth: ship.position.y += amount
        case .moveSouth: ship.position.y -= amount
        case .turnLeft: ship.heading.rotate(left: amount)
        case .turnRight: ship.heading.rotate(left: -amount)
        case .moveForward: ship.position.offset(by: ship.heading, amount: amount)
        }
    }

    func execute_part2(on ship: inout Ship) {
        switch action {
        case .moveEast: ship.heading.x += amount
        case .moveWest: ship.heading.x -= amount
        case .moveNorth: ship.heading.y += amount
        case .moveSouth: ship.heading.y -= amount
        case .turnLeft: ship.heading.rotate(left: amount)
        case .turnRight: ship.heading.rotate(left: -amount)
        case .moveForward: ship.position.offset(by: ship.heading, amount: amount)
        }
    }


}

private struct Position {
    var x = 0
    var y = 0

    mutating func offset(by heading: Heading, amount: Int) {
        x += heading.x * amount
        y += heading.y * amount
    }
}

private struct Ship {
    var heading = Heading.east
    var position = Position()

    mutating func execute_part1(_ instruction: Instruction) {
        instruction.execute_part1(on: &self)
//        print("\(instruction) -> \t\(position)\t\(heading)")
    }

    mutating func execute_part2(_ instruction: Instruction) {
        instruction.execute_part2(on: &self)
//        print("\(instruction) -> \t\(position)\t\(heading)")
    }
}



extension Instruction: CustomStringConvertible {
    var description: String { "\(action.rawValue)\(amount)".padding(toLength: 5, withPad: " ", startingAt: 0) }
}

extension Position: CustomStringConvertible {
    var description: String { "(\(x),\(y))" }
}

extension Heading: CustomStringConvertible {
    var description: String { "H:(\(x),\(y))" }
}

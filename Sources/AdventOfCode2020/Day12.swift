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
    let instructions = String(decoding: input, as: UTF8.self)
        .split(separator: "\n")
        .compactMap(Instruction.init(_:))

    var ship = Ship1()
    for instruction in instructions {
        ship.execute(instruction)
    }

    let part1 = abs(ship.position.x) + abs(ship.position.y)
    print("Part 1: \(part1)")
}

private enum Heading: String, Equatable {
    case north = "N"
    case south = "S"
    case east = "E"
    case west = "W"

    init(_ c: Character) {
        self.init(rawValue: String(c))!
    }

    mutating func rotate(left degrees: Int) {
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

        init(move heading: Heading) {
            switch heading {
            case .north: self = .moveNorth
            case .south: self = .moveSouth
            case .west: self = .moveWest
            case .east: self = .moveEast
            }
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

    func execute(on ship: inout Ship1) {
        switch action {
        case .moveEast: ship.position.x -= amount
        case .moveWest: ship.position.x += amount
        case .moveNorth: ship.position.y += amount
        case .moveSouth: ship.position.y -= amount
        case .turnLeft: ship.heading.rotate(left: amount)
        case .turnRight: ship.heading.rotate(left: -amount)
        case .moveForward:
            let action = Action(move: ship.heading)
            let newInstruction = Instruction(action: action, amount: amount)
            newInstruction.execute(on: &ship)
        }
    }
}

private struct Position {
    var x = 0
    var y = 0
}

private struct Ship1 {
    var heading = Heading.east
    var position = Position()

    mutating func execute(_ instruction: Instruction) {
        instruction.execute(on: &self)
    }

}


private struct Ship2 {
    var waypoint
}


//
//  Day10.swift
//  
//
//  Created by BJ Homer on 12/10/22.
//

import Foundation
import AdventCore

struct Day10: Day {
    private var instructions: [Instruction]

    init(input: URL) async throws {
        instructions = try input.allLines
            .compactMap { Instruction($0) }
    }

    func part1() async {
        let machine = Machine()
        machine.setProbes(cycles: [20, 60, 100, 140, 180, 220])

        machine.execute(instructions)
        let result = machine.probeValues.map(\.signalStrength).reduce(0, +)
        print(result)
    }

    func part2() async {
        let machine = Machine()
        machine.execute(instructions)
        machine.display.print()
    }


}

private class Machine {
    struct State {
        var cycleCount = 0
        var x: Int = 1

        var signalStrength: Int { cycleCount * x }
    }

    var state = State()
    var display = Display()
    private var probes: [Int] = []
    private(set) var probeValues: [State] = []

    func setProbes(cycles: [Int]) {
        probes = cycles.sorted()
    }

    func execute(_ instruction: Instruction) {
        for _ in 0..<instruction.cycleCost {
            state.cycleCount += 1
            if probes.first == state.cycleCount {
                probeValues.append(state)
                probes.popFirst()
            }
            display.update(with: state)
        }
        instruction.action(&state)
    }

    func execute(_ instructions: [Instruction]) {
        for instruction in instructions {
            execute(instruction)
        }
    }

    struct Display {
        var pixels: [Bool] = Array(repeating: false, count: 40*6)
        let columnCount = 40

        mutating func update(with state: Machine.State) {
            let pixel = state.cycleCount - 1
            let column = pixel % columnCount
            if (state.x-1)...(state.x+1) ~= column {
                pixels[pixel] = true
            }
        }

        func print() {
            for line in pixels.chunks(ofCount: columnCount) {
                let chars = line.map { $0 ? "#" : " " }.joined()
                Swift.print(chars)
            }
        }
    }

}

private struct Instruction {

    var cycleCost: Int
    var action: (inout Machine.State) -> Void

    init?(_ str: some StringProtocol) {
        let parts = str.split(separator: " ")

        switch parts.first {
        case "noop":
            cycleCost = 1
            action = {_ in }
        case "addx":
            cycleCost = 2
            let amount = Int(parts[1])!
            action = { $0.x += amount }
        case nil:
            return nil
        default:
            print("Unexpected instruction: \(str)")
            return nil
        }
    }
}

//
//  Day15.swift
//  
//
//  Created by BJ Homer on 12/5/20.
//

import Foundation
import AdventCore
import Algorithms


private let sampleInput = """
mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1
"""

func day14(input inputData: Data) {

//    let input = sampleInput
    let input = String(decoding: inputData, as: UTF8.self)
    let lines = input.split(separator: "\n")

    let instructions = lines.compactMap { Instruction(line: $0) }

    var machine1 = Machine(version: 1)
    machine1.execute(instructions)
    let part1 = machine1.memory.sumOfValues
    print("Part 1: \(part1)")

    var machine2 = Machine(version: 2)
    machine2.execute(instructions)
    let part2 = machine2.memory.sumOfValues
    print("Part 2: \(part2)")
}

private struct Machine {
    var mask = Mask()
    var memory = Memory()
    var version: Int

    mutating func execute(_ instruction: Instruction) {
        instruction.execute(in: &self)
    }

    mutating func execute(_ instructions: [Instruction]) {
        for inst in instructions {
            self.execute(inst)
        }
    }
}

private struct Mask {
    static let length = 36
    var mask: String

    init() {
        mask = String(Array(repeating: "X" as Character, count: Mask.length))
    }

    init(_ string: String) {
        assert(string.count == Mask.length)
        mask = string
    }

    func apply(to input: Int) -> Int {
        let inputBits = String(input, radix: 2).leftPad("0", length: Mask.length)

        let resultString = zip(mask, inputBits)
            .map { (mask, input) -> Character in
                switch (mask) {
                case "0", "1": return mask
                case _: return input
                }
            }
            .pipe { String($0) }

        return Int(resultString, radix: 2)!
    }

    func allPossibilities(for input: Int) -> [Int] {
        let inputBits = String(input, radix: 2).leftPad("0", length: Mask.length)

        typealias CharArray = [Character]

        let maskedInput = zip(mask, inputBits)
            .map { (mask, input) -> Character in
                switch (mask) {
                case "0": return input
                case "1": return "1"
                case "X": return "X"
                default: fatalError()
                }
            }

        var queue: [CharArray] = [maskedInput]
        var output: [Int] = []

        while let item = queue.popLast() {
            if let firstXIndex = item.firstIndex(of: "X") {
                var copy1 = item
                copy1[firstXIndex] = "0"
                var copy2 = item
                copy2[firstXIndex] = "1"

                queue.append(copy1)
                queue.append(copy2)
            }
            else {
                let value = Int(String(item), radix: 2)!
                output.append(value)
            }
        }


        return output

    }
}

private struct Memory {
    private var bank: [Int: Int] = [:]

    subscript(_ address: Int) -> Int {
        get { return bank[address] ?? 0 }
        set { bank[address] = newValue }
    }

    var sumOfValues: Int {
        return bank.values.reduce(0, +)
    }
}

extension BidirectionalCollection {
    func leftPad(_ element: Element, length: Int) -> [Element] {
        let paddingNeeded = length - self.count
        if paddingNeeded <= 0 { return Array(self) }

        return Array(repeating: element, count: paddingNeeded) + Array(self)
    }
}

private enum Instruction {
    case setMask(String)
    case setMemory(address: Int, value: Int)

    private static var memRegex: ACRegex = #"mem\[(\d+)\]"#

    init?<Str: StringProtocol>(line: Str) {
        guard let (destination, valueStr) = line.split(separator: " = ").explode()
        else { return nil }

        if destination == "mask" {
            self = .setMask(String(valueStr))
        }
        else if let match = Instruction.memRegex.match(destination),
                let address = Int(match[1]),
                let value = Int(valueStr)
        {
            self = .setMemory(address: address, value: value)
        }
        else {
            fatalError("Unexpected line")
        }
    }

    func execute(in machine: inout Machine) {
        switch self {
        case .setMask(let mask): machine.mask = Mask(mask)

        case .setMemory(address: let addr, value: let value):
            if machine.version == 1 {
                let maskedValue = machine.mask.apply(to: value)
                machine.memory[addr] = maskedValue
            }
            else if machine.version == 2 {
                let allAddresses = machine.mask.allPossibilities(for: addr)
                for addr in allAddresses {
                    machine.memory[addr] = value
                }
            }

        }
    }
}

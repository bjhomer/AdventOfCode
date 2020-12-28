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
mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0
"""

func day14(input inputData: Data) {

//    let input = String(decoding: input, as: UTF8.self)
    let input = sampleInput
    let lines = input.split(separator: "\n")

    let instructions = lines.compactMap { Instruction(line: $0) }

    var machine = Machine()

    for x in instructions {
        machine.execute(x)
    }
    let part1 = machine.memory.sumOfValues
    print("Part 1: \(part1)")

}

private struct Machine {
    var mask = Mask()
    var memory = Memory()

    mutating func execute(_ instruction: Instruction) {
        instruction.execute(in: &self)
    }
}

private struct Mask {
    static let length = 36
    var mask: [Character]

    init() {
        mask = Array(repeating: "X", count: Mask.length)
    }

    init(_ string: String) {
        assert(string.count == Mask.length)
        mask = Array(string)
    }

    func apply(to input: Int) -> Int {
        let inputBits = String(input, radix: 2).leftPad("0", length: Mask.length)

        let resultString = zip(mask, inputBits)
            .map { (mask, input) -> Character in
                switch (mask) {
                case "0", "1": return mask
                case let x: return x
                }
            }
            .pipe { String($0) }

        return Int(resultString, radix: 2)!
    }
}

private struct Memory {
    var bank: [Int: Int] = [:]

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

    private static var memRegex: Regex = #"mem[(\d+)]"#

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
        case .setMemory(address: let addr, value: let value): machine.memory[addr] = value
        }
    }
}

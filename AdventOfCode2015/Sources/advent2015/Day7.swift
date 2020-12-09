//
//  File.swift
//  
//
//  Created by BJ Homer on 12/6/20.
//

import Foundation
import AdventCore
import Algorithms



func day7(input: String) {
    var gates = input
        .split(separator: "\n")
        .map(Gate.init)
        .keyed(by: \.name)

    let part1 = gates["a"]!.value(in: gates)
    print("Part 1:", part1)

    gates["a"]?.reset(in: gates)

    let override = Gate("\(part1) -> b")
    gates["b"] = override

    let part2 = gates["a"]!.value(in: gates)
    print("Part 2:", part2)

}

private class Gate {
    var name: String
    var operation: Operation

    enum Operation {
        case and(String, String)
        case or(String, String)
        case not(String)
        case const(UInt16)
        case lshift(String, Int)
        case rshift(String, Int)
        case passthrough(String)
    }

    init<S>(_ line: S) where S: StringProtocol {
        let (inst, name) = line.split(separator: " -> ").explode()!
        self.name = String(name)

        let andPattern: Regex = #"^(.+) AND (.+)$"#
        let orPattern: Regex  = #"^(.+) OR (.+)$"#
        let notPattern: Regex = #"^NOT (.+)$"#
        let constPattern: Regex = #"^(\d+)$"#
        let lshiftPattern: Regex = #"^(.+) LSHIFT (\d+)$"#
        let rshiftPattern: Regex = #"^(.+) RSHIFT (\d+)$"#
        let passthroughPattern: Regex = #"^([^ ]+)$"#

        if let match = andPattern.match(inst) {
            operation = .and(match[1], match[2])
        }
        else if let match = orPattern.match(inst) {
            operation = .or(match[1], match[2])
        }
        else if let match = notPattern.match(inst) {
            operation = .not(match[1])
        }
        else if let match = constPattern.match(inst) {
            operation = .const(UInt16(match[1])!)
        }
        else if let match = lshiftPattern.match(inst) {
            operation = .lshift(match[1], Int(match[2])!)
        }
        else if let match = rshiftPattern.match(inst) {
            operation = .rshift(match[1], Int(match[2])!)
        }
        else if let match = passthroughPattern.match(inst) {
            operation = .passthrough(match[1])
        }
        else { fatalError("Bad Input") }
    }

    func reset(in circuit: [String: Gate]) {
        if _value == nil { return }
        _value = nil
        switch operation {
        case .and(let aName, let bName):
            if let a = circuit[aName] { a.reset(in: circuit) }
            if let b = circuit[bName] { b.reset(in: circuit) }
        case .or(let aName, let bName):
            if let a = circuit[aName] { a.reset(in: circuit) }
            if let b = circuit[bName] { b.reset(in: circuit) }
        case .not(let aName):
            if let a = circuit[aName] { a.reset(in: circuit) }
        case .lshift(let aName, _):
            if let a = circuit[aName] { a.reset(in: circuit) }
        case .rshift(let aName, _):
            if let a = circuit[aName] { a.reset(in: circuit) }
        case .passthrough(let aName):
            if let a = circuit[aName] { a.reset(in: circuit) }
        case .const(_): break
        }
    }

    private var _value: UInt16?

    func value(`in` circuit: [String: Gate]) -> UInt16 {
//        print(name, "->", self.operation)
        if let value = _value { return value }

        let result: UInt16
        switch operation {
        case .and(let aName, let bName):
            let a = value(for: aName, in: circuit)
            let b = value(for: bName, in: circuit)
            result = a & b

        case .or(let aName, let bName):
            let a = value(for: aName, in: circuit)
            let b = value(for: bName, in: circuit)
            result = a | b

        case .not(let aName):
            let a = value(for: aName, in: circuit)
            result = ~a

        case .const(let value):
            result = value

        case .lshift(let aName, let amount):
            let a = value(for: aName, in: circuit)
            result = a << amount

        case .rshift(let aName, let amount):
            let a = value(for: aName, in: circuit)
            result = a >> amount

        case .passthrough(let aName):
            let a = value(for: aName, in: circuit)
            result = a
        }
        _value = result
        return result
    }

    private func value(for name: String, in circuit: [String: Gate]) -> UInt16 {
        return circuit[name]?.value(in: circuit) ?? UInt16(name)!
    }
}

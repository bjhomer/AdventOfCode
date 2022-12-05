//
//  Day5.swift
//  
//
//  Created by BJ Homer on 12/3/22.
//

import Foundation
import RegexBuilder

struct Day5: Day {
    private var stacks: [CrateStack]
    private var instructions: [Instruction]

    init(input: URL) async throws {
        let lines = try input.allLines
        let (crateLines, instructionLines) = lines.split(separator: "").explode()!

        let stackCount = (crateLines.first!.count + 1) / 4
        stacks = Array(repeating: CrateStack(), count: stackCount)

        // Build the stacks
        for line in crateLines {
            let matches = line.matches(of: #/    ?|\[(.)\] ?/#)
            for (stackIndex, match) in matches.enumerated() {
                if let crateName = match.1 {
                    stacks[stackIndex].addToBottom(crateName)
                }
            }
        }

        instructions = instructionLines.compactMap { Instruction($0) }
    }

    func part1() async {
        var yard = CrateYard(stacks: stacks)
        yard.execute(instructions)

        let topCrates = yard.stacks.map { $0.top()! }.joined()
        print(topCrates)
    }

    func part2() async {
        var yard = CrateYard(stacks: stacks, canMoveMultiple: true)
        yard.execute(instructions)
        
        let topCrates = yard.stacks.map { $0.top()! }.joined()
        print(topCrates)
    }
}


private struct CrateYard {
    var stacks: [CrateStack]
    var canMoveMultiple = false

    mutating func execute(_ instructions: [Instruction], printSteps: Bool = false) {
        
        if printSteps { printYard() }
        for x in instructions {
            if printSteps {
                print("")
                print(x)
                execute(x)
                printYard()
            }
            else {
                execute(x)
            }
        }
    }

    mutating func execute(_ instruction: Instruction) {
        if canMoveMultiple {
            let crates = stacks[instruction.source - 1].removeTop(instruction.count)
            stacks[instruction.destination - 1].add(crates)
        }        
        else { 
            for _ in 0..<instruction.count {
                let crate = stacks[instruction.source - 1].removeTop()!
                stacks[instruction.destination - 1].add(crate)
            }
        }
    }
    
    func printYard() {
        for (i, stack) in stacks.enumerated() {
            print(i+1, "(\(stack.crates.count))", stack.crates.joined())
        }
    }
}


private struct CrateStack {
    private(set) var crates: [String] = []

    mutating func add(_ str: some StringProtocol) {
        crates.append(String(str))
    }
    
    mutating func add(_ strings: [some StringProtocol]) {
        for x in strings {
            add(x)
        }
    }

    mutating func addToBottom(_ str: some StringProtocol) {
        crates.insert(String(str), at: 0)
    }

    mutating func removeTop() -> String? {
        return crates.popLast()
    }
    
    mutating func removeTop(_ n: Int) -> [String] {
        let index = crates.count - n
        let (bottom, top) = crates.divided(at: index)
        crates = Array(bottom)
        return Array(top)
    }

    mutating func invert() {
        crates = crates.reversed()
    }

    func top() -> String? {
        crates.last
    }
}

private struct Instruction: CustomStringConvertible {
    var count: Int
    var source: Int
    var destination: Int

    init?(_ line: Substring) {
        guard let match = line.wholeMatch(of: #/move (\d+) from (\d+) to (\d+)/#)
        else { return nil }

        count = Int(match.1)!
        source = Int(match.2)!
        destination = Int(match.3)!
    }
    
    var description: String {
        "move \(count) from \(source) to \(destination)"
    }
}

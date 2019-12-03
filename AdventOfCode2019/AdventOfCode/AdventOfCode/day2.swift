//
//  day2.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/2/19.
//  Copyright © 2019 Bloom Built, Inc. All rights reserved.
//

import Foundation

let sampleInput = "1,9,10,3,2,3,11,0,99,30,40,50\n"

struct IntcodeComputer {

    private let inputMemory: [Int]
    private var memory: [Int]
    private var input1: Int {
        get { memory[1] }
        set { memory[1] = newValue }
    }
    private var input2: Int {
        get { memory[2] }
        set { memory[2] = newValue }
    }
    private var output: Int { memory[0] }

    private var instructionPointer: Int = 0

    init(memory: [Int]) {
        self.inputMemory = memory
        self.memory = []
    }

    mutating func execute(input1: Int, input2: Int) -> Int {

        self.memory = self.inputMemory
        self.instructionPointer = 0

        self.input1 = input1
        self.input2 = input2

        repeat {
            let stepResult = step()
            if stepResult == .finish {
                break
            }
        } while true

        return output
    }


    enum StepResult {
        case `continue`
        case finish
    }

    mutating func step() -> StepResult {

        var currentOpcode: Int { memory[instructionPointer] }
        var arg1: Int { memory[instructionPointer+1] }
        var arg2: Int { memory[instructionPointer+2] }
        var arg3: Int { memory[instructionPointer+3] }

        switch currentOpcode {
        case 1:
            memory[arg3] = memory[arg1] + memory[arg2]
            instructionPointer += 4
        case 2:
            memory[arg3] = memory[arg1] * memory[arg2]
            instructionPointer += 4
        case 99:
            return .finish
        case let x:
            print("Error interpreting program; found opcode \(x)")
            return .finish
        }

        return .continue
    }
}


func runPuzzle2(_ optInputFile: URL?) throws {
    let input: String
    if let inputFile = optInputFile {
        input = try String(contentsOf: inputFile, encoding: .utf8)
    }
    else {
        input = sampleInput
    }
    let inputNumbers = input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: ",")
        .compactMap { Int($0) }

    var cpu = IntcodeComputer(memory: inputNumbers)
    let firstResult = cpu.execute(input1: 12, input2: 2)
    let secondResult = cpu.execute(input1: 12, input2: 2)


    print("Result of (12, 2) input:")
    print(firstResult)

    outer: for noun in (0...99) {
        for verb in (0...99) {
            let result = cpu.execute(input1: noun, input2: verb)
            if result == 19690720 {
                print("Found correct inputs: (\(noun), \(verb))")
                break outer
            }
        }
    }

}

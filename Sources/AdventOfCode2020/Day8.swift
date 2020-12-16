//
//  Day5.swift
//  
//
//  Created by BJ Homer on 12/5/20.
//

import Foundation
import AdventCore
import Algorithms

func day8(input: Data) {
    let str = String(decoding: input, as: UTF8.self)

    let program = Program(str)
    part1(program)
    part2(program)
}

private func part1(_ program: Program) {
    do {
        try program.run()
    }
    catch let error as Program.ExecutionError where error.reason == .infiniteLoop {
        print("Part 1:", error.state.accumulator)
    }
    catch {
        print("Part 1 error:", error)
    }
}

private func part2(_ program: Program) {
    for i in 0..<program.instructions.count {
        var altProgram = program
        
        switch program.instructions[i].opcode {
        case .acc: continue
        case .jmp:
            altProgram.instructions[i].opcode = .nop
            if let state = try? altProgram.run() {
                // We found the instruction that makes it succeed!
                print("Part 2:", state.accumulator)
                return
            }

        case .nop:
            altProgram.instructions[i].opcode = .jmp
            if let state = try? altProgram.run() {
                // We found the instruction that makes it succeed!
                print("Part 2:", state.accumulator)
                return
            }
        }

    }
}


private struct Instruction {
    enum OpCode: String {
        case acc
        case nop
        case jmp
    }

    var opcode: OpCode
    var arg: Int
    var lineNumber: Int

    init?<Str>(_ line: Str, lineNumber: Int) where Str: StringProtocol {
        guard let (opcodeStr, argStr) = line.split(separator: " ").explode(),
              let opcode = OpCode(rawValue: String(opcodeStr)),
              let arg = Int(argStr)
              else { return nil }
        self.opcode = opcode
        self.arg = arg
        self.lineNumber = lineNumber
    }

    func execute(state: inout Program.State) {
        switch opcode {
        case .acc:
            state.accumulator += arg
            state.pc += 1
        case .jmp:
            state.pc += arg
        case .nop:
            state.pc += 1
        }
    }
}

private struct Program {
    var instructions: [Instruction]

    init(_ string: String) {
        instructions = string.split(separator: "\n")
            .enumerated()
            .compactMap({ Instruction($0.1, lineNumber: $0.0) })
    }

    @discardableResult
    func run() throws -> State {
        var state = State()
        var seenLines: Set<Int> = []

        while true {
            if state.pc == instructions.count {
                // Successful termination!
                break
            }

            guard instructions.indices.contains(state.pc)
            else { throw ExecutionError(.invalidPC, state) }

            let inst = instructions[state.pc]
            if seenLines.contains(inst.lineNumber) {
                throw ExecutionError(.infiniteLoop, state)
            }

            instructions[state.pc].execute(state: &state)
            seenLines.insert(inst.lineNumber)
        }
        return state
    }
}

private extension Program {
    struct State {
        var pc: Int = 0
        var accumulator: Int = 0
    }

    struct ExecutionError: Error {
        var reason: Reason
        var state: State

        init(_ reason: Reason, _ state: State) {
            self.reason = reason
            self.state = state
        }

        enum Reason {
            case infiniteLoop
            case invalidPC
        }

        static func ~=(lhs: ExecutionError, rhs: Reason) -> Bool {
            return lhs.reason == rhs
        }
    }
}

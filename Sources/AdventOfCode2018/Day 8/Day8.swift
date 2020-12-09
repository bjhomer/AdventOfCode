//
//  Day7.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/23/17.
//  Copyright © 2017 BJ Homer. All rights reserved.
//

import Foundation



func day8() {
    
    let inputURL = Bundle.main.url(forResource: "Day8Input", withExtension: "txt")!
    let input = try! String(contentsOf: inputURL)
    let lines = input.components(separatedBy: "\n")
    
    struct Instruction {
        var targetRegister: String
        var delta: Int
        var conditionRegister: String
        var condition: (Int)->Bool
        
        init?(_ string: String) {
            guard string.isEmpty == false else { return nil }
            
            let regex = try! NSRegularExpression(pattern: """
            (?<target>\\w+) (?<operation>inc|dec) (?<amount>(\\d|-)+) if (?<conditionReg>\\w+) (?<conditionOperation>[!<>=]*) (?<conditionAmount>(\\d|-)+)
            """)
            
            guard let match = regex.firstMatch(in: string) else {
                print("invalid instruction: \(string)")
                return nil
                
            }
            let result = MatchedString(string: string, match: match)
            guard let targetRegister = result.string(named: "target"),
                let operation = result.string(named: "operation"),
                let amountStr = result.string(named: "amount"),
                let amount = Int(amountStr),
                let conditionRegister = result.string(named: "conditionReg"),
                let conditionOp = result.string(named: "conditionOperation"),
                let conditionAmountStr = result.string(named: "conditionAmount"),
                let conditionAmount = Int(conditionAmountStr)
                else {
                    print("invalid instruction: \(string)")
                    return nil
                    
            }
            
            
            self.targetRegister = targetRegister
            
            switch operation {
            case "inc": self.delta = amount
            case "dec": self.delta = -1 * amount
            default: fatalError("Unknown operation: \(operation)")
            }
            
            self.conditionRegister = conditionRegister
            
            switch conditionOp {
            case ">": self.condition = { $0 > conditionAmount }
            case ">=": self.condition = {$0 >= conditionAmount }
            case "<": self.condition = {$0 < conditionAmount}
            case "<=": self.condition = {$0 <= conditionAmount}
            case "!=": self.condition = {$0 != conditionAmount}
            case "==": self.condition = {$0 == conditionAmount}
            default: fatalError("Unknown condition operation: \(conditionOp)")
            }
        }
    }

    let instructions = lines.flatMap(Instruction.init)
    
    var registers: [String: Int] = [:]
    
    var maxKnownValue = 0
    
    for instruction in instructions {
        let conditionValue = registers[instruction.conditionRegister] ?? 0
        if instruction.condition(conditionValue) {
            registers[instruction.targetRegister, default: 0] += instruction.delta
            if let value = registers[instruction.targetRegister],
                value > maxKnownValue {
                maxKnownValue = value
            }
        }
    }
    
//    print("Registers: \(registers)")
    print("Finished applying \(instructions.count) instructions")
    print("Maximum register value: \(registers.values.max() ?? 0)")
    print("Maximum intermediateValue: \(maxKnownValue)")
    
    
}

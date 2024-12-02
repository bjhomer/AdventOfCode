//
//  Day1.swift
//  
//
//  Created by BJ Homer on 12/6/20.
//

import Foundation

func day1(input: String) {

    let part1 = input.reduce(0) { (last, char) -> Int in
        switch char {
        case "(": return last + 1
        case ")": return last - 1
        default: return last
        }
    }

    print("Part 1: \(part1)")


    var floor = 0
    var basementInstruction: Int? = nil
    for (n, c) in input.enumerated() {
        switch c {
        case "(": floor += 1
        case ")": floor -= 1
        default: break
        }
        if floor < 0 {
            basementInstruction = n + 1
            break
        }
    }
    print("Part 2: \(basementInstruction.map { String($0) } ?? "None")")

}

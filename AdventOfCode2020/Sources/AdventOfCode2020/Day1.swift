//
//  Day1.swift
//  AdventOfCode2020
//
//  Created by BJ Homer on 12/1/20.
//

import Foundation

struct Day1: DailyChallenge {
    static func run(input: Data) {
        day1part1(input: input)
        day1part2(input: input)
    }
}

private func day1part1(input: Data)  {
    print("------")
    print("Part 1:")
    let numbers = String(decoding: input, as: UTF8.self)
        .split(separator: "\n")
        .compactMap { Int($0) }

    for i in numbers {
        for j in numbers {
            if i + j == 2020 {
                print(i * j)
                return
            }
        }
    }
    print("No match found")
}

private func day1part2(input: Data) {
    print("------")
    print("Part 2:")
    let numbers = String(decoding: input, as: UTF8.self)
        .split(separator: "\n")
        .compactMap { Int($0) }

    let indices = numbers.indices
    for i in indices {
        for j in indices where i != j {
            for k in indices where i != k && j != k {
                let a = numbers[i]
                let b = numbers[j]
                let c = numbers[k]

                if a + b + c == 2020 {
                    print(a*b*c)
                    return
                }
            }
        }
    }
    print("No match found")
}

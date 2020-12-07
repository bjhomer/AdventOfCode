//
//  Day2.swift
//  
//
//  Created by BJ Homer on 12/6/20.
//

import Foundation


func day2(input: String) {
    let lines = input .split(separator: "\n")

    let boxes = lines
        .map { Box($0) }

    let part1 = boxes
        .map { $0.wrappingArea }
        .reduce(0, +)

    print("Part 1:", part1)

    let part2 = boxes
        .map { $0.ribbonLength }
        .reduce(0, +)

    print("Part 2:", part2)

}


private struct Box {
    var length: Int
    var width: Int
    var height: Int

    init<S>(_ string: S) where S: StringProtocol {
        let components = string
            .split(separator: "x")
            .map { Int($0)! }
        length = components[0]
        width = components[1]
        height = components[2]
    }

    var volume: Int { length * width * height }

    var wrappingArea: Int {
        let a = length * width
        let b = length * height
        let c = width * height

        return 2*a + 2*b + 2*c + min(a, b, c)
    }

    var ribbonLength: Int {
        let a = 2 * (length + width)
        let b = 2 * (length + height)
        let c = 2 * (width + height)

        let baseLength = min(a, b, c)
        let ribbonLength = baseLength + volume
        return ribbonLength
    }
}

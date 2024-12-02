//
//  File.swift
//  
//
//  Created by BJ Homer on 12/6/20.
//

import Foundation
import AdventCore
import Algorithms


func day10(input: String) {
    var result = input.trimmingCharacters(in: .whitespacesAndNewlines)
    for _ in 1...40 {
        result = step(result)
    }

    print("Part 1:")
    print(result.count)

    for _ in 41...50 {
        result = step(result)
    }

    print("Part 2:")
    print(result.count)

}


private func step(_ string: String) -> String {
    let chunks = string.chunked(on: { $0 }).map(\.1)
    let result =
        chunks.map { (chunk) in "\(chunk.count)\(chunk.first!)"}
        .joined()
    return result
}

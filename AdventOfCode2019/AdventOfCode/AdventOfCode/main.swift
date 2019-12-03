//
//  main.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/1/19.
//  Copyright © 2019 Bloom Built, Inc. All rights reserved.
//

import Foundation
import Darwin

let puzzleNumber = Int(CommandLine.arguments[1])!
let inputFile: URL?

if CommandLine.arguments.count > 2 {
    if CommandLine.arguments[2] == "input" {
        let mainURL = URL(fileURLWithPath: #file)
        let inputURL = mainURL.deletingLastPathComponent().appendingPathComponent("day\(puzzleNumber)input.txt")
        inputFile = inputURL
    }
    else {
        inputFile = URL(fileURLWithPath: CommandLine.arguments[2])
    }
}
else {
    inputFile = nil
}

do {
    switch puzzleNumber {
    case 1:
        try runPuzzle1(inputFile!)
    case 2:
        try runPuzzle2(inputFile)
    default:
        print("Unknown puzzle number")
    }
}
catch {
    print("Error running puzzle: \(error)")
}

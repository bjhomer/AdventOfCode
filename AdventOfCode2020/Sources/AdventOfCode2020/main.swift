//
//  main.swift
//  AdventOfCode2020
//
//  Created by BJ Homer on 12/1/20.
//


import ArgumentParser
import Foundation

protocol DailyChallenge {
    static func run(input: Data)
}

struct Advent: ParsableCommand {
    @Argument(help: "Which day should we run?") var day: Int = 3

    var inputFile: URL {
        let thisFile = URL(fileURLWithPath:#file)
        let sourcesDir = thisFile.deletingLastPathComponent().deletingLastPathComponent()
        let inputsDir = sourcesDir.deletingLastPathComponent().appendingPathComponent("Inputs/")
        let inputFile = inputsDir.appendingPathComponent("Day\(day).txt")
        return inputFile
    }

    func run() throws {

        guard let data = try? Data(contentsOf: inputFile) else {
            print("No data found at \(inputFile)")
            return
        }

        print("Running day \(day)")
        switch day {
        case 1: Day1.run(input: data)
        case 2: Day2.run(input: data)
        case 3: Day3.run(input: data)
        default:
            print("Unrecognized day")
        }
    }
}

Advent.main()



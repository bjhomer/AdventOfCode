//
//  main.swift
//  AdventOfCode2021
//
//  Created by BJ Homer on 12/1/20.
//


import ArgumentParser
import Foundation

let days: [Day.Type] = [Day1.self, Day2.self, Day3.self, Day4.self, Day5.self]

@main
struct Advent: AsyncParsableCommand {
    @Flag(inversion: .prefixedNo, help: "Run the sample input instead of the default input")
    var sample = false

    @Argument(help: "Which day should we run?")
    var day: Int = 5

    var inputFile: URL { sample ? sampleFile : problemFile }

    var problemFile: URL {
        let thisFile = URL(fileURLWithPath: #file)
        let inputsDir = thisFile.deletingLastPathComponent().appendingPathComponent("Inputs/")
        let inputFile = inputsDir.appendingPathComponent("Day\(day).txt")
        return inputFile
    }

    var sampleFile: URL {
        let thisFile = URL(fileURLWithPath: #file)
        let inputsDir = thisFile.deletingLastPathComponent().appendingPathComponent("Inputs/")
        let inputFile = inputsDir.appendingPathComponent("Day\(day)Sample.txt")
        return inputFile
    }

    func run() async throws {

        print("Running day \(day)")

        let dayType = days[day-1]
        let day = try await dayType.init(input: inputFile)

        print("Part 1")
        print("------")
        await day.part1()

        print("\nPart 2")
        print("------")
        await day.part2()
    }
}

protocol Day {
    init(input: URL) async throws
    func part1() async
    func part2() async
}

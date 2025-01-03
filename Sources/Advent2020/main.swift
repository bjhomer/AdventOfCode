//
//  main.swift
//  AdventOfCode2020
//
//  Created by BJ Homer on 12/1/20.
//


import ArgumentParser
import Foundation


struct Advent: ParsableCommand {
    @Argument(help: "Which day should we run?") var day: Int = 16

    var inputFile: URL {
        let thisFile = URL(fileURLWithPath:#filePath)
        let inputsDir = thisFile.deletingLastPathComponent().appendingPathComponent("Inputs/")
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
        case 1: day1(input: data)
        case 2: day2(input: data)
        case 3: day3(input: data)
        case 4: day4(input: data)
        case 5: day5(input: data)
        case 6: day6(input: data)
        case 7: day7(input: data)
        case 8: day8(input: data)
        case 9: day9(input: data)
        case 10: day10(input: data)
        case 11: day11(input: data)
        case 12: day12(input: data)
        case 13: day13(input: data)
        case 14: day14(input: data)
        case 15: day15(input: data)
        case 16: day16(input: data)
        case 17: day17(input: data)
        default:
            print("Unrecognized day")
        }
    }
}

Advent.main()



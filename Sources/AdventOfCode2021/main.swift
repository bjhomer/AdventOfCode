//
//  main.swift
//  AdventOfCode2021
//
//  Created by BJ Homer on 12/1/20.
//


import ArgumentParser
import Foundation

struct Advent: ParsableCommand {
    @Flag(inversion: .prefixedNo, help: "Run the sample input instead of the default input")
    var sample = true

    @Argument(help: "Which day should we run?")
    var day: Int = 1

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

    func run() throws {

        print("Running day \(day)")
        switch day {
        case 1: day1(input: inputFile)
//        case 2: day2(input: inputFile)
//        case 3: day3(input: inputFile)
//        case 4: day4(input: inputFile)
//        case 5: day5(input: inputFile)
//        case 6: day6(input: inputFile)
//        case 7: day7(input: inputFile)
//        case 8: day8(input: inputFile)
//        case 9: day9(input: inputFile)
//        case 10: day10(input: inputFile)
//        case 11: day11(input: inputFile)
//        case 12: day12(input: inputFile)
//        case 13: day13(input: inputFile)
//        case 14: day14(input: inputFile)
//        case 15: day15(input: inputFile)
//        case 16: day16(input: inputFile)
//        case 17: day17(input: inputFile)
//        case 18: day18(input: inputFile)
//        case 19: day19(input: inputFile)
//        case 20: day20(input: inputFile)
//        case 21: day21(input: inputFile)
//        case 22: day22(input: inputFile)
//        case 23: day23(input: inputFile)
//        case 24: day24(input: inputFile)

        default:
            print("Unrecognized day")
        }
    }
}


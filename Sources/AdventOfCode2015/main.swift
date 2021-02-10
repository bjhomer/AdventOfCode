import ArgumentParser
import Foundation

struct Advent: ParsableCommand {
    @Argument(help: "Which day should we run?") var day: Int = 12

    var inputFile: URL {
        let thisFile = URL(fileURLWithPath:#file)
        let inputsDir = thisFile.deletingLastPathComponent().appendingPathComponent("Inputs/")
        let inputFile = inputsDir.appendingPathComponent("Day\(day).txt")
        return inputFile
    }

    func run() throws {

        guard let str = try? String(contentsOf: inputFile) else {
            print("No data found at \(inputFile)")
            return
        }

        print("Running day \(day)")
        switch day {
        case 1: day1(input: str)
        case 2: day2(input: str)
        case 3: day3(input: str)
        case 4: day4(input: str)
        case 5: day5(input: str)
        case 6: day6(input: str)
        case 7: day7(input: str)
        case 8: day8(input: str)
        case 9: day9(input: str)
        case 10: day10(input: str)
        case 11: day11(input: str)
        case 12: day12(input: str)
        default:
            print("Unrecognized day")
        }
    }
}

Advent.main()


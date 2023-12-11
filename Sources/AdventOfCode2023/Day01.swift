import Algorithms
import AdventCore

struct Day01: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    // Splits input data into its component parts and convert from string.
    var rows: [String] {
        data.split(separator: "\n").map(String.init)
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Int {
        let answer = rows
            .map { $0.extractDigits() }
            .map { 10*$0.first! + $0.last! }
            .reduce(0, +)

        return answer
    }
}

private extension String {
    func extractDigits() -> [Int] {
        return self.filter(\.isNumber).map { $0.wholeNumberValue! }
    }
}

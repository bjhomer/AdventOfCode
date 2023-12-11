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

    func part2() -> Int {
        let answer = rows
            .map { $0.extractNumbers() }
            .map { 10*$0.first! + $0.last! }
            .reduce(0, +)
        return answer
    }
}

private extension String {
    func extractDigits() -> [Int] {
        return self.filter(\.isNumber).map { $0.wholeNumberValue! }
    }

    func extractNumbers() -> [Int] {
        self.indices.compactMap { self[$0...].startingNumber() }
    }
}

private extension Substring {
    func startingNumber() -> Int? {
        if let match = self.prefixMatch(of: /(\d)/) {
            return Int(match.1)
        }

        let words = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
        
        let value = words
            .indexed()
            .first { (idx, word) in self.hasPrefix(word) }
            .map { $0.index + 1}

        return value
    }
}

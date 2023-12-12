import Algorithms
import AdventCore

struct Day02: AdventDay {
    

    var data: String

    private var games: [Game] {
        data.lines.compactMap { Game(line: $0) }
    }

    func part1() -> Int {
        games
            .filter { $0.isPossible(with: .default) }
            .map(\.id)
            .reduce(0, +)
    }

    func part2() -> Int {
        games.map { $0.minimalSetPower() }
            .reduce(0, +)
    }

}


private struct Draw {
    enum Color: String, CaseIterable {
        case red, green, blue
    }
    var counts: [Color: Int] = [:]

    init(parsing line: Substring) {
        for match in line.matches(of: /(\d+) (red|green|blue)/) {
            let count = Int(match.1)!
            let color = Color(rawValue: match.2.string)!

            counts[color] = count
        }
    }
}

private struct Limits {
    var red: Int
    var green: Int
    var blue: Int

    static var `default`: Limits = .init(red: 12, green: 13, blue: 14)
}

private struct Game {
    var id: Int
    var draws: [Draw]

    init?(line: Substring) {
        guard let match = try! /Game (\d+): (.*)/.wholeMatch(in: line) else { return nil }
        id = Int(match.1)!
        draws = match.2
            .split(separator: ";")
            .map { Draw(parsing: $0) }
    }

    func max(of color: Draw.Color) -> Int {
        draws.compactMap { $0.counts[color] }.max() ?? 0
    }

    func isPossible(with limits: Limits) -> Bool {
        return max(of: .red) <= limits.red
        && max(of: .green) <= limits.green
        && max(of: .blue) <= limits.blue
    }

    func minimalSetPower() -> Int {
        let r = max(of: .red)
        let g = max(of: .green)
        let b = max(of: .blue)

        return r * g * b
    }
}


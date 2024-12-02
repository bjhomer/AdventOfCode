@_exported import Algorithms
@_exported import Collections
import Foundation

public protocol AdventDay: Sendable {
    associatedtype Answer: Sendable = Int

    /// The day of the Advent of Code challenge.
    ///
    /// You can implement this property, or, if your type is named with the
    /// day number as its suffix (like `Day01`), it is derived automatically.
    static var day: Int { get }

    static var inputDataBundle: Bundle { get }

    /// An initializer that uses the provided test data.
    init(data: String)

    /// Computes and returns the answer for part one.
    func part1() async throws -> Answer

    /// Computes and returns the answer for part two.
    func part2() async throws -> Answer
}

public struct PartUnimplemented: Error {
    public let day: Int
    public let part: Int
}

public extension AdventDay {
    // Find the challenge day from the type name.
    static var day: Int {
        let typeName = String(reflecting: Self.self)
        guard let i = typeName.lastIndex(where: { !$0.isNumber }),
              let day = Int(typeName[i...].dropFirst())
        else {
            fatalError(
        """
        Day number not found in type name: \
        implement the static `day` property \
        or use the day number as your type's suffix (like `Day3`).")
        """)
        }
        return day
    }

    var day: Int {
        Self.day
    }

    // Default implementation of `part2`, so there aren't interruptions before
    // working on `part1()`.
    func part2() throws -> Answer {
        throw PartUnimplemented(day: day, part: 2)
    }

    /// An initializer that loads the test data from the corresponding data file.
    init() {
        self.init(data: Self.loadData(challengeDay: Self.day))
    }

    static func loadData(challengeDay: Int) -> String {
        let dayString = String(format: "%02d", challengeDay)
        let dataFilename = "Day\(dayString)"
        let dataURL = inputDataBundle.url(
            forResource: dataFilename,
            withExtension: "txt",
            subdirectory: "Inputs")

        guard let dataURL,
              let data = try? String(contentsOf: dataURL, encoding: .utf8)
        else {
            fatalError("Couldn't find file '\(dataFilename).txt' in the 'Inputs' directory.")
        }

        // On Windows, line separators may be CRLF. Converting to LF so that \n
        // works for string parsing.
        return data.replacingOccurrences(of: "\r", with: "")
    }
}

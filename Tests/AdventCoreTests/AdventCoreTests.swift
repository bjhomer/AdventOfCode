import XCTest
@testable import AdventCore
import AsyncAlgorithms

final class AdventCoreTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

        let pieces = "123 45 - 678 - 910".split(separator: " - ")

        XCTAssert(pieces[0] == "123 45")
        XCTAssert(pieces[1] == "678")
        XCTAssert(pieces[2] == "910")

    }

    func testSplitAsyncSequence() async throws {
        let sequences = try await [10, 20, 30, 0, 20, 30, 40, 0, 20]
            .async
            .split(separator: 0)
            .collect()

        XCTAssertEqual(sequences, [[10, 20, 30], [20, 30, 40], [20]])
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

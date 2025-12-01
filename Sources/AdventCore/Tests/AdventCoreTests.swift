import XCTest
@testable import AdventCore
import AsyncAlgorithms
import Testing

struct AdventCoreTests {
    @Test
    func testSplitSeparator() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

        let pieces = "123 45 - 678 - 910".split(separator: " - ")

        #expect(pieces[0] == "123 45")
        #expect(pieces[1] == "678")
        #expect(pieces[2] == "910")
    }

    @Test
    func testSplitAsyncSequence() async throws {
        let sequences = try await [10, 20, 30, 0, 20, 30, 40, 0, 20]
            .async
            .split(separator: 0)
            .collect()

        #expect(sequences == [[10, 20, 30], [20, 30, 40], [20]])
    }

    @Test
    func testOperators() {
        let result = "abc2334defg"
            .filter { $0.isWholeNumber }
        |> { Int($0) }

        #expect(result == 2334)
    }
}

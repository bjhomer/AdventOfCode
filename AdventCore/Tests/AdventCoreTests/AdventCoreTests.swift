import XCTest
@testable import AdventCore

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

    static var allTests = [
        ("testExample", testExample),
    ]
}

import XCTest
@testable import RunnerToolchain
final class RunnerToolchainTests: XCTestCase {
    func testVersion() {
        XCTAssertEqual(RunnerToolchain.normalizedVersion("16.4"), [16, 4])
        XCTAssertEqual(RunnerToolchain.normalizedVersion("26.0.1"), [26, 0, 1])
    }
    func testMalformedVersion() {
        for value in ["", "16..4", "Xcode", "-1.2"] {
            XCTAssertNil(RunnerToolchain.normalizedVersion(value))
        }
    }
}

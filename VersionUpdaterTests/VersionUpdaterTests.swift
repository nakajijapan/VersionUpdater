import XCTest
@testable import VersionUpdater

final class VersionUpdaterTests: XCTestCase {

    // MARK: - SemanticVersion Parsing

    func testSemanticVersionParsing() {
        let version = SemanticVersion(string: "2.1.3")
        XCTAssertEqual(version.major, 2)
        XCTAssertEqual(version.minor, 1)
        XCTAssertEqual(version.patch, 3)
    }

    func testSemanticVersionParsingPartial() {
        let twoComponents = SemanticVersion(string: "1.2")
        XCTAssertEqual(twoComponents, SemanticVersion(major: 1, minor: 2, patch: 0))

        let oneComponent = SemanticVersion(string: "5")
        XCTAssertEqual(oneComponent, SemanticVersion(major: 5, minor: 0, patch: 0))

        let empty = SemanticVersion(string: "")
        XCTAssertEqual(empty, SemanticVersion(major: 0, minor: 0, patch: 0))
    }

    // MARK: - SemanticVersion Comparison

    func testSemanticVersionComparison() {
        XCTAssertTrue(SemanticVersion(string: "1.0.0") < SemanticVersion(string: "2.0.0"))
        XCTAssertTrue(SemanticVersion(string: "2.0.0") < SemanticVersion(string: "2.1.0"))
        XCTAssertTrue(SemanticVersion(string: "2.1.0") < SemanticVersion(string: "2.1.1"))
        XCTAssertFalse(SemanticVersion(string: "2.0.0") < SemanticVersion(string: "1.9.9"))
        XCTAssertEqual(SemanticVersion(string: "1.0.0"), SemanticVersion(string: "1.0.0"))
    }

    func testSemanticVersionMultiDigitComparison() {
        XCTAssertTrue(SemanticVersion(string: "2.0.2") < SemanticVersion(string: "2.0.11"))
        XCTAssertTrue(SemanticVersion(string: "2.1.0") < SemanticVersion(string: "2.10.0"))
        XCTAssertTrue(SemanticVersion(string: "1.0.0") < SemanticVersion(string: "10.0.0"))
    }

    // MARK: - Update Needed

    @MainActor
    func testIsUpdateNeeded() {
        let updater = VersionUpdater(endPointURL: URL(string: "https://example.com")!)

        XCTAssertFalse(updater.isUpdateNeeded(currentVersion: "2.0.0", requiredVersion: "2.0.0"))
        XCTAssertTrue(updater.isUpdateNeeded(currentVersion: "2.0.0", requiredVersion: "2.0.1"))
        XCTAssertFalse(updater.isUpdateNeeded(currentVersion: "2.0.0", requiredVersion: "1.9.9"))
        XCTAssertTrue(updater.isUpdateNeeded(currentVersion: "2.0.1", requiredVersion: "2.0.2"))
        XCTAssertTrue(updater.isUpdateNeeded(currentVersion: "2.0.1", requiredVersion: "2.0.11"))
        XCTAssertTrue(updater.isUpdateNeeded(currentVersion: "2.1.0", requiredVersion: "2.10.0"))
        XCTAssertTrue(updater.isUpdateNeeded(currentVersion: "1.0.0", requiredVersion: "10.0.0"))
    }

    // MARK: - VersionInfo Decoding

    func testVersionInfoDecoding() throws {
        let json = """
        {
            "required_version": "2.0.0",
            "type": "force",
            "update_url": "https://apps.apple.com/app/id123"
        }
        """.data(using: .utf8)!

        let info = try JSONDecoder().decode(VersionInfo.self, from: json)
        XCTAssertEqual(info.requiredVersion, "2.0.0")
        XCTAssertEqual(info.type, .force)
        XCTAssertEqual(info.updateURL?.absoluteString, "https://apps.apple.com/app/id123")
    }

    func testVersionInfoDecodingOptionalType() throws {
        let json = """
        {
            "required_version": "1.5.0",
            "type": "optional",
            "update_url": "https://apps.apple.com/app/id456"
        }
        """.data(using: .utf8)!

        let info = try JSONDecoder().decode(VersionInfo.self, from: json)
        XCTAssertEqual(info.type, .optional)
    }

    // MARK: - SemanticVersion Description

    func testSemanticVersionDescription() {
        let version = SemanticVersion(string: "3.2.1")
        XCTAssertEqual(version.description, "3.2.1")
    }
}

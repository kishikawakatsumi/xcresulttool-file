@testable import App
import XCTVapor
import Foundation

final class AppTests: XCTestCase {
    func testBase64UUID() throws {
        let uuid = UUID()
        let shortUUID = ShortUUID.generate(from: uuid)
        XCTAssertEqual(shortUUID.count, 22)
        XCTAssertEqual(ShortUUID.decode(shortUUID), uuid.uuidString)
    }
}

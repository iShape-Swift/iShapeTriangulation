import XCTest
@testable import iGeometry

final class iGeometryTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        let iGeom = IntGeom(scale: 1)
        let a: Int64 = 1
        let b = iGeom.float(int: a)
        
        XCTAssertEqual(b, Float(a))
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

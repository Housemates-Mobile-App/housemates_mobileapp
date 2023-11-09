//
//  amenityModelTests.swift
//  housematesTests
//
//  Created by Daniel Fransesco Gunawan on 11/8/23.
//

import XCTest
@testable import housemates

final class AmenityModelTests: XCTestCase {

    var testAmenity1 : Amentity!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testAmenity1 = Amentity(id: 1, name: "toilet 1", in_use: true)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        testAmenity1 = nil
    }
    
    func testInitializeAmenity() {
        XCTAssertEqual(testAmenity1.id, 1)
        XCTAssertEqual(testAmenity1.name, "toilet 1")
        XCTAssertEqual(testAmenity1.in_use, true)
    }

}

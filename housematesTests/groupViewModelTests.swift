//
//  groupViewModelTests.swift
//  housematesTests
//
//  Created by Daniel Gunawan on 12/8/23.
//

import XCTest
@testable import housemates

final class groupViewModelTests: XCTestCase {
    var viewModel: GroupViewModel!

    override func setUpWithError() throws {
        viewModel = GroupViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testGetGroupByID() {
        let testGroups = [
            Group(id:"1", address:"hi",name:"g1",code:"1111"),
            Group(id:"2", address:"io",name:"g2",code:"2222"),
                        ]
        viewModel.groups = testGroups
        
        let selectedGroup = viewModel.getGroupByID("1")
        
        XCTAssertNotNil(selectedGroup)
        XCTAssertEqual(selectedGroup?.id, "1")
        XCTAssertEqual(selectedGroup?.name, "g1")
    }

}

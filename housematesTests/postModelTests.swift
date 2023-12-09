//
//  postModelTests.swift
//  housematesTests
//
//  Created by Daniel Fransesco Gunawan on 11/8/23.
//

import XCTest
@testable import housemates

final class PostModelTests: XCTestCase {
    
    var testTask1 : task!
    var testPost1 : Post!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testTask1 = task(name: "clean dishes", group_id:"2", description:"10 plates", status:task.Status.inProgress, priority:"low", recurrence:.none)
        var testUser1 = User(user_id: "1", first_name: "Daniel", last_name: "Gunawan", phone_number: "123456", email: "dan@gmail.com", birthday: "10/10/2000")
        
        testPost1 = Post(task: testTask1, group_id: "1", created_by: testUser1, num_likes: 3, num_comments: 2, liked_by: [], comments: [], reactions: [])
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        testPost1 = nil
        testTask1 = nil
    }
    
    func testInitializePost() {
        XCTAssertEqual(testPost1.task.name, "clean dishes")
        XCTAssertEqual(testPost1.num_likes, 3)
        XCTAssertEqual(testPost1.num_comments, 2)
    }

}

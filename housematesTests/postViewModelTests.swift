//
//  postViewModelTests.swift
//  housematesTests
//
//  Created by Daniel Gunawan on 12/7/23.
//

import XCTest
@testable import housemates

final class postViewModelTests: XCTestCase {
    var viewModel: PostViewModel!

    override func setUpWithError() throws {
        viewModel = PostViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testCreateDefaultReactions() {
        let viewModel = PostViewModel()
        let defaultReactions = viewModel.createDefaultReactions()

        XCTAssertEqual(defaultReactions["❤️"], ["x"], "Heart emoji should have one default reaction")
        XCTAssertEqual(defaultReactions["😂"], ["x"], "Laughing emoji should have one default reaction")
        XCTAssertEqual(defaultReactions["🤮"]?.isEmpty, true, "Barf emoji should have no default reactions")
        XCTAssertEqual(defaultReactions["👍"]?.isEmpty, true, "Thumbs up emoji should have no default reactions")
    }
    
    func testGetPostListFromActivities() {
        let viewModel = PostViewModel()
        
        let  testUser1 = User(user_id: "1", username: "test", first_name: "Daniel", last_name: "Gunawan", phone_number: "123456", email: "dan@gmail.com", birthday: "10/10/2000")
        
        let testTask1 = task(name: "clean dishes", group_id:"2", description:"10 plates", status:task.Status.inProgress, recurrence:.none)
        
        let testPost1 = Post(task: testTask1, group_id: "1", created_by: testUser1, num_likes: 3, num_comments: 2, liked_by: [], comments: [], reactions: [])
        let testPost2 = Post(task: testTask1, group_id: "1", created_by: testUser1, num_likes: 3, num_comments: 2, liked_by: [], comments: [], reactions: [])
        
        let mockActivities: [(Post, Any)] = [
            (testPost1, "Activity1"),
            (testPost2, "Activity2")
        ]

        let posts = viewModel.getPostListFromActivities(activities: mockActivities)

        XCTAssertEqual(posts.count, mockActivities.count, "Number of posts should match number of activities")
    }
    
    func testGetActivityListFromActivities() {
        let viewModel = PostViewModel()
        
        let  testUser1 = User(user_id: "1", username: "test", first_name: "Daniel", last_name: "Gunawan", phone_number: "123456", email: "dan@gmail.com", birthday: "10/10/2000")
        
        let testTask1 = task(name: "clean dishes", group_id:"2", description:"10 plates", status:task.Status.inProgress, recurrence:.none)
        
        let testPost1 = Post(task: testTask1, group_id: "1", created_by: testUser1, num_likes: 3, num_comments: 2, liked_by: [], comments: [], reactions: [])
        let testPost2 = Post(task: testTask1, group_id: "1", created_by: testUser1, num_likes: 3, num_comments: 2, liked_by: [], comments: [], reactions: [])
        
        let mockActivities: [(Post, Any)] = [
            (testPost1, "Activity1"),
            (testPost2, "Activity2")
        ]

        let activities = viewModel.getActivityListFromActivities(activities: mockActivities)

        XCTAssertEqual(activities.count, mockActivities.count, "Number of activities should match number of activities in the tuple")
    }
    
    func testGetActivity() {
        let testUser1 = User(id: "1", user_id: "1", username: "test", first_name: "Daniel", last_name: "Gunawan", phone_number: "123456", email: "dan@gmail.com", birthday: "10/05/2000")
        let testUser2 = User(id: "2", user_id: "2", username: "test2", first_name: "bob", last_name: "mike", phone_number: "123456", email: "dan@gmail.com", birthday: "10/05/2000")
        let testUser3 = User(id: "3", user_id: "3", username: "test3", first_name: "pop", last_name: "john", phone_number: "123456", email: "dan@gmail.com", birthday: "10/05/2000")
        let testComment1 = Comment(
            text: "mock comment 1",
            date_created: "10-12-2023 10:00 AM",
            created_by: testUser2
        )
        let testComment2 = Comment(
            text: "mock comment 2",
            date_created: "10-12-2023 10:00 AM",
            created_by: testUser3
        )
        let testReaction1 = Reaction(emoji: "❤️", created_by: testUser2, date_created: "10/10/2020")
        let testReaction2 = Reaction(emoji: "😂", created_by: testUser3, date_created: "10/10/2020")
        let testTask = task(name: "clean dishes", group_id:"2", description:"10 plates", status:task.Status.inProgress, recurrence:.none)
        let testPost = Post(
            id: "post1",
            task: testTask,
            group_id: "group1",
            created_by: testUser1,
            num_likes: 5,
            num_comments: 2,
            liked_by: ["user2", "user3"],
            comments: [testComment1, testComment2],
            reactions: [
                testReaction1, testReaction2
            ],
            afterImageURL: "testUrl",
            caption: "testCaption"
        )
        viewModel.posts = [testPost]

        let activities = viewModel.getActivity(user: testUser1)

        XCTAssertFalse(activities.isEmpty, "Activities should not be empty")
        // first 2 should be comments
        if let firstActivityComment = activities[0].1 as? Comment {
            XCTAssertEqual(firstActivityComment.text, testComment1.text, "First activity should be testComment1")
        } else {
            XCTFail("First activity should be a Comment")
        }
        if let secondActivityComment = activities[1].1 as? Comment {
            XCTAssertEqual(secondActivityComment.text, testComment2.text, "Second activity should be testComment2")
        } else {
            XCTFail("Second activity should be a Comment")
        }
        
        //next 2 should be reactions
        if let thirdActivityReaction = activities[2].1 as? Reaction {
            XCTAssertEqual(thirdActivityReaction.emoji, testReaction1.emoji, "Third activity should be testReaction1")
        } else {
            XCTFail("Third activity should be a Reaction")
        }
        if let fourthActivityReaction = activities[3].1 as? Reaction {
            XCTAssertEqual(fourthActivityReaction.emoji, testReaction2.emoji, "Fourth activity should be testReaction2")
        } else {
            XCTFail("Fourth activity should be a Reaction")
        }
    }
    
    func testReactionDict() {
        let viewModel = PostViewModel()
        
        let testUser1 = User(id: "1", user_id: "1", username: "test", first_name: "Daniel", last_name: "Gunawan", phone_number: "123456", email: "dan@gmail.com", birthday: "10/10/2000")
        
        let testUser4 = User(id: "4", user_id: "4", username: "test2",first_name: "Daniel", last_name: "Gunawan", phone_number: "123456", email: "dan@gmail.com", birthday: "10/10/2000")
        
        let testUser5 = User(id: "5", user_id: "5", username: "test4", first_name: "Daniel", last_name: "Gunawan", phone_number: "123456", email: "dan@gmail.com", birthday: "10/10/2000")
        
        let testUser6 = User(id: "6", user_id: "6", username: "test5", first_name: "Daniel", last_name: "Gunawan", phone_number: "123456", email: "dan@gmail.com", birthday: "10/10/2000")
        
        let testTask = task(name: "clean dishes", group_id:"2", description:"10 plates", status:task.Status.inProgress, recurrence:.none)

        let testPost = Post(
            id: "post1",
            task: testTask,
            group_id: "group1",
            created_by: testUser1,
            num_likes: 5,
            num_comments: 3,
            liked_by: ["user2", "user3"],
            comments: [],
            reactions: [
                Reaction(emoji: "❤️", created_by: testUser4, date_created: "10/10/2020"),
                Reaction(emoji: "😂", created_by: testUser5, date_created: "10/10/2020"),
                Reaction(emoji: "❤️", created_by: testUser6, date_created: "10/10/2020")
            ],
            afterImageURL: "testUrl",
            caption: "testCaption"
        )

        let reactionDict = viewModel.reactionDict(post: testPost)

        XCTAssertEqual(reactionDict["❤️"], ["4", "6"], "Heart emoji should have reactions from user4 and user6")
        XCTAssertEqual(reactionDict["😂"], ["5"], "Laughing emoji should have a reaction from user5")
        // Add assertions for other emojis if needed
    }
    
    func testGetTimestamp() {
        let viewModel = PostViewModel()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd.yy h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        let now = Date()
        let oneHourAgo = Calendar.current.date(byAdding: .hour, value: -1, to: now)!
        let oneDayAgo = Calendar.current.date(byAdding: .day, value: -1, to: now)!

        let oneHourAgoString = dateFormatter.string(from: oneHourAgo)
        let oneDayAgoString = dateFormatter.string(from: oneDayAgo)

        // Assuming the test is run immediately and the system time hasn't changed significantly
        XCTAssertEqual(viewModel.getTimestamp(time: oneHourAgoString), "1h", "One hour ago should be represented as '1h'")
        XCTAssertEqual(viewModel.getTimestamp(time: oneDayAgoString), "1d", "One day ago should be represented as '1d'")
        // Add more tests for different time intervals if needed
    }
    
    func testGetPostsForGroup() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yy h:mm a"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let testUser1 = User(id: "1", user_id: "1", username: "test", first_name: "Daniel", last_name: "Gunawan", phone_number: "123456", email: "dan@gmail.com", birthday: "10/10/2000")
        
        let testTask1 = task(name: "clean dishes", group_id:"2", description:"10 plates", status:task.Status.inProgress, date_completed: "01.01.00 12:00 AM", recurrence:.none)
        
        let testTask2 = task(name: "clean dishes", group_id:"2", description:"10 plates", status:task.Status.inProgress, date_completed: "01.01.02 12:00 AM", recurrence:.none)
        
        let testTask3 = task(name: "clean dishes", group_id:"2", description:"10 plates", status:task.Status.inProgress, date_completed: "01.01.99 12:00 AM", recurrence:.none)
        
        let testPost1 = Post(task: testTask1, group_id: "1", created_by: testUser1, num_likes: 3, num_comments: 2, liked_by: [], comments: [], reactions: [])
        
        let testPost2 = Post(task: testTask2, group_id: "1", created_by: testUser1, num_likes: 3, num_comments: 2, liked_by: [], comments: [], reactions: [])
        
        let testPost3 = Post(task: testTask3, group_id: "1", created_by: testUser1, num_likes: 3, num_comments: 2, liked_by: [], comments: [], reactions: [])
        
        viewModel.posts = [testPost1, testPost2, testPost3]
        
        let postsForGroup = viewModel.getPostsForGroup("1")
        
        XCTAssertEqual(postsForGroup.count, 3, "There should be three posts for the group")
        XCTAssertEqual(postsForGroup[0].id, testPost2.id, "First post should be testPost2")
        XCTAssertEqual(postsForGroup[1].id, testPost1.id, "Second post should be testPost1")
        XCTAssertEqual(postsForGroup[2].id, testPost3.id, "Third post should be testPost3")
        
    }
}

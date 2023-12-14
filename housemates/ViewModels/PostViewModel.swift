//
//  GroupViewModel.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/13/23.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseStorage

class PostViewModel: ObservableObject {
    private let postRepository = PostRepository()
    private let taskViewModel = TaskViewModel()
    
    
    @Published var posts: [Post] = []
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        postRepository.$posts
            .receive(on: DispatchQueue.main)
            .sink { updatedPosts in
                self.posts = updatedPosts
            }
            .store(in: &self.cancellables)
        
    }
    
    func create(post: Post) {
        postRepository.create(post)
    }
    
    // DEPRICATED AS OF 12/6/23
    func createDefaultReactions() -> [String: [String]] {
        let heartEmoji = "❤️"
        let laughingEmoji = "😂"
        let barfEmoji = "🤮"
        let thumbsUp = "👍"
        
        let defaultReactions: [String: [String]] = [
            heartEmoji: ["x"],
            laughingEmoji: ["x"],
            barfEmoji: [],
            thumbsUp : []
        ]
        
        return defaultReactions
    }
    
    func getPostListFromActivities(activities: [(Post, Any)] ) -> [Post] {
        var posts = [Post]()
        for item in activities {
            let post = item.0
            posts.append(post)
        }
        return posts
    }
    
    func getActivityListFromActivities(activities: [(Post, Any)] ) -> [Any] {
        var activityList = [Any]()
        for item in activities {
            let activity = item.1
            activityList.append(activity)
        }
        return activityList
    }
    
    // Helper function to get date from item
    func getDateFromItem(_ item: (Post, Any), dateFormatter: DateFormatter) -> Date {
        switch item.1 {
        case let comment as Comment:
            return dateFormatter.date(from: comment.date_created)!
        case let reaction as Reaction:
            return dateFormatter.date(from: reaction.date_created)!
        default:
            fatalError("Unsupported item type")
        }
    }
    
    // Gets a list of comments and reactions by user in reverse chronolgoical order
    func getActivity(user: User) -> ([Post], [Any]) {
        var activity = [(Post, Any)]()
        
        // Get posts by user
        let posts = posts.filter{ $0.created_by.user_id == user.id }
        
        for post in posts {
            // Get comments for post excluding that current user
            let comments = post.comments.filter{ $0.created_by.user_id != user.id}
            
            // Get reactions for post excluding that of current user
            let reactions = post.reactions.filter{ $0.created_by.user_id != user.id}
            
            for comment in comments {
                activity.append((post, comment))
            }
            
            for reaction in reactions {
                activity.append((post, reaction))
            }
        }
        
        // Convert date strings to Date objects
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd.yy h:mm a"
        
        // TODO: SORTING
        // Sort activity array by date in reverse chronological order
       activity.sort { (item1, item2) -> Bool in
           let date1 = getDateFromItem(item1, dateFormatter: dateFormatter)
           let date2 = getDateFromItem(item2, dateFormatter: dateFormatter)
           return date1 > date2
       }
        
        var newPosts = [Post]()
        var actions = [Any]()
        for i in 0..<activity.count {
            let post = activity[i].0
            let action = activity[i].1
            newPosts.append(post)
            actions.append(action)
        }
        
        return (newPosts, actions)
    }
    
    
    func reactionDict(post: Post) -> [String: [String]] {
        // Parse reactions list from post
        let reactions = post.reactions
        
        // Construct dictionary mapping emoji to the list of user_id
        var resultDict = [String: [String]]()
        
        for reaction in reactions {
            let emoji = reaction.emoji
            
            if let userID = reaction.created_by.id // Assuming User has an 'id' property
            {
                if var userIDs = resultDict[emoji] {
                    // If the emoji is already in the dictionary, append the user ID
                    userIDs.append(userID)
                    resultDict[emoji] = userIDs
                } else {
                    // If the emoji is not in the dictionary, create a new entry with the user ID
                    resultDict[emoji] = [userID]
                }
            }
        }
        
        return resultDict
    }
    
    func addReactionAndReact(post : Post, emoji: String, user: User) {
        var updatedPost = post
        var reactions = post.reactions
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yy h:mm a"
        let formattedDate = formatter.string(from: Date())
        
        if let uid = user.id {
            let newReaction = Reaction(emoji: emoji, created_by: user, date_created: formattedDate)
            updatedPost.reactions.append(newReaction)
        }
        
        // Update post
        postRepository.update(updatedPost)
    }
    
  
    func removeReactionFromPost(post: Post, emoji: String, currUser: User) {
        var updatedPost = post
        // Find the index of the reaction with the given emoji and current user ID
        if let index = updatedPost.reactions.firstIndex(where: { $0.emoji == emoji && $0.created_by.user_id == currUser.id }) {
            // Remove the reaction at the found index
            updatedPost.reactions.remove(at: index)
            
            // Update post
            postRepository.update(updatedPost)
        }
    }
    
    func reactToPost(post: Post, emoji: String, currUser: User) {
        var updatedPost = post
        var reactions = post.reactions
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yy h:mm a"
        let formattedDate = formatter.string(from: Date())
        
        if let uid = currUser.id {
            let newReaction = Reaction(emoji: emoji, created_by: currUser, date_created: formattedDate)
            updatedPost.reactions.append(newReaction)
        }
        
        // Update post
        postRepository.update(updatedPost)
    }

    func sharePost(user: User, task: task, image: UIImage, caption: String) async {
        // MARK: Must update task instance to be uploaded in post struct in addition to updating task collection
//        var imageURL = getPostPicURL(image: image)
        guard let imageURL = await getPostPicURL(image: image) else {
            print("Failed to upload image or get URL")
            return
        }
        
        var task = task
        task.date_started = nil
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yy h:mm a"
        let formattedDate = formatter.string(from: Date())
        task.date_completed = formattedDate
        task.status = .done

        // MARK: Create new post instance
        if let group_id = user.group_id {
            let post = Post(task: task, group_id: group_id, created_by: user, num_likes: 0, num_comments: 0, liked_by: [], comments: [], reactions: [], afterImageURL: imageURL, caption: caption)
            create(post: post) // user_id in created_by field is non existent for some reason
            taskViewModel.completeTask(task: task)
        }
    }
    
    func getPostPicURL(image: UIImage) async -> String? {
        let photoID = UUID().uuidString
        let storageRef = Storage.storage().reference().child("\(photoID).jpeg")
        
        guard let resizedImage = image.jpegData(compressionQuality: 0.2) else {
            print("ERROR: Could not resize image")
            return nil
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        do {
            let _ = try await storageRef.putDataAsync(resizedImage, metadata: metadata)
            let imageURL = try await storageRef.downloadURL()
            return imageURL.absoluteString
        } catch {
            print("ERROR: \(error.localizedDescription)")
            return nil
        }
    }
    
  
  func getTimestamp(time: String) -> String? {
      let formatter = DateFormatter()
      formatter.dateFormat = "MM.dd.yy h:mm a"
      formatter.locale = Locale(identifier: "en_US_POSIX")
      guard let completeDate = formatter.date(from: time) else {
          return nil
      }

      let now = Date()
      let calendar = Calendar.current

      let hourDifference = calendar.dateComponents([.hour], from: completeDate, to: now).hour ?? 0
      let minuteDifference = calendar.dateComponents([.minute], from: completeDate, to: now).minute ?? 0
    
      if calendar.isDateInToday(completeDate) || hourDifference < 24 {
          if hourDifference == 0 {
              return minuteDifference == 0 ? "<1m" : "\(minuteDifference)m"
          } else {
              return "\(hourDifference)h"
          }
      } else {
          
          let dayDifference = calendar.dateComponents([.day], from: completeDate, to: now).day ?? 0
          return "\(dayDifference)d"
      }
  }

    func getPostsForUser(user: User) -> [Post] {
        return self.posts.filter{ $0.created_by.user_id == user.user_id}
    }
    
    func getUserPostForDay(user: User, date: Date) -> Post? {
        let UserPosts = getPostsForUser(user: user)
        if posts.isEmpty {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yy h:mm a"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "EST")
        
        for post in UserPosts {
            if let postDate = formatter.date(from: post.task.date_completed!),
               Calendar.current.isDate(date, inSameDayAs: postDate) {
//               print("POST DAY", Calendar.current.component(.day, from: postDate))
//               print("POST MONTH", Calendar.current.component(.month, from: postDate))
//                print("CURR DAY", Calendar.current.component(.day, from: date))
//                print("CURR MONTH", Calendar.current.component(.month, from: date))
//                print(post.afterImageURL)
               return post
            }
        }
        return nil
    }
    
   
    
    // Get list of posts for group in chronogical order
    func getPostsForGroup(_ group_id: String) -> [Post] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yy h:mm a"
        formatter.locale = Locale(identifier: "en_US_POSIX")
      
        return self.posts
            .filter { $0.group_id == group_id }
            .sorted { post1, post2 in
              
             
              guard let date1 = formatter.date(from: post1.task.date_completed ?? "01.01.00 12:00 AM"),
                    let date2 = formatter.date(from: post2.task.date_completed ?? "01.01.00 12:00 AM")
              else {
                  return false
                }
                return date1 > date2
            }
    }
    
    func unlikePost(user: User, post: Post) {
        var post = post
        post.liked_by.removeAll { $0 == user.id }
        post.num_likes -= 1
        postRepository.update(post)
    }
    
    func likePost(user: User, post: Post) {
        var post = post
        post.liked_by.append(user.id!)
        post.num_likes += 1
        postRepository.update(post)
    }
    
    func addComment(user: User, text: String, post: Post) {
        if text == "" {
            return
        }
        var post = post
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yy h:mm a"
        let formattedDate = formatter.string(from: Date())
        let comment = Comment(text: text, date_created: formattedDate, created_by: user)
        post.comments.append(comment)
        post.num_comments += 1
        postRepository.update(post)
    }
}

extension PostViewModel {
    static func mock() -> PostViewModel {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yy h:mm a"
        let formattedDate = formatter.string(from: Date())
        let mockUser =  User(id: "test", user_id: "test", username: "test_username", first_name: "test", last_name: "test", phone_number: "test", email: "test", birthday: "test", group_id: "test")
        let mockTask =  task(name: "Wash The Dishes", group_id: "test", user_id: "test", description: "Wash Dishes and put back into cabinets", status: .done, date_started: nil, date_completed: formattedDate, recurrence: .none)
        let mockReaction = Reaction(emoji: "🍑", created_by: mockUser, date_created: formattedDate)
        let mockPostViewModel = PostViewModel()
        let mockPosts = [Post(task: mockTask, group_id: "test", created_by: mockUser, num_likes: 0, num_comments: 0, liked_by: [], comments: [], reactions: [mockReaction])]
        mockPostViewModel.posts = mockPosts
        return mockPostViewModel
    }
    
    static func mockPost() -> Post {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yy h:mm a"
        let formattedDate = formatter.string(from: Date())
        let mockUser =  User(id: "test", user_id: "xkP2L9pIp5cklnQDD4JYXv0Tow02", username: "tester", first_name: "test", last_name: "test", phone_number: "test", email: "test", birthday: "test", group_id: "test")
        let mockTask =  task(name: "Wash The Dishes", group_id: "test", user_id: "test", description: "Wash Dishes and put back into cabinets", status: .done, date_started: nil, date_completed: formattedDate, recurrence: .none, beforeImageURL: "https://firebasestorage.googleapis.com:443/v0/b/housemates-3b4be.appspot.com/o/C11387A8-885C-4634-91F5-2E76C0278B71.jpeg?alt=media&token=01c5d456-5726-4eb3-a579-46ae25822151")
        let comment = Comment(text: "This is an example comment", date_created: formattedDate , created_by: mockUser)
        let mockReaction = Reaction(emoji: "🍑", created_by: mockUser, date_created: formattedDate)
        return Post(task: mockTask, group_id: "test", created_by: mockUser, num_likes: 0, num_comments: 1, liked_by: [], comments: [comment], reactions: [mockReaction], afterImageURL: "https://firebasestorage.googleapis.com:443/v0/b/housemates-3b4be.appspot.com/o/06F408B1-8D76-499A-8DB9-222FCBA5662A.jpeg?alt=media&token=7a49c9fe-5f89-47fa-bdbe-05b9734a7f99",
        caption: "just coded this shit")
    }
    
    static func mockComment() -> Comment {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yy h:mm a"
        let formattedDate = formatter.string(from: Date())
        let mockUser =  User(id: "test", user_id: "xkP2L9pIp5cklnQDD4JYXv0Tow02", username: "username", first_name: "test", last_name: "test", phone_number: "test", email: "test", birthday: "test", group_id: "test")
        return  Comment(text: "This is an example comment", date_created: formattedDate , created_by: mockUser)

    }
    
    static func mockReaction() -> Reaction {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yy h:mm a"
        let formattedDate = formatter.string(from: Date())
        let mockUser =  User(id: "test", user_id: "xkP2L9pIp5cklnQDD4JYXv0Tow02", username: "tester", first_name: "test", last_name: "test", phone_number: "test", email: "test", birthday: "test", group_id: "test")
        let mockReaction = Reaction(emoji: "🍑", created_by: mockUser, date_created: formattedDate)
        return mockReaction
    }
}


//class ImageUploader {
//    static func uploadImage(_ image: UIImage, completion: @escaping (String) -> Void) {
//        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
//
//        let filename = UUID().uuidString
//        let ref = Storage.storage().reference(withPath: "/post_images/\(filename)")
//
//        ref.putData(imageData, metadata: nil) { _, error in
//            if let error = error {
//                print("Failed to upload image: \(error)")
//                return
//            }
//
//            ref.downloadURL { url, _ in
//                guard let url = url?.absoluteString else { return }
//                completion(url)
//            }
//        }
//    }
//}


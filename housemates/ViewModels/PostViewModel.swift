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
            let post = Post(task: task, group_id: group_id, created_by: user, num_likes: 0, num_comments: 0, liked_by: [], comments: [], imageURLString: imageURL, caption: caption)
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
      formatter.locale = Locale(identifier: "en_US_POSIX") // Correct the locale identifier
      guard let completeDate = formatter.date(from: time) else {
          return nil
      }

      let now = Date()
      let calendar = Calendar.current
      let dayDifference = calendar.dateComponents([.day], from: completeDate, to: now).day
    
      if calendar.isDateInToday(completeDate) || dayDifference == 0 {
          let hourNow = calendar.component(.hour, from: now)
          let hourOfCompleteDate = calendar.component(.hour, from: completeDate)

          if hourNow == hourOfCompleteDate {
              let minComponent = calendar.dateComponents([.minute], from: completeDate, to: now)
              if let minuteDifference = minComponent.minute {
                  return minuteDifference == 0 ? "<1m" : "\(minuteDifference)m"
              }
          } else {
              let hourComponent = calendar.dateComponents([.hour], from: completeDate, to: now)
              if let hourDifference = hourComponent.hour {
                  return "\(hourDifference)h"
              }
          }
      } else {
          if let dayDifference = calendar.dateComponents([.day], from: completeDate, to: now).day {
              return "\(dayDifference)d"
          }
      }

      return nil
  }
  
//  gets it in sorted order too
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
        let mockUser =  User(id: "test", first_name: "test", last_name: "test", phone_number: "test", email: "test", birthday: "test", group_id: "test")
        let mockTask =  task(name: "Wash The Dishes", group_id: "test", user_id: "test", description: "Wash Dishes and put back into cabinets", status: .done, date_started: nil, date_completed: formattedDate, priority: "High", recurrence: .none)
        let mockPosts = [Post(task: mockTask, group_id: "test", created_by: mockUser, num_likes: 0, num_comments: 0, liked_by: [], comments: [])]
        let mockPostViewModel = PostViewModel()
        mockPostViewModel.posts = mockPosts
        return mockPostViewModel
    }
    
    static func mockPost() -> Post {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yy h:mm a"
        let formattedDate = formatter.string(from: Date())
        let mockUser =  User(id: "test", first_name: "test", last_name: "test", phone_number: "test", email: "test", birthday: "test", group_id: "test")
        let mockTask =  task(name: "Wash The Dishes", group_id: "test", user_id: "test", description: "Wash Dishes and put back into cabinets", status: .done, date_started: nil, date_completed: formattedDate, priority: "High", recurrence: .none)
        let comment = Comment(text: "This is an example comment", date_created: formattedDate , created_by: mockUser)
        return Post(task: mockTask, group_id: "test", created_by: mockUser, num_likes: 0, num_comments: 1, liked_by: [], comments: [comment])
    }
    
    static func mockComment() -> Comment {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yy h:mm a"
        let formattedDate = formatter.string(from: Date())
        let mockUser =  User(id: "test", first_name: "test", last_name: "test", phone_number: "test", email: "test", birthday: "test", group_id: "test")
        return  Comment(text: "This is an example comment", date_created: formattedDate , created_by: mockUser)

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


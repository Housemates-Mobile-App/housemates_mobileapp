import SwiftUI

struct TaskView: View {
    let task: task
    let user: User
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var isAddPostViewActive = false
    @State private var showCamera = false
    @State private var capturedImage: UIImage?
    @Environment(\.editMode) var editMode
    
    var body: some View {
      
      
    
      HStack(spacing: 0) {
//          currently a placeholder
       
          ZStack {
            
            Image(task.icon ?? "dalle3")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 40, height: 40)
//              .padding(3)
//  
//              .clipShape(Circle())
//              .overlay(
//                      Circle().stroke(Color.black, lineWidth: 2) // Adjust color and lineWidth as needed
//                  )
       
              .padding(.trailing, 7.5)
//            if task.status != .done {
//
////              priorityLabel
//            }
          }
           
            taskInformationView
            Spacer()
//            if editMode?.wrappedValue.isEditing ?? false {
//                deleteButton
//            } else {
              statusButtonOrLabel
            
        }
      
        .frame(minWidth: 75, minHeight: 45)
        .padding(.vertical, 0)
      
      
//        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.black.opacity(0.1), lineWidth: 1))
//        .shadow(color: Color.black, radius: 1, x: 2, y: 1)
    }

    // MARK: - Task Information View
    @ViewBuilder
    private var taskInformationView: some View {
      VStack(alignment: .leading, spacing: 0) {
//        if task.status != .done && task.priority == "High"{
//
//              priorityLabel.padding(.vertical, 2)
//        }
//        Text and Priority
        HStack(spacing: 0) {
          Text(task.name)
            .font(.custom("Lato-Bold", size: 15))
            .padding(.vertical, 2)
          if task.recurrence != .none {
            Image(systemName: "arrow.2.squarepath")
              .font(.custom("Lato", size: 12))
              .foregroundColor(.blue)
              .padding(.horizontal, 2)
          }
         
            
//            .font(.headline)
          
        }
        
        
        if task.status == .done, let uid = task.user_id, let user = userViewModel.getUserByID(uid) {
          Text("Completed by \(user.first_name) \(user.last_name)")
            .font(.custom("Lato", size: 12))
            .foregroundColor(Color.gray)
//          add else if here
        }
        else if task.status == .inProgress, let uid = task.user_id, let user = userViewModel.getUserByID(uid) {
          Text("Claimed by \(user.first_name) \(user.last_name)")
            .font(.custom("Lato", size: 12))
            .foregroundColor(Color.gray)
          
          
          
        }
        
        else {
          HStack(spacing: 2) {
            
            if task.priority == "High" {
              
              Image(systemName: "alarm.waves.left.and.right.fill")
                .font(.custom("Lato", size: 12))
                .foregroundColor(.red)
              Text("•")
                .font(.custom("Lato", size: 8))
                .foregroundColor(Color.black.opacity(0.25))
              
            }
            
            if let time = task.date_created {
              if let timestamp = taskViewModel.getTimestamp(time: time) {
                Text("Created \(timestamp) ago")
                  .font(.custom("Lato", size: 12))
                  .foregroundColor(Color.black.opacity(0.5))
              }
            
            } else {
              Text("Recurring")
                .font(.custom("Lato", size: 12))
                .foregroundColor(Color.black.opacity(0.5))
            }
            }
          }
        
//        if task.status != .done && task.priority == "High"{
//
//              priorityLabel.padding(.vertical, 2)
//        }
        
        
          
        
      }
    }
  
    // MARK: - Priority Label
    @ViewBuilder
    private var priorityLabel: some View {
 
        switch task.priority {
          case "Low":
          priorityTag(Color.green.opacity(0.75), Color.green)
          case "Medium":
          priorityTag(Color.yellow.opacity(0.75), Color.yellow)
          default:
          priorityTag(Color.red.opacity(0.75), Color.red)
        }
      
    }
  
    @ViewBuilder
  private func priorityTag(_ color: Color, _ text: Color) -> some View {
    //        Circle()
    //              .fill(color)
    //              .frame(width: 15, height: 15)
    //      ZStack {
    //
    //        Image(systemName: "face.smiling.inverse")
    //          .font(.system(size: 12))
    //          .foregroundColor(color)
    //          .overlay(Circle().stroke(Color.white, lineWidth: 2))
    //          .background(Color.white)
    //          .clipShape(Circle())
    //
    //
    //        Image(systemName: "face.smiling.inverse")
    //          .font(.system(size: 12))
    //          .foregroundColor(color)
    //          .overlay(Circle().stroke(text, lineWidth: 2))
    //
    //      }
    
    HStack(spacing: 1.5) {
//      Image(systemName: "exclamationmark.square.fill")
      //          .font(.system(size: 12))
      Text(task.priority.uppercased())
//      Image(systemName: "exclamationmark.square.fill")
    }
    .font(.custom("Lato-Bold", size: 12))
//    .padding(.horizontal, 5)
//    .padding(.vertical, 3)
    .foregroundColor(.red)
//    .background(color)
//    .cornerRadius(5)
  }
      
       
    

    

    // MARK: - Delete Button
//    private var deleteButton: some View {
//        Button("Delete", action: {
//            taskViewModel.destroy(task: task)
//        })
//        .buttonStyle(DeleteButtonStyle())
//    }

    // MARK: - Status Button or Label
    @ViewBuilder
    private var statusButtonOrLabel: some View {
        switch task.status {
        case .done:
            Label("DONE", systemImage: "checkmark.circle.fill").labelStyle(.iconOnly).foregroundColor(.green)
        case .inProgress:
            inProgressView
        case .unclaimed:
            claimButton
        }
    }

    // MARK: - In Progress View
    @ViewBuilder
    private var inProgressView: some View {
        if taskViewModel.isMyTask(task: task, user_id: user.id ?? "") {
//            NavigationLink(destination: AddPostView(task: task, user: user)) {
//                Text("Done")
//            }.buttonStyle(DoneButtonStyle())
            Button(action: {
                // Handle button tap action here
                // Navigate to AddPostView or perform any other action
                isAddPostViewActive = true
                showCamera = true
            }) {
                Text("DONE")
            }
            .sheet(isPresented: $showCamera) {
                CameraView(image: $capturedImage, isShown: $showCamera)
            }
            .onChange(of: capturedImage) { _ in
                if let _ = capturedImage {
                    isAddPostViewActive = true
                }
            }
            .buttonStyle(DoneButtonStyle())
            .background(
                NavigationLink(destination: AddPostView(task: task, user: user, image: capturedImage), isActive: $isAddPostViewActive) {
                        EmptyView()
                    }
                    .hidden()
                )
        } else if let uid = task.user_id, let user = userViewModel.getUserByID(uid) {
            userProfileImage(for: user)
        }
    }

    // MARK: - Claim Button
    private var claimButton: some View {
        Button("CLAIM", action: {
            
          self.showCamera = true
          
//          DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            if let uid = user.id {
//                taskViewModel.claimTask(task: task, user_id: uid)
//           
//            }
//          }
            
        })
        .buttonStyle(ClaimButtonStyle())
        .sheet(isPresented: $showCamera) {
            CameraView(image: $capturedImage, isShown: $showCamera)
        }
        .onChange(of: capturedImage) { _ in
            if let image = capturedImage {
                  if let uid = user.id {
                      Task {
                          await taskViewModel.claimTask(task: task, user_id: uid, image: image)
                  }
                }
            }
        }
    }

    // MARK: - User Profile Image
    private func userProfileImage(for user: User) -> some View {
        AsyncImage(url: URL(string: user.imageURLString ?? "")) { image in
            image.resizable()
        } placeholder: {
            Image(systemName: "person.circle").resizable()
        }
        .aspectRatio(contentMode: .fill)
        .frame(width: 35, height: 35)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.white, lineWidth: 2))
        .padding(5)
    }
}

// MARK: - Custom Button Styles
struct DoneButtonStyle: ButtonStyle {
    let lightGreen = Color(red: 0.10, green: 0.85, blue: 0.23)
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("Lato-Bold", size: 12))
            .foregroundColor(.white)
            .padding(.horizontal)
            .padding(.vertical, 5)
            .background(lightGreen)
            .cornerRadius(16)
    }
}

struct ClaimButtonStyle: ButtonStyle {
    let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("Lato-Bold", size: 12))
            .foregroundColor(.white)
            .padding(.horizontal)
            .padding(.vertical, 5)
            .background(deepPurple)
            .cornerRadius(16)
    }
}



//struct DeleteButtonStyle: ButtonStyle {
//    func makeBody(configuration: Self.Configuration) -> some View {
//        configuration.label
//            .padding(.horizontal)
//            .padding(.vertical, 4)
//            .foregroundColor(Color.red)
//            .font(.custom("Lato-Bold", size: 12))
////            .font(.system(size: 12))
////            .bold()
//            .cornerRadius(16)
//            .overlay(
//                RoundedRectangle(cornerRadius: 16)
//                  .stroke(Color.red, lineWidth: 2)
//
//
//            )
//            .overlay(
//                  RoundedRectangle(cornerRadius: 16)
//                    .stroke(Color.red, lineWidth: configuration.isPressed ? 0 : 4)
//                    .padding(.top, -1.25)
//                    .offset(x: 0, y: configuration.isPressed ? 0 : 1))
//
//            .scaleEffect(configuration.isPressed ? 1.0 : 1.0)
//            .offset(x: 0, y: configuration.isPressed ? 3 : 1)
//
//    }
//}







//
//struct DoneButtonStyle: ButtonStyle {
//    let lightGreen = Color(red: 0.10, green: 0.85, blue: 0.23)
//    let deepGreen = Color(red: 0.3 * 0.85, green: 1.0 * 0.85, blue: 0.31 * 0.85)
//    let darkGreen = Color(red: 0.3 * 0.5, green: 1.0 * 0.5, blue: 0.31 * 0.5)
//    func makeBody(configuration: Configuration) -> some View {
//            ZStack {
//                configuration.label
//                    .font(.custom("Lato-Bold", size: 12))
//                    .padding(.horizontal)
//                    .padding(.vertical, 5)
//
//                    .background(configuration.isPressed ? Color.white : darkGreen)
//                    .cornerRadius(16)
//
//                configuration.label
//                    .font(.custom("Lato-Bold", size: 12))
//                    .foregroundColor(.white)
//                    .padding(.horizontal)
//                    .padding(.vertical, 4)
//                    .background(lightGreen)
//                    .cornerRadius(16)
//                    .offset(x: configuration.isPressed ? 0 : 0, y: configuration.isPressed ? 0 : -2)
//            }
//        }
//
//}
//
//struct ClaimButtonStyle: ButtonStyle {
//    let lightPurple = Color(red: 0.439 * 1.5, green: 0.298 * 1.5, blue: 1.0 * 1.5)
//    let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)
//    let darkPurple = Color(red: 0.439 * 0.6, green: 0.298 * 0.6, blue: 1.0 * 0.6)
//
//    func makeBody(configuration: Configuration) -> some View {
//            ZStack {
//                configuration.label
//                    .font(.custom("Lato-Bold", size: 12))
//                    .padding(.horizontal)
//                    .padding(.vertical, 5)
//
//                    .background(configuration.isPressed ? Color.white : darkPurple)
//                    .cornerRadius(16)
//
//                configuration.label
//                    .font(.custom("Lato-Bold", size: 12))
//                    .foregroundColor(.white)
//                    .padding(.horizontal)
//                    .padding(.vertical, 4)
//                    .background(lightPurple)
//                    .cornerRadius(16)
//                    .offset(x: configuration.isPressed ? 0 : 0, y: configuration.isPressed ? 0 : -2)
//            }
//        }
//
//}




// MARK: - TaskView Previews
//struct TaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskView(task: TaskViewModel.mockTask(), user: UserViewModel.mockUser())
//            .environmentObject(UserViewModel())
//    }
//}

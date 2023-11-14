import SwiftUI

struct TaskView: View {
    let task: task
    let user: User
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userViewModel: UserViewModel

    @Environment(\.editMode) var editMode
    
    var body: some View {
        HStack {
//          currently a placeholder
            Image("dalle4")
            taskInformationView
            Spacer()
            if editMode?.wrappedValue.isEditing ?? false {
                deleteButton
            } else {
                statusButtonOrLabel
            }
        }
        .frame(minWidth: 50, minHeight: 45)
        .padding(12.5)
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.black.opacity(0.1), lineWidth: 1))
        .padding(2.5)
    }

    // MARK: - Task Information View
    @ViewBuilder
    private var taskInformationView: some View {
      VStack(alignment: .leading, spacing: 0) {
        
//        Text and Priority
        HStack() {
          Text(task.name).font(.headline)
          if task.status != .done {
            priorityLabel
          }
        }
        
        
        if task.status == .done, let uid = task.user_id, let user = userViewModel.getUserByID(uid) {
          Text("\(user.first_name) \(user.last_name) finished on \(task.date_completed ?? "Unknown")")
            .font(.footnote)
            .foregroundColor(Color.gray)
//          add else if here
        }
        else if task.status == .inProgress, let uid = task.user_id, let user = userViewModel.getUserByID(uid) {
          Text("Claimed by \(user.first_name) \(user.last_name)")
            .font(.footnote)
            .foregroundColor(Color.gray)
          
          
          
        }
        
        else {
          Text("2 days ago")
            .font(.footnote)
            .foregroundColor(Color.black.opacity(0.5))
        }
        
        
          
        
      }
    }
  
    // MARK: - Priority Label
    @ViewBuilder
    private var priorityLabel: some View {
 
        switch task.priority {
          case "Low":
            priorityTag(Color.green.opacity(0.25), Color.black)
          case "Medium":
            priorityTag(Color.yellow.opacity(0.25), Color.black)
          default:
            priorityTag(Color.red.opacity(0.25), Color.black)
        }
      
    }
  
  
    private func priorityTag(_ color: Color, _ text: Color) -> some View {
        Circle()
              .fill(color)
              .frame(width: 15, height: 15)
//        Text(task.priority)
//            .font(.system(size: 12))
//            .padding(.horizontal)
//            .padding(.vertical, 3)
//            .foregroundColor(text)
//            .background(color)
//            .cornerRadius(15)
    }

    

    // MARK: - Delete Button
    private var deleteButton: some View {
        Button("Delete", action: {
            taskViewModel.destroy(task: task)
        })
        .buttonStyle(DeleteButtonStyle())
    }

    // MARK: - Status Button or Label
    @ViewBuilder
    private var statusButtonOrLabel: some View {
        switch task.status {
        case .done:
            Label("Done", systemImage: "checkmark.circle.fill").labelStyle(.iconOnly).foregroundColor(.green)
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
            Button("Done", action: {
                taskViewModel.completeTask(task: task)
            })
            .buttonStyle(DoneButtonStyle())
        } else if let uid = task.user_id, let user = userViewModel.getUserByID(uid) {
            userProfileImage(for: user)
        }
    }

    // MARK: - Claim Button
    private var claimButton: some View {
        Button("Claim", action: {
            if let uid = user.id {
                taskViewModel.claimTask(task: task, user_id: uid)
            }
        })
        .buttonStyle(ClaimButtonStyle())
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
struct DeleteButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .bold()
            .font(.system(size: 12))
            .foregroundColor(.white)
            .padding(.horizontal)
            .padding(.vertical, 4)
            .background(Color.red)
            .cornerRadius(15)
    }
}

struct DoneButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .bold()
            .font(.system(size: 12))
            .foregroundColor(.white)
            .padding(.horizontal)
            .padding(.vertical, 4)
            .background(Color.green)
            .cornerRadius(15)
    }
}

struct ClaimButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .bold()
            .font(.system(size: 12))
            .foregroundColor(.white)
            .padding(.horizontal)
            .padding(.vertical, 4)
            .background(Color(red: 0.439, green: 0.298, blue: 1.0))
            .cornerRadius(15)
    }
}

// MARK: - TaskView Previews
struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView(task: TaskViewModel.mockTask(), user: UserViewModel.mockUser())
            .environmentObject(UserViewModel())
    }
}

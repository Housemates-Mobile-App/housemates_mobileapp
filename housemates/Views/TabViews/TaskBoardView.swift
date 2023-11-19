import SwiftUI

struct TaskBoardView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selected: String = "All Tasks"
    @State private var showTaskSelectionView = false


    var body: some View {
        // Check for current user
        if let user = authViewModel.currentUser {
            NavigationView {
                VStack {
                    // Header Section
                    taskHeader(user: user)

                    // Main Content Section
                    mainContent(user: user)

                }
            }.sheet(isPresented: $showTaskSelectionView) {
                TaskSelectionView(showTaskSelectionView: $showTaskSelectionView, user: user)
            }
        }
    }

    // Task Header View
    private func taskHeader(user: User) -> some View {
        HStack {
            headerTitle()
            Spacer()
            addTaskButton(user: user)
        }
        .padding()
    }

    // Header Title
    private func headerTitle() -> some View {
        Text("Tasks")
            .font(.custom("Nunito-Bold", size: 26))
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
    }

    // Add Task Button
    private func addTaskButton(user: User) -> some View {
        Button(action: {
                showTaskSelectionView = true
           }) {
               Image(systemName: "plus")
                   .font(.headline)
                   .font(.custom("Lato-Bold", size: 15))
                   .imageScale(.small)
                   .foregroundColor(Color.white)
                   .padding(7.5)
                   .background(Circle().fill(Color(red: 0.439, green: 0.298, blue: 1.0)))
                   .fontWeight(.semibold)
           }
    }

    // Main Content Section
    private func mainContent(user: User) -> some View {
      VStack {
        FilterView(selected: $selected).padding(.horizontal)
        taskSections(user: user)
        }
      }

 
    // Task Sections
  private func taskSections(user: User) -> some View {
      List {
          if selected == "Unclaimed" || selected == "All Tasks" {
            Section(header: Text("Unclaimed").font(.custom("Lato-Bold", size: 15))) {
                  ForEach(taskViewModel.getUnclaimedTasksForGroup(user.group_id!)) { task in
                    
                    ZStack {
                      NavigationLink(destination: TaskDetailView(user: user, taskName: task.name, taskDescription: task.description)) {
                      }
                      .opacity(0)
                      
                      taskRow(task: task, user: user)
                        
                    }.listRowSeparator(.hidden)
                  }
              }
          }

          if selected == "In Progress" || selected == "All Tasks" {
              Section(header: Text("In Progress").font(.custom("Lato-Bold", size: 15))) {
                  ForEach(taskViewModel.getInProgressTasksForGroup(user.group_id!)) { task in
                    ZStack {
                      NavigationLink(destination: TaskDetailView(user: user, taskName: task.name, taskDescription: task.description)) {
//                        gets rid of the arrow icon
                          
                      }
                      .opacity(0)
                      
                      taskRow(task: task, user: user)
                        
                    }.listRowSeparator(.hidden)
                  }
              }
          }

          if selected == "Completed" || selected == "All Tasks" {
              Section(header: Text("Completed").font(.custom("Lato-Bold", size: 15))) {
                  ForEach(taskViewModel.getCompletedTasksForGroup(user.group_id!)) { task in
                    ZStack {
                      NavigationLink(destination: TaskDetailView(user: user, taskName: task.name, taskDescription: task.description)) {
                      }
                      .opacity(0)
                      
                      taskRow(task: task, user: user)
                        
                    }.listRowSeparator(.hidden)
                  }
              }
          }
      }
      .listStyle(.plain)
  }


    // Individual Task Section
  private func taskRow(task: task, user: User) -> some View {
      TaskView(task: task, user: user)
          .swipeActions {
              Button(role: .destructive) {
                  taskViewModel.destroy(task: task)
              } label: {
                  Label("Delete", systemImage: "trash")
                    .foregroundColor(.red)
              }
            
          }
    }
}



struct TaskBoardView_Previews: PreviewProvider {
    static var previews: some View {
        TaskBoardView()
            .environmentObject(AuthViewModel.mock())
            .environmentObject(TaskViewModel())
            .environmentObject(UserViewModel())
    }
}

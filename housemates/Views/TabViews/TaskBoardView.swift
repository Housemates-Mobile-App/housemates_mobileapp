import SwiftUI

struct TaskBoardView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedTab = 0
    @Binding var hideTabBar: Bool
    @State private var selected: String = "All Tasks"

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
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
    }

    // Add Task Button
    private func addTaskButton(user: User) -> some View {
        NavigationLink(destination: TaskSelectionView(user: user, hideTabBar: $hideTabBar, selectedTab: $selectedTab)) {
            Image(systemName: "plus")
                .font(.title)
                .foregroundColor(Color.white)
                .background(Color.purple)
                .clipShape(Circle())
                .padding(7.5)
                .fontWeight(.semibold)
        }
    }

    // Main Content Section
    private func mainContent(user: User) -> some View {
        VStack {
            TabView(selection: $selectedTab) {
                taskScrollView(user: user)
                    .tag(0)
                GraphView()
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))

            Spacer()
        }
    }

 

    // Task Scroll View
    private func taskScrollView(user: User) -> some View {
        ScrollView {
            VStack(alignment: .leading) {
              HStack {
                Spacer()
                FilterView(selected: $selected)
                Spacer()
              }
               
                   
                taskSections(user: user)
            }
        }
        .tag(0)
    }

   

    // Task Sections
    private func taskSections(user: User) -> some View {
        VStack(alignment: .leading) {
            if selected == "Unclaimed" || selected == "All Tasks" {
              taskSection(title: "Unclaimed", tasks: taskViewModel.getUnclaimedTasksForGroup(user.group_id!), user: user)
            }

            if selected == "Doing" || selected == "All Tasks" {
                taskSection(title: "In Progress", tasks: taskViewModel.getInProgressTasksForGroup(user.group_id!), user: user)
            }

            if selected == "Completed" || selected == "All Tasks" {
                taskSection(title: "Completed", tasks: taskViewModel.getCompletedTasksForGroup(user.group_id!), user: user)
            }
        }
        .padding(.horizontal)
    }

    // Individual Task Section
  private func taskSection(title: String, tasks: [task], user: User) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.top)
                .bold()

            if tasks.isEmpty {
                MessageCardView(message: "No \(title) Tasks")
            }

            ForEach(tasks) { task in
              TaskView(task: task, user: user)
            }
        }
    }

 
   
}

struct TaskBoardView_Previews: PreviewProvider {
    static var previews: some View {
        TaskBoardView(hideTabBar: Binding.constant(false))
            .environmentObject(AuthViewModel.mock())
            .environmentObject(TaskViewModel())
            .environmentObject(UserViewModel())
    }
}

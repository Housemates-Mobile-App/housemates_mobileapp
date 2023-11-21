import SwiftUI

struct TaskBoardView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selected: String = "All Tasks"
    @State private var showTaskSelectionView = false
    private var unknownDate = Date.distantPast


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
      let completedTasks = taskViewModel.getCompletedTasksForGroup(user.group_id!)
      return List {
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
                  ForEach (convertCompletedList(completedList: completedTasks), id: \.0) { date, tasks in
                      Text(convertDateToStr(date: date)).font(.custom("Lato-Regular", size: 13)).padding(.bottom, 0)
                      ForEach(tasks, id: \.id) { task in
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
    
    // just d,m,y info for keys
    private func getPartialDate(dateStr: String) -> Date? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM.dd.yy h:mm a"
        
        guard let dateFromStr = dateFormatter.date(from: dateStr) else {
            return nil
        }
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: dateFromStr)
        let month = calendar.component(.month, from: dateFromStr)
        let day = calendar.component(.day, from: dateFromStr)
        return calendar.date(from: DateComponents(year: year, month: month, day: day))
    }
    
    // d,m,y,h,s info
    private func getFullDate(dateStr: String) -> Date? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM.dd.yy h:mm a"
        return dateFormatter.date(from: dateStr)
    }
    
    private func convertCompletedList(completedList: [task]) -> [(Date, [task])] {
        var completedDict: [Date: [task]] = [:]

        for cTask in completedList {
            let dateStr = cTask.date_completed!
            let partialDate = getPartialDate(dateStr: dateStr) ?? unknownDate

            if completedDict[partialDate] != nil {
                completedDict[partialDate]!.append(cTask)
            } else {
                completedDict[partialDate] = [cTask]
            }
        }

        // Sort the dictionary by descending date
        let sortedTasks = completedDict.sorted { $0.key > $1.key }
            .map { (date: $0.key, tasks: $0.value.sorted { task1, task2 in
                getFullDate(dateStr: task1.date_completed!) ?? Date() > getFullDate(dateStr: task2.date_completed!) ?? Date()
            }) }
        
        // note: this doesnt sort tasks on a particular day, which i think is fine
        return sortedTasks
    }
    
    private func convertDateToStr(date: Date) -> String {
        if date == unknownDate {
            return "Unknown Day, Unknown Date"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMM d"
            return dateFormatter.string(from: date)
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

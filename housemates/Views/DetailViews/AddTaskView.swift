import SwiftUI

struct AddTaskView: View {
  let taskIconStringHardcoded: String
  let taskNameHardcoded: String
  let user: User
  @EnvironmentObject var taskViewModel: TaskViewModel
  @Binding var hideTabBar: Bool
  @Binding var selectedTab: Int
  
  @Environment(\.presentationMode) var presentationMode
  @State private var showAlert = false
  @State private var alertMessage = ""
  @State private var taskName: String = ""
  @State private var taskDescription: String = ""
  @State private var priority: TaskViewModel.TaskPriority = .medium
  @State private var recurrence: Recurrence = .none
  @State private var recurrenceStartDate: Date = Date()
  @State private var recurrenceEndDate: Date = Date()
  @State private var isRecurring: Bool = false

  let elements: [TaskViewModel.TaskPriority] = TaskViewModel.TaskPriority.allCases
  
  
  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        Text("Add Task")
          .font(.title)
          .fontWeight(.bold)
          
        
        if taskIconStringHardcoded.count > 0 {
          Image(taskIconStringHardcoded)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 100)
            .foregroundColor(.gray)
            .padding(5)
        } else {
          Image(systemName: "person.circle")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 100)
            .foregroundColor(.gray)
            .padding(5)
        }
        
        
        NewInputView(text: $taskName, title: "Task Name", placeholder: "Enter in task name!")
        
        // for task description
        NewInputView(text: $taskDescription, title: "Task Description", placeholder: "Write a description about the task!")
        
        
        
        SliderPicker(selectedElement: $priority)
        RecurrenceSection(isRecurring: $isRecurring,
            recurrence: $recurrence,
            recurrenceStartDate: $recurrenceStartDate,
            recurrenceEndDate: $recurrenceEndDate)
       
        Button(action: addTask) {
          Text("Add Task")
            .font(.system(size: 18))
            .bold()
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(Color(red: 0.439, green: 0.298, blue: 1.0))
            .foregroundColor(.white)
            .cornerRadius(30)
            .padding(.horizontal)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.bottom, 20)
      }
      
    }
    .alert(isPresented: $showAlert) {
      Alert(title: Text(alertMessage.isEmpty ? "Adding task..." : alertMessage))
    }
    .onAppear {
      taskName = taskNameHardcoded
      hideTabBar = true
    }
    .onDisappear {
      hideTabBar = false
      selectedTab = 0
    }
  }
  
  
  private func addTask() {
    guard !taskName.isEmpty && !taskDescription.isEmpty else {
      alertMessage = "Task name or description cannot be empty."
      showAlert = true
      return
    }
    
    
    print("Task Name: \(taskName)")
    print("Task Description: \(taskDescription)")
    print("Priority: \(priority.rawValue)")
    
    let newTask = housemates.task(
      name: taskName,
      group_id: user.group_id ?? "",
      user_id: nil,
      description: taskDescription,
      status: .unclaimed,
      date_started: nil,
      date_completed: nil,
      priority: priority.rawValue,
      recurrence: isRecurring ? recurrence : .none,
      recurrenceStartDate: isRecurring ? recurrenceStartDate : nil,
      recurrenceEndDate: isRecurring ? recurrenceEndDate : nil
    )
    
    if taskViewModel.tasks.contains(where: { $0.name == newTask.name }) {
      alertMessage = "Task already exists."
      showAlert = true
      return
    } else{
      taskViewModel.create(task: newTask)
    }
    
    
    alertMessage = "Task added successfully."
    showAlert = true
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      showAlert = false
      presentationMode.wrappedValue.dismiss()
    }
  }
  
  
  
  struct RecurrenceSection: View {
    @Binding var isRecurring: Bool
    @Binding var recurrence: Recurrence
    @Binding var recurrenceStartDate: Date
    @Binding var recurrenceEndDate: Date
    
    var body: some View {
        Toggle("Is Recurring", isOn: $isRecurring)
          .onChange(of: isRecurring) { value in
              if !value {
                  recurrence = .none // Reset recurrence when toggled off
              }
          }
                          
          if isRecurring {
              Picker("Repeats", selection: $recurrence) {
                  Text("Daily").tag(Recurrence.daily)
                  Text("Weekly").tag(Recurrence.weekly)
                  Text("Monthly").tag(Recurrence.monthly)
              }
              .pickerStyle(SegmentedPickerStyle())
              
              DatePicker(
                  "Start Date",
                  selection: $recurrenceStartDate,
                  displayedComponents: [.date]
              )
              
              DatePicker(
                  "End Date",
                  selection: $recurrenceEndDate,
                  in: recurrenceStartDate...,
                  displayedComponents: [.date]
              )
          }
    }
  }
  
  struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
      AddTaskView(taskIconStringHardcoded: "trash.fill", taskNameHardcoded: "Clean Dishes",
                  user: User(first_name: "Bob", last_name: "Portis", phone_number: "9519012", email: "danielfg@gmail.com", birthday: "02/02/2000"),
                  hideTabBar: .constant(true), selectedTab: .constant(0))
      .environmentObject(TaskViewModel())
    }
  }
}

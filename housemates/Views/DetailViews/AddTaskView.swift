import SwiftUI

struct AddTaskView: View {
  let taskIconStringHardcoded: String
  let taskNameHardcoded: String
  let user: User
  @EnvironmentObject var taskViewModel: TaskViewModel
  @Binding var showTaskSelectionView: Bool
  
  @Environment(\.presentationMode) var presentationMode
  @State private var showAlert = false
  @State private var alertMessage = ""
  @State private var taskName: String = ""
  @State private var taskDescription: String = ""
  @State private var priority: TaskViewModel.TaskPriority = .medium
  @State private var taskRepetition: TaskRepetition = .doesNotRepeat
  
  let elements: [TaskViewModel.TaskPriority] = TaskViewModel.TaskPriority.allCases
  
  enum TaskRepetition: String, CaseIterable {
    case doesNotRepeat = "Does Not Repeat"
    case everyDay = "Every Day"
    case everyMonday = "Every Monday"
    case custom = "Custom..."
  }
  
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
        
        
        NewInputView(text: $taskName, title: "Task Name", placeholder: "Add a task name!")
        
        // for task description
        NewInputView(text: $taskDescription, title: "Task Description", placeholder: "Write a description about the task!")
        
        
        
        SliderPicker(selectedElement: $priority)
        RecurrenceSection(taskRepetition: $taskRepetition)
        
       


        
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
    .onAppear {
      taskName = taskNameHardcoded
    }
    .alert(isPresented: $showAlert) {
      Alert(title: Text(alertMessage.isEmpty ? "Adding task..." : alertMessage))
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
      icon: taskIconStringHardcoded
//      icon: "dalle"
    )
    
//    if taskViewModel.tasks.contains(where: { $0.name == newTask.name }) {
//      alertMessage = "Task already exists."
//      showAlert = true
//      return
//    } else{
      taskViewModel.create(task: newTask)
//    }
    
    
    alertMessage = "Task added successfully."
    showAlert = true
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      showAlert = false
      presentationMode.wrappedValue.dismiss()
      showTaskSelectionView = false
    }
  }
  
  
  
  struct RecurrenceSection: View {
    @Binding var taskRepetition: AddTaskView.TaskRepetition
    
    var body: some View {
      VStack(alignment: .leading) {
        Text("Recurrence")
          .bold()
        Picker("Repeats", selection: $taskRepetition) {
          ForEach(AddTaskView.TaskRepetition.allCases, id: \.self) { repetition in
            Text(repetition.rawValue).tag(repetition)
          }
        }
        .pickerStyle(SegmentedPickerStyle())
      }
      .padding(.horizontal)
    }
  }
  
  struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
      AddTaskView(taskIconStringHardcoded: "trash.fill", taskNameHardcoded: "Clean Dishes",
                  user: User(first_name: "Bob", last_name: "Portis", phone_number: "9519012", email: "danielfg@gmail.com", birthday: "02/02/2000"), showTaskSelectionView: .constant(true))
      .environmentObject(TaskViewModel())
    }
  }
}

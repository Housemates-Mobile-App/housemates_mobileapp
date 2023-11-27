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
<<<<<<< HEAD
  @State private var priority: TaskViewModel.TaskPriority = .low
  @State private var taskRepetition: TaskRepetition = .doesNotRepeat
=======
  @State private var priority: TaskViewModel.TaskPriority = .medium
  @State private var recurrence: Recurrence = .none
  @State private var recurrenceStartDate: Date = Date()
  @State private var recurrenceEndDate: Date = Date()
  @State private var isRecurring: Bool = false
>>>>>>> recurring
  
  let elements: [TaskViewModel.TaskPriority] = TaskViewModel.TaskPriority.allCases
  
  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        Text("Add Task")
          
          .font(.custom("Nunito-Bold", size: 26))
          .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
          
          
        
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
        
<<<<<<< HEAD
        
        
        SliderPicker(selectedPriority: $priority)
        RecurrenceSection(taskRepetition: $taskRepetition)
        
       


        
=======
        SliderPicker(selectedElement: $priority)
      
        RecurrenceSection(isRecurring: $isRecurring,
          recurrence: $recurrence,
          recurrenceStartDate: $recurrenceStartDate,
          recurrenceEndDate: $recurrenceEndDate)
          
>>>>>>> recurring
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
      
    if isRecurring {
        //recurrence type is selected
        guard recurrence != .none else {
            alertMessage = "Please select a recurrence type for the task."
            showAlert = true
            return
        }
        
        guard recurrence == .none || (recurrenceStartDate != nil && recurrenceEndDate != nil) else {
          alertMessage = "Recurring tasks must have both a start and an end date."
          showAlert = true
          return
        }

        // start date not in the past
        guard recurrenceStartDate >= Calendar.current.date(byAdding: .day, value: -1, to: Date())! else {
            alertMessage = "Recurring start date cannot be in the past."
            showAlert = true
            return
        }

        // end date is not current day or the same as the start date
        guard recurrenceEndDate > Date() && recurrenceEndDate > recurrenceStartDate else {
            alertMessage = "Recurring end date must be after the start date and not today."
            showAlert = true
            return
        }
    }
    
//    print("Task Name: \(taskName)")
//    print("Task Description: \(taskDescription)")
//    print("Priority: \(priority.rawValue)")
    
    let newTask = housemates.task(
      name: taskName,
      group_id: user.group_id ?? "",
      user_id: nil,
      description: taskDescription,
      status: .unclaimed,
      date_started: nil,
      date_completed: nil,
      priority: priority.rawValue,
      icon: taskIconStringHardcoded,
      recurrence: isRecurring ? recurrence : .none,
      recurrenceStartDate: isRecurring ? recurrenceStartDate : nil,
      recurrenceEndDate: isRecurring ? recurrenceEndDate : nil)
    
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
    @Binding var isRecurring: Bool
    @Binding var recurrence: Recurrence
    @Binding var recurrenceStartDate: Date
    @Binding var recurrenceEndDate: Date
    
    var body: some View {
      VStack(spacing: 16) {
          Toggle("Is Recurring", isOn: $isRecurring)
              .toggleStyle(SwitchToggleStyle(tint: .blue))
              .padding(.horizontal)
          
          if isRecurring {
              VStack(spacing: 16) {
                  Picker("Repeats", selection: $recurrence) {
                      Text("Daily").tag(Recurrence.daily)
                      Text("Weekly").tag(Recurrence.weekly)
                      Text("Monthly").tag(Recurrence.monthly)
                  }
                  .pickerStyle(SegmentedPickerStyle())
                  .padding(.horizontal)
                  
                  DatePicker(
                      "Start Date",
                      selection: $recurrenceStartDate,
                      displayedComponents: [.date]
                  )
                  .datePickerStyle(CompactDatePickerStyle())
                  .padding(.horizontal)
                  
                  DatePicker(
                      "End Date",
                      selection: $recurrenceEndDate,
                      in: recurrenceStartDate...,
                      displayedComponents: [.date]
                  )
                  .datePickerStyle(CompactDatePickerStyle())
                  .padding(.horizontal)
              }
              .transition(.opacity.combined(with: .slide))
          }
      }
      .padding(.top, 8)
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

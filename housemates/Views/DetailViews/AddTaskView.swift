//
//  AddTaskView.swift
//  housemates
//
//  Created by Sanmoy Karmakar on 11/8/23.
//

import SwiftUI

struct AddTaskView: View {
    let user: User
    var taskViewModel : TaskViewModel
    @Binding var hideTabBar: Bool
//  added this to bring the user back to the first page after adding a task
    @Binding var selectedTab: Int

    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var taskName: String = ""
    @State private var taskDescription: String = ""
    @State private var priority: TaskPriority = .medium
    @State private var taskRepetition: TaskRepetition = .doesNotRepeat

    enum TaskPriority: String, CaseIterable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
    }
    
    enum TaskRepetition: String, CaseIterable {
            case doesNotRepeat = "Does Not Repeat"
            case everyDay = "Every Day"
            case everyMonday = "Every Monday"
            case custom = "Custom..."
        }
    
    var body: some View {
        NavigationView {
            Form {
                InputView(text: $taskName, title: "Task Name", placeholder: "Enter task name")
                InputView(text: $taskDescription, title: "Description", placeholder: "Enter task description")
                
                //Picker for priority
                Section(header: Text("Priority")) {
                    Picker("Priority", selection: $priority) {
                        ForEach(TaskPriority.allCases, id: \.self) { priority in
                            Text(priority.rawValue).tag(priority)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                
                //Picker for recurringness
                Section(header: Text("Repeats")) {
                                    Picker("Repeats", selection: $taskRepetition) {
                                        ForEach(TaskRepetition.allCases, id: \.self) { repetition in
                                            Text(repetition.rawValue).tag(repetition)
                                        }
                                    }
                                    .pickerStyle(DefaultPickerStyle())
                                }
                
                Button(action: {
                    addTask()
                }) {
                    Text("Add Task")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationBarTitle(Text("Add Task"), displayMode: .inline)
            
        }
        .onDisappear {
          self.selectedTab = 0 // Reset the tab when going back
        }
        .alert(isPresented: $showAlert) {
            if alertMessage.isEmpty {
                return Alert(title: Text("Adding task..."))
            } else {
                return Alert(title: Text(alertMessage))
            }
        }
        .onAppear {
            hideTabBar = true
        }
        .onDisappear {
            hideTabBar = false
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
            priority: priority.rawValue
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
            // Delay the dismissal for 2 seconds (you can adjust the duration)
            showAlert = false
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    
}


//#Preview {
//    AddTaskView()
//}

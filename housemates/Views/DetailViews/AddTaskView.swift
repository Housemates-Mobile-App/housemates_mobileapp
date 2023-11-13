//
//  AddTaskView.swift
//  housemates
//
//  Created by Sanmoy Karmakar on 11/8/23.
//

import SwiftUI

struct AddTaskView: View {
    let taskIconStringHardcoded: String
    let taskNameHardcoded: String
    let user: User
    @EnvironmentObject var taskViewModel : TaskViewModel
    @Binding var hideTabBar: Bool
//  added this to bring the user back to the first page after adding a task
    @Binding var selectedTab: Int

    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var taskName: String = ""
    @State private var taskDescription: String = ""
    @State private var priority: TaskViewModel.TaskPriority = .medium
    @State private var taskRepetition: TaskRepetition = .doesNotRepeat

    enum TaskRepetition: String, CaseIterable {
            case doesNotRepeat = "Does Not Repeat"
            case everyDay = "Every Day"
            case everyMonday = "Every Monday"
            case custom = "Custom..."
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Top part with a different background color
            Color(red: 0.439, green: 0.298, blue: 1.0)
                .frame(width: 400, height: 120)
                .overlay(
                    Text("New Task")
                        .font(.system(size: 18))
                        .bold()
                        .foregroundColor(.white)
                        .padding(.top, 70)
                        .padding(.trailing, 250)
                )
            //icon image
            if taskIconStringHardcoded.count > 0 {
                Image(taskIconStringHardcoded)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(radius: 5)
                    .foregroundColor(.gray)
                    .padding(5)
            } else {
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(radius: 5)
                    .foregroundColor(.gray)
                    .padding(5)
            }
            
            
            // for task name
            NewInputView(text: $taskName, title: "Task Name", placeholder: "Enter in task name!")
            
            // for task description
            NewInputView(text: $taskDescription, title: "Task Description", placeholder: "Write a description about the task!")
            
            Text("Priority")
                .font(.system(size: 20))
                .foregroundColor(.black)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)

            //Picker for priority
            SliderPicker(selectedElement: $priority)
            
            //Picker for recurringness
            Text("Repeats")
                .font(.system(size: 20))
                .foregroundColor(.black)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            Picker("Repeats", selection: $taskRepetition) {
                ForEach(TaskRepetition.allCases, id: \.self) { repetition in
                    Text(repetition.rawValue).tag(repetition)
                }
            }
            .pickerStyle(DefaultPickerStyle())
            
            Spacer()
            
            Button(action: {
                addTask()
            }) {
                VStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(red: 0.439, green: 0.298, blue: 1.0))
                        .frame(width: 222, height: 51)
                        .overlay(
                            Text("Add Task")
                                .font(.system(size: 18))
                                .bold()
                                .foregroundColor(.white)
                        )
                }.offset(y: -30)
            }
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [
                Color(red: 0.925, green: 0.863, blue: 1.0).opacity(0.25),
                Color(red: 0.619, green: 0.325, blue: 1.0).opacity(0.25)
            ]), startPoint: .top, endPoint: .bottom)
            ).ignoresSafeArea(.all)
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
            //setting taskName to be the input
            taskName = taskNameHardcoded
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


struct AddTaskView_Previews: PreviewProvider {
    var user = User(first_name: "Bob", last_name: "Portis", phone_number: "9519012", email: "danielfg@gmail.com", birthday: "02/02/2000")
    
    static var previews: some View {
        AddTaskView(taskIconStringHardcoded: "dalle1", taskNameHardcoded: "Clean Dishes", user: UserViewModel.mockUser(), hideTabBar: Binding.constant(false), selectedTab: Binding.constant(2)).environmentObject(TaskViewModel())
    }
    
}

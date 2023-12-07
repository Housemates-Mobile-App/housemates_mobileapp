import SwiftUI
import UIKit
import FirebaseStorage

struct AddTaskView: View {
  let taskIconStringHardcoded: String
  let taskNameHardcoded: String
  let user: User
  @EnvironmentObject var taskViewModel: TaskViewModel
  @EnvironmentObject var tabBarViewModel: TabBarViewModel
    
  @Environment(\.presentationMode) var presentationMode
  @State private var showAlert = false
  @State private var alertMessage = ""
  @State private var taskName: String = ""
  @State private var taskDescription: String = ""
  @State private var priority: TaskPriority = .low
  @State private var recurrence: Recurrence = .none
  @State private var recurrenceStartDate: Date = Date()
  @State private var recurrenceEndDate: Date = Date()
  @State private var showCamera = false
  @State private var image: UIImage?
    
  var editableTask: task?
  
  let elements: [TaskPriority] = TaskPriority.allCases
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 10) {
          Text((editableTask != nil) ? "Edit Task" : "Add Task")
          
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
        
          HStack {
              Text("Priority")
                  .font(.custom("Lato-Bold", size: 18))
                  .padding(.horizontal)
              Spacer()
          }
        SliderPicker(selectedItem: $priority)
        
          HStack {
              Text("Repeats?")
                  .font(.custom("Lato-Bold", size: 18))
                  .padding(.horizontal)
              Spacer()
          }
        SliderPicker(selectedItem: $recurrence)
      
        RecurrenceSection(
          recurrence: $recurrence,
          recurrenceStartDate: $recurrenceStartDate,
          recurrenceEndDate: $recurrenceEndDate)
          
          
          if recurrence == .none {
              HStack {
                  ZStack {
                      if let capturedImage = image {
                          // Show the captured image
                          Image(uiImage: capturedImage)
                              .resizable()
                              .scaledToFit()
                              .frame(width: 100, height: 100)
                      } else {
                          // Show a gray box
                          Rectangle()
                              .fill(Color.gray)
                              .frame(width: 100, height: 100)

                          // Camera icon
                          Image(systemName: "camera.fill")
                              .font(.largeTitle)
                              .foregroundColor(.white)
                              .onTapGesture {
                                  showCamera = true
                              }
                      }
                  }
                  .fullScreenCover(isPresented: $showCamera) {
                      BeforeCameraView(image: $image, isPresented: $showCamera)
                  }

                  // Text changes based on whether an image has been captured
                  Text(image == nil ? "Take a Before photo!" : "Before photo taken")
                      .font(.custom("Nunito-Bold", size: 17))
                      .foregroundColor(Color.gray)
              }
              .padding(.leading)
          }
          
          Spacer()
        
          
          Button(action: {
              Task {
                  await addTask()
              }
          }) {
            Text((editableTask != nil) ? "Edit Task" : "Add Task")
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
            
      if let task = editableTask {
          self.taskName = task.name
          self.taskDescription = task.description
          self.priority = TaskPriority(rawValue: task.priority) ?? .low
          self.recurrence = task.recurrence
          self.recurrenceStartDate = task.recurrenceStartDate ?? Date()
          self.recurrenceEndDate = task.recurrenceEndDate ?? Date()
    }
            
    }
    .alert(isPresented: $showAlert) {
        if (editableTask != nil) {
            return Alert(title: Text(alertMessage.isEmpty ? "Editing task..." : alertMessage))
        } else {
            return Alert(title: Text(alertMessage.isEmpty ? "Adding task..." : alertMessage))
        }
    }
    .padding(.horizontal)
  }
  
  
    private func addTask() async {
    guard !taskName.isEmpty else {
      alertMessage = "Task name cannot be empty."
      showAlert = true
      return
    }
      
      if recurrence != .none {
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

    let formatter = DateFormatter()
    formatter.dateFormat = "MM.dd.yy h:mm a"
    let formattedDate = formatter.string(from: Date())
    
    var imageURL: String?
        
    if let image = image {
        imageURL = await getPostPicURL(image: image)
        guard imageURL != nil else {
            print("Failed to upload image or get URL")
            return
        }
    }
        
    let newTask = housemates.task(
      name: taskName,
      group_id: user.group_id ?? "",
      user_id: nil,
      description: taskDescription,
      status: .unclaimed,
      date_created: formattedDate,
      date_started: nil,
      date_completed: nil,
      priority: priority.rawValue,
      icon: taskIconStringHardcoded,
      recurrence: recurrence,
      recurrenceStartDate: (recurrence != .none) ? recurrenceStartDate : nil,
      recurrenceEndDate: (recurrence != .none) ? recurrenceEndDate : nil,
      beforeImageURL: imageURL
      )
    

      if let editableTask = editableTask {
          taskViewModel.editTask(task: editableTask, name: taskName, description: taskDescription, priority: priority.rawValue, icon: taskIconStringHardcoded, recurrence: recurrence, recurrenceStartDate: recurrenceStartDate, recurrenceEndDate: recurrenceEndDate)
          alertMessage = "Task edited successfully."
      } else {
        taskViewModel.create(task: newTask)
          alertMessage = "Task added successfully."
      }
    
      showAlert = true
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      showAlert = false
      presentationMode.wrappedValue.dismiss()
      tabBarViewModel.showTaskSelectionView = false
    }
  }
  
  
  
  struct RecurrenceSection: View {
    @Binding var recurrence: Recurrence
    @Binding var recurrenceStartDate: Date
    @Binding var recurrenceEndDate: Date
    
    var body: some View {
      VStack(spacing: 16) {
          
          if (recurrence != .none) {
              VStack(spacing: 16) {
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
                  user: User(first_name: "Bob", last_name: "Portis", phone_number: "9519012", email: "danielfg@gmail.com", birthday: "02/02/2000"))
      .environmentObject(TaskViewModel())
      .environmentObject(TabBarViewModel.mock())
    }
  }
    
    func getPostPicURL(image: UIImage) async -> String? {
        let photoID = UUID().uuidString
        let storageRef = Storage.storage().reference().child("\(photoID).jpeg")
        
        guard let resizedImage = image.jpegData(compressionQuality: 0.2) else {
            print("ERROR: Could not resize image")
            return nil
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        do {
            let _ = try await storageRef.putDataAsync(resizedImage, metadata: metadata)
            let imageURL = try await storageRef.downloadURL()
            return imageURL.absoluteString
        } catch {
            print("ERROR: \(error.localizedDescription)")
            return nil
        }
    }
}

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
  @State private var dueDate: Date = Date()
  @State private var recurrence: Recurrence = .none
  @State private var recurrenceStartDate: Date = Date()
  @State private var recurrenceEndDate: Date = Date()
  @State private var showingSheet = false
  @State private var taskIconStringNew: String
  @State private var showCamera = false
  @State private var image: UIImage?
    
  var editableTask: task?

  let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)
  let elements: [TaskPriority] = TaskPriority.allCases
    
    init(taskIconStringHardcoded: String, taskNameHardcoded: String, user: User, editableTask: task? = nil) {
        let iconString = taskIconStringHardcoded.isEmpty ? "defaultTask" : taskIconStringHardcoded
        _taskIconStringNew = State(initialValue: iconString)
        self.taskIconStringHardcoded = taskIconStringHardcoded
        self.taskNameHardcoded = taskNameHardcoded
        self.user = user
        self.editableTask = editableTask
      }
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 10) {
        SwiftUI.Group {
          
          
      
          HStack {
            Spacer()
            ZStack {
              if taskIconStringNew.count > 0 {
                Image(taskIconStringNew)
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
              
              Button(action: {
                showingSheet.toggle()
              }) {
                Image(systemName: "pencil.circle.fill")
                  .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
                  .background(Circle().fill(Color.white))
                  .font(.system(size: 24))
              }
              .offset(x: 35, y: 35)
              .sheet(isPresented: $showingSheet) {
                SheetView(taskIconStr: $taskIconStringNew)
              }
            }
            Spacer()
          }
        }
        
        
        NewInputView(text: $taskName, title: "Task Name", placeholder: "Add a task name!")
        
        // for task description
        NewInputView(text: $taskDescription, title: "Description", placeholder: "Write a description about the task!")
//        HStack {
//            Text("Due Date?")
//                .font(.custom("Lato-Bold", size: 18))
//                .padding(.horizontal)
//            Spacer()
//        }
        
//        SliderPicker(selectedItem: $due)
        
        
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
              
              Text("Due Date")
                .font(.custom("Lato-Bold", size: 18))
                .padding(.horizontal)
              DatePicker(
                "",
                selection: $dueDate,
                in: Date()...,
                displayedComponents: [.date]
              )
              .datePickerStyle(CompactDatePickerStyle())
              .padding(.horizontal)
            }
            HStack {
              
              Spacer()
              VStack {
                
                
                
                
                // Text changes based on whether an image has been captured
                
                
                
                
                ZStack {
                  if let capturedImage = image {
                    // Show the captured image
                    Image(uiImage: capturedImage)
                      .resizable()
                      .scaledToFit()
                      .frame(height: 125)
                      .cornerRadius(10)
                      .overlay(Color.black.opacity(0.35).clipShape(RoundedRectangle(cornerRadius: 10)))
//                      .clipShape(RoundedRectangle(cornerRadius: 10))

                      
                  } else {
                    // Show a gray box
//                    Circle()
//                      .fill(Color.gray.opacity(0.25))
//                      .frame(width: 100, height: 100)
                    
                    // Camera icon
                    Image("camera")
                      .resizable()
                      .aspectRatio(contentMode: .fill)
                      .frame(width: 65, height: 65)
                      
                      
        //              .overlay(Circle().stroke(Color.purple, lineWidth: 2))
                      .padding(7.5)
                   
                      .background(deepPurple.opacity(0.25))
                      .clipShape(Circle())
                      
                      .foregroundColor(.white)
                      .onTapGesture {
                        showCamera = true
                      }
                  }
                }.padding([.horizontal, .top])
                .fullScreenCover(isPresented: $showCamera) {
                  BeforeCameraView(image: $image, isPresented: $showCamera)
                }
                HStack {
                  Spacer()
                  Text(image == nil ? "Take a Before Photo!" : "Before Photo Taken")
                    .font(.custom("Lato-Bold", size: 18))
                    .padding(.bottom)
                    
                  Spacer()
                }.padding(.bottom)
              }
              Spacer()
            }
             
          }
          
          
        
          
          Button(action: {
              Task {
                  await addTask()
              }
              if (editableTask != nil) {
                  tabBarViewModel.showEditTaskBanner = true
              } else {
                  tabBarViewModel.showAddTaskBanner = true
              }
              tabBarViewModel.selectedTab = 1
              tabBarViewModel.hideTabBar = false
          }) {
            Text((editableTask != nil) ? "Edit Task" : "Add Task")
              .font(.custom("Nunito-Bold", size: 18))
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
       
    }.navigationTitle((editableTask != nil) ? "Edit Task" : "Add Task")
     
    .onAppear {
      taskName = taskNameHardcoded
            
      if let task = editableTask {
          self.taskName = task.name
          self.taskDescription = task.description
          self.dueDate = task.date_due ?? Date()
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
      date_due: (recurrence != .none) ? nil : dueDate,
      icon: taskIconStringNew,
      recurrence: recurrence,
      recurrenceStartDate: (recurrence != .none) ? recurrenceStartDate : nil,
      recurrenceEndDate: (recurrence != .none) ? recurrenceEndDate : nil,
      beforeImageURL: imageURL
      )
    

      if let editableTask = editableTask {
        taskViewModel.editTask(task: editableTask, name: taskName, description: taskDescription, date_due: dueDate, icon: taskIconStringNew, recurrence: recurrence, recurrenceStartDate: recurrenceStartDate, recurrenceEndDate: recurrenceEndDate)
          alertMessage = "Task edited successfully."
      } else {
        taskViewModel.create(task: newTask)
          alertMessage = "Task added successfully."
      }
    
//      showAlert = true
    
//    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//      showAlert = false
      presentationMode.wrappedValue.dismiss()
      tabBarViewModel.showTaskSelectionView = false
//    }
  }
  
  
  
  struct RecurrenceSection: View {
    @Binding var recurrence: Recurrence
    @Binding var recurrenceStartDate: Date
    @Binding var recurrenceEndDate: Date
    
    var body: some View {
      VStack(spacing: 16) {
          
          if (recurrence != .none) {
              VStack(spacing: 16) {
                HStack {
                  Text("Start Date")
                    .font(.custom("Lato", size: 18))
                    .padding(.horizontal)
                  DatePicker(
                    "",
                    selection: $recurrenceStartDate,
                    displayedComponents: [.date]
                  )
                  .datePickerStyle(CompactDatePickerStyle())
                  .padding(.horizontal)
                }
                HStack {
                  
                  Text("End Date")
                    .padding()
                    .font(.custom("Lato", size: 18))
                  DatePicker(
                    "",
                    selection: $recurrenceEndDate,
                    in: recurrenceStartDate...,
                    displayedComponents: [.date]
                  )
                  .datePickerStyle(CompactDatePickerStyle())
                  .padding(.horizontal)
                }
              }
              .transition(.opacity.combined(with: .slide))
          }
      }
      .padding(.top, 8)
      }
      
  }
  
  struct DueDateSection: View {
    @Binding var due: Bool
    @Binding var dueDate: Date
    
    var body: some View {
      VStack(spacing: 16) {
          
          if (due) {
              VStack(spacing: 16) {
                  DatePicker(
                      "Start Date",
                      selection: $dueDate,
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
  
    struct SheetView: View {
        @Binding var taskIconStr: String
        @Environment(\.dismiss) var dismiss
        var allTaskData = hardcodedFullTaskData
        let maxIconsPerRow = 5
        
        // Grouping tasks by category
        private var groupedTaskData: [String: [TaskData]] {
            Dictionary(grouping: allTaskData, by: { $0.taskCategory! })
        }

        var body: some View {
            VStack {
                VStack {
                    ZStack {
                        Text("Select Icon")
                            .font(.custom("Lato-Bold", size: 24))
                            .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
                            .padding(.top, 15)
                        HStack {
                            Spacer()
                            Button("Done"){
                                dismiss()
                            }
                            .font(.custom("Lato-Bold", size: 18))
                            .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
                            .padding(.top, 15)
                            .padding(.trailing, 10)
                            
                        }
                    }
                    
                    if taskIconStr.count > 0 {
                        Image(taskIconStr)
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
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        //multiple rows of all the possible options, where selected one is highlighted and appears in prev vstack
                        ForEach(groupedTaskData.keys.sorted(), id: \.self) { category in
                            VStack(alignment: .leading) {
                                Text(category)
                                    .font(.custom("Lato-Bold", size: 15))
                                VStack (spacing: 15) {
                                    ForEach(0..<((groupedTaskData[category]?.count ?? 0) + maxIconsPerRow - 1) / maxIconsPerRow, id: \.self) { rowIndex in
                                        HStack (spacing: 15) {
                                            ForEach(0..<maxIconsPerRow, id: \.self) { columnIndex in
                                                let index = rowIndex * maxIconsPerRow + columnIndex
                                                if index < (groupedTaskData[category]?.count ?? 0) {
                                                    let taskData = groupedTaskData[category]![index]
                                                    Image(taskData.taskIcon)
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: (UIScreen.main.bounds.width - 90) / 5)
                                                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(taskIconStr == taskData.taskIcon ? Color(red: 0.439, green: 0.298, blue: 1.0) : .gray, lineWidth: taskIconStr == taskData.taskIcon ? 4 : 1))
                                                        .onTapGesture {
                                                            taskIconStr = taskData.taskIcon
                                                        }
                                                } else {
                                                    Rectangle()
                                                        .foregroundColor(Color.clear)
                                                        .frame(width: (UIScreen.main.bounds.width - 90) / 5)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width - 25)
                            .padding(.bottom)
                        }
                    }
                }
            }.padding(10)
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

struct AddTaskView_Previews: PreviewProvider {
  static var previews: some View {
    AddTaskView(taskIconStringHardcoded: "trash", taskNameHardcoded: "Clean Dishes",
                user: User(user_id: "asdf", username: "bobby123", first_name: "Bob", last_name: "Portis", phone_number: "9519012", email: "danielfg@gmail.com", birthday: "02/02/2000"))
    .environmentObject(TaskViewModel())
    .environmentObject(TabBarViewModel.mock())
  }
}

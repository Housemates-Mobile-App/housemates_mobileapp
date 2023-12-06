//
//  ProfileView.swift
//  housemates
//
//  Created by Sean Pham on 11/2/23.
//

import SwiftUI
import PhotosUI
import CachedAsyncImage

enum ActiveAlert: Identifiable {
    case leaveGroup, signOut

    var id: Int {
        switch self {
        case .leaveGroup:
            return 1
        case .signOut:
            return 2
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @ObservedObject var groupRepository = GroupRepository()
    @State private var allowLocation: Bool = true
    @State private var group: Group?
    @State private var group_code: String?
    @State private var group_name: String?
    @State private var selectedPhoto:  PhotosPickerItem?
    @State private var uiImageSelected = UIImage()
    @State private var activeAlert: ActiveAlert?
    let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)
  

    var body: some View {
        if let user = authViewModel.currentUser {
          NavigationView {
              ZStack {
                  //wave
                  VStack {
                      NewWave()
                          .fill(deepPurple)
                          .frame(height: 170)
                      Spacer()
                  }.edgesIgnoringSafeArea(.top)
                    
                  VStack(spacing:0) {
                      HStack {
                      }.toolbar(content: {
                          Menu {
                              if let group_code = group_code {
                                  Text("Group Code: \(group_code)")
                              } else {
                                  Text("Group Code: N/A")
                              }
                              Button {
                                  activeAlert = .leaveGroup
                              } label: {
                                  Label("Leave Group", systemImage: "door")
                              }
                              Button(role: .destructive) {
                                  activeAlert = .signOut
                              } label: {
                                  Label("Sign Out", systemImage: "door")
                              }
                          } label: {
//                              Label("settings", systemImage: "gearshape.fill")
//                                  .font(.system(size: 18))
//                                  .padding()
                              Image(systemName: "gearshape.fill")
                                  .foregroundColor(.white)
                                  .font(.system(size: 18))
                                  .padding()
                          }
                      })

                      ZStack (alignment: .bottomTrailing) {
                          
                          let imageURL = URL(string: user.imageURLString ?? "")
                          
                          CachedAsyncImage(url: imageURL) { image in
                              image
                                  .resizable()
                                  .aspectRatio(contentMode: .fill)
                                  .frame(width: 100, height: 100)
                                  .clipShape(Circle())
                                  .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                  .foregroundColor(.gray)
                                  .padding(.top, 25)
                              
                              
                          } placeholder: {
                              // MARK: Default user profile picture
                              Circle()
                                  .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color(red: 0.6, green: 0.6, blue: 0.6), Color(red: 0.8, green: 0.8, blue: 0.8)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                  )
                                  .frame(width: 100, height: 100)
                                  .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                  .overlay(
                                    Text("\(user.first_name.prefix(1).capitalized+user.last_name.prefix(1).capitalized)")
                                    
                                        .font(.custom("Nunito-Bold", size: 40))
                                        .foregroundColor(.white)
                                  )
                                  .padding(.top, 25)
                              
                          }
                          
                          // MARK: Photo picker for changing profile picture
                          PhotosPicker(selection: $selectedPhoto,
                                       matching: .images) {
                              Image(systemName: "pencil.circle.fill")
                                  .symbolRenderingMode(.multicolor)
                                  .font(.system(size: 24))
                                  .foregroundColor(.accentColor)
                          }.onChange(of: selectedPhoto) { newValue in
                              Task {
                                  do {
                                      if let data = try await newValue?.loadTransferable(type: Data.self) {
                                          if let uiImage = UIImage(data: data) {
                                              uiImageSelected = uiImage
                                              _ = await authViewModel.saveProfilePicture(image: uiImageSelected)
                                          }
                                      }
                                  } catch {
                                      print("ERROR: Selecting image failed \(error.localizedDescription)")
                                  }
                              }
                              
                          }
                      }
                      
                      Text("\(user.first_name) \(user.last_name)")
                      //                  .font(.title)
                          .font(.custom("Nunito-Bold", size: 32))
                      
                      if let group_name = group_name {
                          Text(group_name)
                              .font(.custom("Lato", size: 24))
                              .padding(.bottom, 15)
                      } else {
                          Text("Group Name: N/A")
                              .font(.custom("Lato", size: 24))
                              .padding(.bottom, 15)
                      }
                      
                      //              Text("\(group?.name ?? "None")")
                      //                .font(.headline)
                      //                .font(.custom("Lato", size: 24))
                      
                      
                      
                      VStack(spacing: 10) {

                          HStack(spacing: 20) {
                              VStack {
                                  Text("\(taskViewModel.getNumCompletedTasksForUser(user.id!))")
                                      .font(.system(size: 32))
                                      .foregroundColor(deepPurple)
                                      .bold()
                                  Text("Completed")
                                      .font(.custom("Lato", size: 15))
                                      
                              }
                              .padding(30)
                              .padding(.leading, 30)
                              .frame(maxWidth: .infinity, minHeight: 25)
                              
                              VStack {
                                  Text("\(taskViewModel.getNumPendingTasksForUser(user.id!))")
                                      .foregroundColor(deepPurple)
                                      .font(.system(size: 32))
                                      .bold()
                                  Text("Pending")
                                      .font(.custom("Lato", size: 15))
                                      
                              }
                              .padding(30)
                              .padding(.trailing, 30)
                              .frame(maxWidth: .infinity, minHeight: 25)
                              
                              
                          }
                          .frame(maxWidth: .infinity)
                          .background(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                          )
                          
                      }.padding(.horizontal, 20)
                      
                      
                      Spacer()
                      
                      
                      
                  }.onAppear {
                      group = groupRepository.filterGroupsByID(user.group_id!)
                      group_name = group?.name
                      group_code = group?.code
                  }
                  .alert(item: $activeAlert) { alertType in
                      switch alertType {
                      case .leaveGroup:
                          return Alert(
                            title: Text("Confirm"),
                            message: Text("Are you sure you want to leave the group?"),
                            primaryButton: .destructive(Text("Leave")) {
                                // Leave group logic
                                print("Leaving group...")
                                
                                DispatchQueue.main.async {
                                    userViewModel.leaveGroup(currUser: user)
                                    authViewModel.currentUser!.group_id = nil
                                    taskViewModel.unclaimTasksForUserLeavingGroup(uid: user.id!)
                                }
                                
                                
                            },
                            secondaryButton: .cancel()
                          )
                      case .signOut:
                          return Alert(
                            title: Text("Confirm"),
                            message: Text("Are you sure you want to sign out?"),
                            primaryButton: .destructive(Text("Sign Out")) {
                                // Sign out logic
                                print("Signing Out...")
                                authViewModel.signOut()
                            },
                            secondaryButton: .cancel()
                          )
                      }
                  }
              }
            }
            }
    }
    }


struct SettingsView: View {
    var user: User
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var groupRepository: GroupRepository

    @State private var group: Group?
    @State private var group_code: String?

    var body: some View {
        List {
            Section("Account") {
                HStack {
                    if let group_code = group_code {
                        Text("Group Code: \(group_code)")
                    } else {
                        Text("Group Code: N/A")
                    }
                }
                Button("Leave Group") {
                    print("Leaving group...")
                }
                Button("Sign Out") {
                    authViewModel.signOut()
                }
            }
        }
        .onAppear {
            loadGroupData()
        }
    }

    private func loadGroupData() {
        group = groupRepository.filterGroupsByID(user.group_id!)
        group_code = group?.code
        
    }
}


struct LeaveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
//          .bold()
//          .font(.system(size: 18))
          .font(.custom("Lato-Bold", size: 18))
          .foregroundColor(.white)
          .padding(.horizontal)
          .frame(maxWidth: .infinity, minHeight: 50)
          .background(Color(red: 0.439, green: 0.298, blue: 1.0))
          .cornerRadius(16)
    }
}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
      NavigationStack {
          ProfileView()
              .environmentObject(AuthViewModel.mock())
              .environmentObject(TaskViewModel())
              .environmentObject(UserViewModel())
      }
  }
}



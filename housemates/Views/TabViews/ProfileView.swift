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
    @EnvironmentObject var groupViewModel: GroupViewModel
    @State private var group: Group?
    @State private var group_code: String?
    @State private var group_name: String?
    @State private var selectedPhoto:  PhotosPickerItem?
    @State private var uiImageSelected = UIImage()
    @State private var activeAlert: ActiveAlert?
    let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)
    
    var body: some View {
        let imageSize = UIScreen.main.bounds.width * 0.25
        let componentOffset = UIScreen.main.bounds.height * 0.063
        if let user = authViewModel.currentUser {
            ZStack {
                
                // MARK: Wave Background
                VStack {
                    ZStack {
                        NewWave()
                            .fill(deepPurple)
                            .frame(height: UIScreen.main.bounds.height * 0.20)
                        
                        HStack {
                            Spacer()
                            Menu {
                                if let group_code = group_code {
                                    Text("Group Code: \(group_code)")
                                } else {
                                    Text("Group Code: N/A")
                                }
                                Button {
                                    activeAlert = .leaveGroup
                                } label: {
                                    Text("Leave Group")
                                }
                                Button(role: .destructive) {
                                    activeAlert = .signOut
                                } label: {
                                    Text("Sign Out")
                                }
                            } label: {
                                Image(systemName: "gearshape.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 23))
                                    .padding()
                            }

                        }
                      
                        
                        let imageURL = URL(string: user.imageURLString ?? "")
                        
                        CachedAsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: imageSize, height: imageSize)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .offset(y: UIScreen.main.bounds.height * 0.10)
                        } placeholder: {
                            // Default user profile picture
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color(red: 0.6, green: 0.6, blue: 0.6), Color(red: 0.8, green: 0.8, blue: 0.8)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: imageSize, height: imageSize)
                                .overlay(
                                    Text("\(user.first_name.prefix(1).capitalized + user.last_name.prefix(1).capitalized)")
                                    
                                        .font(.custom("Nunito-Bold", size: 40))
                                        .foregroundColor(.white)
                                )
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .offset(y: UIScreen.main.bounds.height * 0.10)
                        }
                    }
                    
                    // MARK: Photo picker for changing profile picture
                    PhotosPicker(selection: $selectedPhoto,
                                 matching: .images) {
                        Image(systemName: "pencil.circle.fill")
                            .symbolRenderingMode(.multicolor)
                            .font(.system(size: 24))
                            .foregroundColor(.accentColor)
                            .offset(x: UIScreen.main.bounds.width * 0.10, y: UIScreen.main.bounds.height * 0.020)
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
                    
                    // MARK: Housemate name
                    Text("\(user.first_name) \(user.last_name)")
                        .font(.custom("Nunito-Bold", size: 26))
                        .bold()
                        
                        .offset(y: componentOffset * 0.4)
                    
                    if let group_name = group_name {
                        Text(group_name)
                            .font(.custom("Lato", size: 21))
                            .offset(y: componentOffset * 0.4)
                    } else {
                        Text("Group Name: N/A")
                            .font(.custom("Lato", size: 21))
                            .offset(y: componentOffset * 0.4)
                    }
                    
                    // MARK: Task Card
                    HStack(spacing: 45) {
                        VStack {
                            Text("\(taskViewModel.getNumCompletedTasksForUser(user.user_id))")
                                .font(.system(size: 32))
                                .foregroundColor(deepPurple)
                                .bold()
                            Text("Completed")
                                .font(.custom("Lato", size: 15))
                                .frame(minWidth: 55)
                        }
                        .padding(.leading, 50)
                        .padding(.vertical, 25)
                        VStack {
                            Text("\(taskViewModel.getNumPendingTasksForUser(user.user_id))")
                                .foregroundColor(deepPurple)
                                .font(.system(size: 32))
                                .bold()
                            Text("Pending")
                                .font(.custom("Lato", size: 15))
                                .frame(minWidth: 55)
                        }
                        .padding(.trailing, 50)
                        .padding(.vertical, 25)
                    }.background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                    ).offset(y: componentOffset * 0.4)
                    
                    
                    Spacer()
                }.edgesIgnoringSafeArea(.top)
                
            }.onAppear {
                group = groupViewModel.getGroupByID(user.group_id!)
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

struct LeaveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
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
              .environmentObject(GroupViewModel())
      }
  }
}



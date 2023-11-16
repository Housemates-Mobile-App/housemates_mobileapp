//
//  ProfileView.swift
//  housemates
//
//  Created by Sean Pham on 11/2/23.
//

import SwiftUI
import PhotosUI


struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var groupRepository = GroupRepository()
    @State private var allowLocation: Bool = true
    @State private var group: Group?
    @State private var group_code: String?
    @State private var selectedPhoto:  PhotosPickerItem?
    @State private var uiImageSelected = UIImage()
    let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)
  
    

    var body: some View {
        if let user = authViewModel.currentUser {
            VStack {
                
                Spacer()
                ZStack (alignment: .bottomTrailing) {
                    let imageURL = URL(string: user.imageURLString ?? "")
                    
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .foregroundColor(.gray)
                            .padding(5)
                        
                    } placeholder: {
            
                        // MARK: Default user profile picture
                        Image(systemName: "person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .foregroundColor(.gray)
                            .padding(5)
                        
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
                Text("\(group?.name ?? "None")")
                  .font(.headline)
                  .font(.custom("Lato", size: 24))
              
              
              
              HStack {
                VStack {
                  Text("33")
                    .font(.system(size: 32))
                    .foregroundColor(deepPurple)
                    .bold()
                  Text("Completed")
                    .font(.system(size: 12))
                }
                .padding(.horizontal)
                .frame(minWidth: 75, minHeight: 25)
                
                VStack {
                  Text("3")
                    .foregroundColor(deepPurple)
                    .font(.system(size: 32))
                    .bold()
                  Text("Pending")
                    .font(.system(size: 12))
                }
                .padding(.horizontal)
                .frame(minWidth: 75, minHeight: 25)
                
                
              }.padding(25)
                .background(
                  RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray, lineWidth: 2)
                )
               
              
              Spacer()
              Button(action: {}) {
                Text("Leave")
              }
              .buttonStyle(LeaveButtonStyle())
              .padding(.horizontal)
              Button(action: {authViewModel.signOut()}) {
                Text("Sign Out")
              }
              .buttonStyle(LeaveButtonStyle())
              .padding([.horizontal, .bottom])
              
                // MARK: Profile setting menu
//                List {
//                    Section("Account") {
//                        HStack {
//                            Text("Allow Location")
//                            Spacer()
//                            Toggle(isOn: $allowLocation) {
//                                // TODO: Refactor as a new field in user struct
//                            }
//                        }
//                        HStack {
//                            if let group_code = group_code {
//                                Text("Group Code: \(group_code)")
//                            } else {
//                                Text("Group Code: N/A")
//                            }
//                        }
//
//                        Button {
//                            print("Leaving group...")
//                        } label: {
//                            Text("Leave Group")
//                        }
//
//                        Button {
//                            authViewModel.signOut()
//                        } label: {
//                            Text("Sign Out")
//                        }
//                    }.task {
//                        group = groupRepository.filterGroupsByID(user.group_id!)
//                        group_code = group?.code
//                    }
//                }
            }
        }
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
    ProfileView()
      .environmentObject(AuthViewModel.mock())
  }
}


// MARK: Preview causes this view to crash due to unwrapping of user (not sure what it is)

//#Preview {
//    ProfileView()
//}




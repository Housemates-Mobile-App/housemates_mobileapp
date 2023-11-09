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
    

    var body: some View {
        if let user = authViewModel.currentUser {
            VStack {
                ZStack (alignment: .bottomTrailing) {
                    let imageURL = URL(string: user.imageURLString ?? "")
                    
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .shadow(radius: 5)
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
                            .shadow(radius: 5)
                            .foregroundColor(.gray)
                            .padding(5)
                        
                    }

                    // MARK: Photo picker for changing profile picture
                    PhotosPicker(selection: $selectedPhoto,
                                 matching: .images) {
                            Image(systemName: "pencil.circle.fill")
                                .symbolRenderingMode(.multicolor)
                                .font(.system(size: 30))
                                .foregroundColor(.accentColor)
                    }.onChange(of: selectedPhoto) { newValue in
                        Task {
                            do {
                                if let data = try await newValue?.loadTransferable(type: Data.self) {
                                    if let uiImage = UIImage(data: data) {
                                        uiImageSelected = uiImage
//                                        _ = await authViewModel.saveProfilePicture(image: uiImageSelected)
                                    }
                                }
                            } catch {
                                print("ERROR: Selecting image failed \(error.localizedDescription)")
                            }
                        }
                        
                    }
                }.padding(10)
                
                
                // MARK: Profile setting menu
                List {
                    Section("Account") {
                        HStack {
                            Text("Allow Location")
                            Spacer()
                            Toggle(isOn: $allowLocation) {
                                // TODO: Refactor as a new field in user struct
                            }
                        }
                        HStack {
                            if let group_code = group_code {
                                Text("Group Code: \(group_code)")
                            } else {
                                Text("Group Code: N/A")
                            }
                        }
                        
                        Button {
                            print("Leaving group...")
                        } label: {
                            Text("Leave Group")
                        }
                        
                        Button {
                            authViewModel.signOut()
                        } label: {
                            Text("Sign Out")
                        }
                    }.task {
                        group = groupRepository.filterGroupsByID(user.group_id!)
                        group_code = group?.code
                    }
                }
            }
        }
    }
}


// MARK: Preview causes this view to crash due to unwrapping of user (not sure what it is)

//#Preview {
//    ProfileView()
//}




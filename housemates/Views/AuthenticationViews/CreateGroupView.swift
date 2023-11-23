//
//  CreateGroupView.swift
//  housemates
//
//  Created by Sean Pham on 11/3/23.
//

import SwiftUI

struct CreateGroupView: View {
    @State private var currentStep = 0
    @State private var group_name = ""
    @State private var address = ""
    @EnvironmentObject var authViewModel : AuthViewModel
    @EnvironmentObject var userViewModel : UserViewModel
    
    func createGroup() {
        DispatchQueue.main.async {
            Task {
                if let uid = authViewModel.currentUser?.id {
                    await userViewModel.createAndJoinGroup(group_name: group_name, address: address, uid: uid)
                    await authViewModel.fetchUser()
                }
            }
        }
    }
    
    func backButton() -> some View {
        Button(action: {
            if currentStep > 0 {
                currentStep -= 1
            }
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
                    .font(.system(size:22))
                    .bold()
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                if currentStep > 0 {
                    backButton()
                }
                Spacer()
            }
            ProgressBar(progress: calculateProgress())
                .frame(height: 10)
                .padding(.vertical)
                
            if currentStep == 0 {
                GroupNameView(group_name: $group_name) {
                    currentStep += 1
                }
            }
            else if currentStep == 1 {
                GroupAddressView(address: $address) {
                    if formisValid {
                        self.createGroup()
                    }
                }
            }

        }.padding(.horizontal)
        .padding(.top, 12)
    }
    
    func calculateProgress() -> Float {
        return Float(currentStep) / Float(2)
    }
}

// MARK: Authentication Protocol
extension CreateGroupView: AuthenticationFormProtocol {
    var formisValid: Bool {
        return (!group_name.isEmpty
                && !address.isEmpty
        )
    }
}
   

//#Preview {
//    CreateGroupView()
//        .environmentObject(AuthViewModel())
//        .environmentObject(UserViewModel())
//}
//    

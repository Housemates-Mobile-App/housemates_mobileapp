//
//  CreateGroupView.swift
//  housemates
//
//  Created by Sean Pham on 11/3/23.
//

import SwiftUI

struct CreateGroupView: View {
    @State private var group_name = ""
    @State private var address = ""
    @EnvironmentObject var authViewModel : AuthViewModel
    
    var body: some View {
        VStack {
            
            
            // MARK: Housemates Title
            Text("Create a New Housemates Group!").padding(.bottom, 12)
            
            // MARK: Create a Group Form
            VStack(spacing: 10) {
                InputView(text: $group_name,
                          title: "Group Name",
                          placeholder: "Best House")
                
                InputView(text: $address,
                          title: "Address",
                          placeholder: "500 Forbes Ave")
            }
        }.padding(.horizontal)
        .padding(.top, 12)
                
                // MARK: Button for creating and joining a new group
                Button {
                    Task {
                        try await authViewModel.createAndJoinGroup(group_name : group_name, address : address)
                    }
                } label: {
                    HStack {
                        Text("Create Group")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemBlue))
                .cornerRadius(10)
                .padding(.top, 24)
    }
}
   

//#Preview {
//    CreateGroupView()
//}
//    

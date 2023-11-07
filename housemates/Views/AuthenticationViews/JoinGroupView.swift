//
//  JoinGroupView.swift
//  housemates
//
//  Created by Sean Pham on 11/3/23.
//

import SwiftUI

struct JoinGroupView: View {
    @State private var group_code = ""
    @EnvironmentObject var authViewModel : AuthViewModel
    
    var body: some View {
        VStack {
            
            
            // MARK: Housemates Title
            Text("Enter Group Access Code!").padding(.bottom, 20)
            
            // MARK: Create a Group Form
            VStack(spacing: 10) {
                InputView(text: $group_code,
                          title: "Group Code",
                          placeholder: "8888")
            }
        }.padding(.horizontal)
        .padding(.top, 12)
                
                // MARK: Button for Joining Existing Group
                Button {
                    Task {
                        try await authViewModel.joinGroup(group_code)
                    }
                } label: {
                    HStack {
                        Text("Join Group")
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

#Preview {
    JoinGroupView()
}

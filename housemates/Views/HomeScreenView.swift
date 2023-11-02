//
//  HomeScreenView.swift
//  housemates
//
//  Created by Sean Pham on 11/2/23.
//

import SwiftUI

struct HomeScreenView: View {
    @EnvironmentObject var authViewModel : AuthViewModel

    var body: some View {
        Text("This is the home screen")
        
        Section("Account") {
            Button {
                authViewModel.signOut()
            } label: {
                Text("Sign Out")
            }
            
        }
    }
}

#Preview {
    HomeScreenView()
}

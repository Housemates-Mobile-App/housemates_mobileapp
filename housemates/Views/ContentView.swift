//
//  ContentView.swift
//  housemates
//
//  Created by Sean Pham on 10/31/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        SwiftUI.Group {
            if authViewModel.userSession != nil {
                if authViewModel.currentUser?.group_id != nil {
                    AuthContentView()
                } else {
                    JoinCreateGroupView()
                }
            } else {
                LoginView()
            }
        }
    }
}


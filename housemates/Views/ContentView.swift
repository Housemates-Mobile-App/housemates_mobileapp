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
                if authViewModel.isLoading {
                    // Show a loading indicator
                    ProgressView("Loading...")
                } else {
                    if authViewModel.userSession != nil {
                        if authViewModel.currentUser?.group_id != nil {
                            AuthContentView()
                                .onAppear { print("a") }
                        } else {
                            JoinCreateGroupView()
                                .onAppear { print("b") }
                        }
                    } else {
                        startView()
                            .onAppear { print("c") }
                    }
                }
            }
        }
}


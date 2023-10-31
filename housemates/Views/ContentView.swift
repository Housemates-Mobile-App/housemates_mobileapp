//
//  ContentView.swift
//  housemates
//
//  Created by Sean Pham on 10/31/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var groupRepository = GroupRepository()

    var body: some View {
        // Test to see if data can be loaded from firebase
        groupRepository.groups.forEach { group in print(group)}
        return Text("Hello, world!")
       
    }
}


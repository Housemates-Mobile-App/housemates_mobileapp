//
//  TaskSelectionBox.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/10/23.
//

import SwiftUI

struct TaskSelectionBox: View {
    var taskIconString: String
    var taskName: String
    var body: some View {
        VStack {
            Image(taskIconString)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40) // Adjust the size as needed
            
            Text(taskName)
                .font(.system(size:13))
                .padding(5)
                .bold()
                .foregroundColor(.white)
                .offset(y: 5)
        }.padding(5)
        .frame(width: 120, height: 120)
         .background(
            RoundedRectangle(cornerRadius: 15)
         .fill(.white.opacity(0.25))
        )
    }
}

#Preview {
    TaskSelectionBox(taskIconString:"housematesLogo", taskName: "Clean Dishes")
}

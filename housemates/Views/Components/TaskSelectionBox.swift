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
        VStack(spacing:0) {
            Image(taskIconString)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            
            Text(taskName)
                .font(.system(size:8))
                .bold()
                .foregroundColor(Color(red: 0.3725, green: 0.3373, blue: 0.3373))
                .offset(y: 5)
        }.padding(5)
        .frame(width: 75, height: 75)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(red: 0.3569, green: 0.0078, blue: 0.3490), lineWidth: 1)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                )
        )
    }
}

#Preview {
    TaskSelectionBox(taskIconString:"housematesLogo", taskName: "Clean Dishes")
}

//
//  GroupNameView.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/18/23.
//

import SwiftUI

struct GroupNameView: View {
    @Binding var group_name: String
    var onContinue: () -> Void

    var isGroupNameValid: Bool {
        !group_name.isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("What's the group name?")
                .font(.custom("Lato-Bold", size: 25))
                .bold()
            
            InputView(text: $group_name,
              title: "Group Name",
              placeholder: "Best House")
            .padding(.bottom, 25)

            HStack {
                Spacer()
                Button(action: onContinue) {
                    Text("NEXT")
                        .font(.custom("Nunito-Bold", size: 25))
                        .foregroundColor(.white)
                        .padding(10)
                        .frame(width:130)
                        .background(Color(red: 0.439, green: 0.298, blue: 1.0))
                        .cornerRadius(25)
                }.disabled(!isGroupNameValid)
                    .opacity(isGroupNameValid ? 1.0 : 0.5)
                Spacer()
            }
            Spacer()
        }
    }
}

struct GroupNameView_Previews: PreviewProvider {
    static var previews: some View {
        GroupNameView(group_name: .constant(""), onContinue: {})
    }
}

//
//  GroupAddressView.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/18/23.
//

import SwiftUI

struct GroupAddressView: View {
    @Binding var address: String
    var onContinue: () -> Void

    var isGroupAddressValid: Bool {
        !address.isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("What's the group address?")
                .font(.custom("Lato-Bold", size: 25))
                .bold()
            
            InputView(text: $address,
              title: "Group Address",
              placeholder: "4500 Centre Ave")
            .padding(.bottom, 25)

            HStack {
                Spacer()
                Button(action: onContinue) {
                    Text("DONE")
                        .font(.custom("Nunito-Bold", size: 25))
                        .foregroundColor(.white)
                        .padding(10)
                        .frame(width:130)
                        .background(Color(red: 0.439, green: 0.298, blue: 1.0))
                        .cornerRadius(25)
                }.disabled(!isGroupAddressValid)
                    .opacity(isGroupAddressValid ? 1.0 : 0.5)
                Spacer()
            }


            
            Spacer()
        }.navigationBarBackButtonHidden(true)
    }
}

struct GroupAddressView_Previews: PreviewProvider {
    static var previews: some View {
        GroupAddressView(address: .constant(""), onContinue: {})
    }
}

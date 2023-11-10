//
//  AllHousematesView.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/9/23.
//

import SwiftUI

struct AllHousematesView: View {
    @EnvironmentObject var authViewModel : AuthViewModel
    @EnvironmentObject var userViewModel : UserViewModel
    
    var body: some View {
        if let user = authViewModel.currentUser {
            
            VStack(spacing: 10)  {
                Text("Housemates")
                    .font(.system(size: 30))
                    .frame(alignment: .leading)
                Divider()
                ForEach(userViewModel.getUserGroupmatesInclusive(user.id!)) { mate in
                        AllHousematesCard(housemate: mate)
                }
                Text("Nice To Know")
                    .font(.system(size: 30))
                    .frame(alignment: .leading)
                Divider()
                HStack {
                    
                }
            }
        }
    }
}

#Preview {
    AllHousematesView()
}

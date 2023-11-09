//
//  JoinGroupView.swift
//  housemates
//
//  Created by Sean Pham on 11/3/23.
//

import SwiftUI

struct JoinGroupView: View {
    @State private var group_code: [String] = Array(repeating: "", count: 4)
    @FocusState private var focusedField: Int?
    @EnvironmentObject var authViewModel : AuthViewModel
    @EnvironmentObject var userViewModel : UserViewModel


    let numOfFields = 4
    
    var body: some View {
        VStack {
            
            
            // MARK: Housemates Title
            Text("Enter Group Access Code!")
                .padding(.bottom, 20)
                .font(Font.system(size: 25))
            
            // MARK: Create a Group Form
                HStack(spacing: 10) {
                    ForEach(0..<numOfFields, id: \.self) { index in
                        TextField("",
                                  text: $group_code[index],
                                  prompt: Text("0"))
                            .keyboardType(.numberPad)
                            .font(Font.system(size: 60))
                            .multilineTextAlignment(.center)
                            .padding(.all, 10)
                            .focused($focusedField, equals: index)
                            .onChange(of: group_code[index]) { newValue in
                                if newValue.count >= 1 {
                                    if newValue.count > 1 {
                                        group_code[index] = String(newValue.prefix(1))
                                    }
                                    moveFocusToNextField(currentIndex: index)
                                }
                                else if newValue.count == 0 {
                                    moveFocusToPrevField(currentIndex: index)
                                }
                                else if newValue.isEmpty {
                                        moveFocusToPrevField(currentIndex: index)
                                    }
                            }
                            .frame(width: 60, height: 80)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(
                                group_code[index].isEmpty ? Color.blue : Color.green,
                                lineWidth: 2
                            ))
                    }
                }
                .onChange(of: focusedField) { newFocusedField in
                    if let field = newFocusedField, group_code[field].isEmpty {
                        focusedField = field
                    }
                }
        }.padding(.horizontal)
        .padding(.top, 12)

                // MARK: Button for Joining Existing Group
                Button {
                    Task {
                        
                        if let user = authViewModel.currentUser {
                            if let updatedUser = userViewModel.joinGroup(group_code: group_code.joined(), uid: user.id!) {
                                await authViewModel.setUser(user: updatedUser)
                            }
                        }
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
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.top, 24)
    }
    func moveFocusToNextField(currentIndex: Int) {
        if currentIndex < numOfFields - 1 {
            focusedField = currentIndex + 1
        }
    }
    
    func moveFocusToPrevField(currentIndex: Int) {
        if currentIndex > 0 {
            focusedField = currentIndex - 1
        }
    }
}

#Preview {
    JoinGroupView()
}

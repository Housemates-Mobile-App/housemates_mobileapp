//
//  HomeScreenView.swift
//  housemates
//
//  Created by Sean Pham on 11/2/23.
//

import SwiftUI

struct AuthContentView: View {
    @State var selected = 0
    @EnvironmentObject var tabBarViewModel : TabBarViewModel
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
      
            
        ZStack(alignment: .bottom) {
            if selected == 0 {
                HomeView()
                
            } else if selected == 1 {
                TaskBoardView()
                
            } else if selected == 2 {
                DashboardView()

            } else if selected == 3 {
                ProfileView()

            }
            
            if tabBarViewModel.hideTabBar == false {
                BottomBar(selected : $selected).padding()
                    .padding(.horizontal, 22)
                    .background(CurvedShape())
                
                Button(action: {
                    tabBarViewModel.showTaskSelectionView = true
                }) {
                    Image(systemName: "plus").padding(18)
                        .foregroundColor(.white)
                }.background(Color(red: 0.439, green: 0.298, blue: 1.0))
                    .clipShape(Circle())
                    .offset(y: -20)
                    .shadow(radius: 5)
            }
        }.sheet(isPresented: $tabBarViewModel.showTaskSelectionView) {
            TaskSelectionView(user: authViewModel.currentUser!)
        }.onAppear {
            taskViewModel.setupRecurringTaskReset()
        }
        
    }
}

struct CurvedShape: View {
    var body: some View {
        Path{path in
            path.move(to : CGPoint(x: 0, y: -50))
            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: -50))
            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: 45))
            
            path.addArc(center: CGPoint(x: UIScreen.main.bounds.width / 2, y: 45), radius: 32, startAngle: .zero, endAngle: .init(degrees: 180), clockwise: true)
            
            path.addLine(to: CGPoint(x: 0, y: 45))
        }.fill(Color.white)
        .rotationEffect(.init(degrees: 180))
        .shadow(radius: 5)
    }
}

struct tabHighlight: Shape {
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 10, height: 10))
        return Path(path.cgPath)
    }
}

struct BottomBar: View {
    @Binding var selected : Int
    
    var body: some View {
        HStack {
            VStack {
                tabHighlight()
                    .fill(Color(red: 0.439, green: 0.298, blue: 1.0).opacity(selected == 0 ? 1 : 0))
                    .frame(width: 45, height: 6)
                    .offset(y: 7)
                
                Button(action: {
                    withAnimation(.easeIn(duration: 0.15), {
                        self.selected = 0
                    })
                }) {
                    
                    Image(systemName: "house.fill")
                        .font(.system(size: 22))
                        .offset(y: 13)
                    
                }.foregroundColor(self.selected == 0 ? Color(red: 0.439, green: 0.298, blue: 1.0) : .gray)
            }.offset(x: -10)
            
            Spacer(minLength: 12)
            
            VStack {
                tabHighlight()
                    .fill(Color(red: 0.439, green: 0.298, blue: 1.0).opacity(selected == 1 ? 1 : 0))
                    .frame(width: 45, height: 6)
                    .offset(y: 5)
                Button(action: {
                    withAnimation(.easeIn(duration: 0.15), {
                        self.selected = 1
                    })
                }) {
                    Image(systemName: "checkmark.square.fill")
                        .font(.system(size: 23))
                        .offset(y: 15)
                }.foregroundColor(self.selected == 1 ? Color(red: 0.439, green: 0.298, blue: 1.0) : .gray)
            }
            
            Spacer().frame(width: 95)
            
            
            VStack {
                tabHighlight()
                    .fill(Color(red: 0.439, green: 0.298, blue: 1.0).opacity(selected == 2 ? 1 : 0))
                    .frame(width: 45, height: 6)
                    .offset(y: 6)
                
                Button(action: {
                    withAnimation(.easeIn(duration: 0.15), {
                        self.selected = 2
                    })
                }) {
                    Image(systemName: "chart.pie.fill")
                        .font(.system(size: 22))
                        .offset(y: 15)
                }.foregroundColor(self.selected == 2 ? Color(red: 0.439, green: 0.298, blue: 1.0) : .gray)
            }
            Spacer(minLength: 12)
            
            VStack {
                tabHighlight()
                    .fill(Color(red: 0.439, green: 0.298, blue: 1.0).opacity(selected == 3 ? 1 : 0))
                    .frame(width: 45, height: 6)
                    .offset(y: 4)
                
                Button(action: {
                    withAnimation(.easeIn(duration: 0.15), {
                        self.selected = 3
                    })
                }) {
                    Image(systemName: "person.fill")
                        .font(.system(size: 22))
                        .offset(y: 15)
                }.foregroundColor(self.selected == 3 ? Color(red: 0.439, green: 0.298, blue: 1.0) : .gray)
            }.offset(x: 10)
        }
    }
}

//#Preview {
//    AuthContentView()
//}

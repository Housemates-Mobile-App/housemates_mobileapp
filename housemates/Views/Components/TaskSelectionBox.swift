import SwiftUI

struct TaskSelectionBox: View {
    var taskIconString: String
    var taskName: String

    var body: some View {
      VStack(alignment: .center) {
        
        VStack {
          taskIcon
        }
        .padding(5)
        .background(taskBackground)
        taskNameView
      }.padding(.horizontal, 15)
    }

    private var taskIcon: some View {
        Image(taskIconString)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 75, height: 75)
    }

    private var taskNameView: some View {
        Text(taskName)
            .font(.system(size: 12))
            .foregroundColor(Color(red: 0.3725, green: 0.3373, blue: 0.3373))
            .frame(alignment: .center)
    }

    private var taskBackground: some View {
        RoundedRectangle(cornerRadius: 15)
        .stroke(Color.black.opacity(0.25))
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
            )
    }

    
}

//#Preview {
//    TaskSelectionBox(taskIconString:"housematesLogo", taskName: "Clean Dishes")
//}

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
            .frame(width: 50, height: 50)
    }

    private var taskNameView: some View {
        Text(taskName)
            .font(.system(size: 12))
            .foregroundColor(.primary.opacity(0.75))
            .frame(alignment: .center)
    }

    private var taskBackground: some View {
        RoundedRectangle(cornerRadius: 15)
        .stroke(Color.gray.opacity(0.15))
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.gray.opacity(0.15))
            )
    }

    
}

//#Preview {
//    TaskSelectionBox(taskIconString:"housematesLogo", taskName: "Clean Dishes")
//}

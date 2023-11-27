import SwiftUI

struct SliderPicker: View {
    @Binding var selectedPriority: TaskViewModel.TaskPriority

  var body: some View {
    
    VStack(alignment: .leading) {
      Text("Priority")
        .font(.custom("Lato-Bold", size: 18))
        .padding(.horizontal)
      
      GeometryReader { geometry in
        ZStack(alignment: .leading) {
          // Background view that slides
          RoundedRectangle(cornerRadius: 8)
            .fill(self.backgroundColor(for: selectedPriority))
            .frame(width: geometry.size.width / CGFloat(TaskViewModel.TaskPriority.allCases.count), height: geometry.size.height)
            .offset(x: self.calculateOffset(width: geometry.size.width, for: selectedPriority))
          
          // Text elements
          HStack {
            ForEach(TaskViewModel.TaskPriority.allCases, id: \.self) { priority in
              Text(priority.rawValue)
                .font(.custom(selectedPriority ==  priority ? "Lato-Bold" : "Lato", size: 15))
                .foregroundColor(selectedPriority == priority ? .white : .black)
                .padding()
                .frame(maxWidth: .infinity)
                .onTapGesture {
                  withAnimation(.easeInOut) {
                    self.selectedPriority = priority
                  }
                }
            }
          }
        }
      }
    
    .frame(height: 40) // Set the desired height for your segmented control
    .padding(.horizontal)
  }
    }

    private func backgroundColor(for priority: TaskViewModel.TaskPriority) -> Color {
        switch priority {
        case .low:
            return .green
        case .medium:
            return .yellow
        case .high:
            return .red
        }
    }

    private func calculateOffset(width: CGFloat, for priority: TaskViewModel.TaskPriority) -> CGFloat {
        let segmentWidth = width / CGFloat(TaskViewModel.TaskPriority.allCases.count)
        if let index = TaskViewModel.TaskPriority.allCases.firstIndex(of: priority) {
            return segmentWidth * CGFloat(index)
        }
        return 0
    }
}

struct SliderPicker_Previews: PreviewProvider {
    static var previews: some View {
        SliderPicker(selectedPriority: .constant(TaskViewModel.TaskPriority.medium))
    }
}

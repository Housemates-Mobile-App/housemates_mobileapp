import SwiftUI

struct GraphView: View {
    let data: [Double] = [8, 12, 7, 13, 10, 5, 9] // Example data for the graph bars
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .gray, radius: 10, x: 0, y: 10)
            
            VStack {
                Text("Title")
                    .font(.headline)
                
                HStack(alignment: .bottom, spacing: 8) {
                    ForEach(data, id: \.self) { value in
                        VStack {
                            Spacer()
                            Rectangle()
                                .fill(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .top, endPoint: .bottom))
                                .frame(width: 20, height: value)
                            Text("Legend")
                                .font(.caption)
                        }
                    }
                }
                .padding()
            }
        }
        .frame(height: 200)
        .padding()
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
            .previewLayout(.sizeThatFits)
    }
}

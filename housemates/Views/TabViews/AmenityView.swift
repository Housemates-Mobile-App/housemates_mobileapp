//
//  AmentityView.swift
//  housemates
//
import SwiftUI

struct Amenity: Identifiable {
    let id: UUID
    let name: String
    var status: String
}

struct AmenityView: View {
    @EnvironmentObject var taskViewModel : TaskViewModel
    @EnvironmentObject var authViewModel : AuthViewModel
    
//    var amenity = housemates.Amentity(from: <#Decoder#>)
    
    // Sample data for amenities
    @State private var amenities: [Amenity] = [
        Amenity(id: UUID(), name: "Kitchen", status: "You are using"),
        Amenity(id: UUID(), name: "Laundry", status: "In Use"),
        Amenity(id: UUID(), name: "Bathroom #1", status: "Available"),
        Amenity(id: UUID(), name: "Bathroom #2", status: "In Use")
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(amenities) { amenity in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(amenity.name)
                                    .font(.headline)
                                Text(amenity.status)
                                    .font(.subheadline)
                                    .foregroundColor(amenity.status == "Available" ? .green : .red)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                // Implement action
                            }) {
                                Text(amenity.status == "Available" ? "USE" : "DONE")
                                    .foregroundColor(.blue)
                            }
                            .frame(minWidth: 70)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Shared Amenities")
        }
    }
}

 
//struct AmenitiesView_Previews: PreviewProvider {
//    static var previews: some View {
//        AmenityView()
//    }
//}

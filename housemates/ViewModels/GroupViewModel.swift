//
//  GroupViewModel.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/13/23.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore


class GroupViewModel: ObservableObject {
    private let groupRepository = GroupRepository()
    
    @Published var groups: [Group] = []
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        groupRepository.$groups
            .receive(on: DispatchQueue.main)
            .sink { updatedGroups in
                self.groups = updatedGroups
            }
            .store(in: &self.cancellables)
        
    }
    
    func getGroupByID(_ gid: String) -> Group? {
        let filteredGroup = self.groups.filter { $0.id == gid }
        return filteredGroup.first
    }
}

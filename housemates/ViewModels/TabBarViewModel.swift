//
//  TabBarViewModel.swift
//  housemates
//
//  Created by Sean Pham on 12/4/23.
//

import Foundation

class TabBarViewModel: ObservableObject {
    @Published var hideTabBar: Bool = false
    @Published var showTaskSelectionView: Bool = false
    @Published var showAddTaskBanner: Bool = false
    @Published var showEditTaskBanner: Bool = false
    @Published var showAddPostBanner: Bool = false
    @Published var selectedTab: Int = 0

}

extension TabBarViewModel {
    static func mock() -> TabBarViewModel {
        let mockTabBarViewModel = TabBarViewModel()
        return mockTabBarViewModel
    }
}


extension TabBarViewModel {
    static func mockShowTaskSelection() -> TabBarViewModel {
        let mockTabBarViewModel = TabBarViewModel()
        mockTabBarViewModel.showTaskSelectionView = true
        mockTabBarViewModel.hideTabBar = true
        return mockTabBarViewModel
    }
}

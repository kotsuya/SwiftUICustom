//
//  UserListViewModel.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/11/02.
//

import Foundation

enum LoadingStatus {
    case none
    case loading
    case completed
    case error(String)
    case empty
}

@MainActor
final class UserListViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var showError = false
    @Published var loadingStatus: LoadingStatus = .none
    
    func getUsers() async {
        loadingStatus = .loading
        
        do {
            let users = try await WebService.getUsersData()
            self.users = users
            
            loadingStatus = users.isEmpty ? .empty : .completed
        } catch let error {
            self.showError = true
            
            loadingStatus = .error(error.localizedDescription)
        }
    }
}

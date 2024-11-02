//
//  WebService.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/11/02.
//

import Foundation

final class WebService {    
    static func getUsersData() async throws -> [User] {
        let urlStr = "https://api.github.com/users"
        guard let url = URL(string: urlStr) else { throw ErrorCases.invalidURL }
        
        let (data, res) = try await URLSession.shared.data(from: url)
        
        guard let response = res as? HTTPURLResponse,
              response.statusCode == 200 else {
            throw ErrorCases.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([User].self, from: data)
        } catch {
            throw ErrorCases.invalidData
        }
    }
    
}


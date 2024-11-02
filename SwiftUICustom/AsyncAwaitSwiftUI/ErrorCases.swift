//
//  ErrorCases.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/11/02.
//

import Foundation

enum ErrorCases: LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid Response"
        case .invalidData: return "Invalid Data"
        }
    }
}

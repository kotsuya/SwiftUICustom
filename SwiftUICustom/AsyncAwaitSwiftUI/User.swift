//
//  UserModel.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/11/02.
//

import Foundation

struct User: Codable, Identifiable {
    let login: String?
    let id: Int?
    let avatarURL: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case login, id
        case avatarURL = "avatar_url"
        case url
    }
}

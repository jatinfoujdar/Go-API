//
//  AuthModel.swift
//  Portfolio-App
//
//  Created by jatin foujdar on 06/02/26.
//

import Foundation


 struct Link: Codable{
   var title: String
   var url: String
}

struct LoginRequest: Codable{
    let email: String
    let password: String
}


struct SignupRequest: Codable{
    let email: String
    let password: String
    let name: String
}

struct User: Codable {
    let id: String
    let name: String
    let email: String
    
    let avatar: String?
    let links: [Link]?
    
    let userType: String
    
    enum CodingKeys: String, CodingKey{
        case id, name, email, avatar, links, userType = "user_type"
    }
    
}

struct AuthResponse: Codable {
    let token: String
    let refresh_token: String
    let user: User
}

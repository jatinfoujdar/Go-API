//
//  AuthModel.swift
//  Portfolio-App
//
//  Created by jatin foujdar on 06/02/26.
//

import Foundation


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
    let user_type: String
}

struct AuthResponse: Codable {
    let token: String
    let refresh_token: String
    let user: User
}

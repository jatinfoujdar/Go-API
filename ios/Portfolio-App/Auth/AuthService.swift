//
//  AuthService.swift
//  Portfolio-App
//
//  Created by jatin foujdar on 06/02/26.
//

import Foundation

class AuthService{
    
    static let shared = AuthService()
    
    public init(){}
    
    private let baseURL = "http://127.0.0.1:8080"
    
    
    func login(email: String, password: String) async throws -> AuthResponse {
        
        
        guard let url = URL(string: "\(baseURL)/users/login") else{
            throw URLError(.badURL)
        }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = LoginRequest(email: email, password: password)
        
        req.httpBody = try? JSONEncoder().encode(body)
        
        let(data, res) = try await URLSession.shared.data(for: req)
        
        guard let http = res as? HTTPURLResponse else{
            throw URLError(.badServerResponse)
        }
        
        if http.statusCode != 200 {
            let errorMsg = String(data: data, encoding: .utf8) ?? "Unknown Error"
            throw NSError(domain: "AuthService", code: http.statusCode, userInfo: [
                NSLocalizedDescriptionKey: errorMsg
            ])
        }
        let decode = try JSONDecoder().decode(AuthResponse.self, from: data)
        
        UserDefaults.standard.set(decode.token, forKey: "jwt_token")
        
        return decode
    }
    
    
    
    
    func signup(email: String, password: String, name: String) async throws -> AuthResponse {
        
        
        guard let url = URL(string: "\(baseURL)/users/signup") else{
            throw URLError(.badURL)
        }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let body = SignupRequest(email: email, password: password, name: name)
        req.httpBody = try? JSONEncoder().encode(body)
        
        
        let(data, res) = try await URLSession.shared.data(for: req)
        
        guard let http = res as? HTTPURLResponse else{
            throw URLError(.badServerResponse)
        }
        
        if http.statusCode != 201 && http.statusCode != 200 {
            let errorMsg = String(data: data, encoding: .utf8) ?? "Unknown Error"
            throw NSError(domain: "AuthService", code: http.statusCode, userInfo: [
                NSLocalizedDescriptionKey: errorMsg
            ])
        }
        let decode = try JSONDecoder().decode(AuthResponse.self, from: data)
        
        UserDefaults.standard.set(decode.token, forKey: "jwt_token")
        
        return decode
    }
    
    
    func updateProfile(avatar: String?, links: [Link]?) async throws {
        
        guard let url = URL(string: "\(baseURL)/users/profile")else{
            throw URLError(.badURL)
        }
        
        var req = URLRequest(url: url)
        req.httpMethod = "PUT"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let token = UserDefaults.standard.string(forKey: "jwt_token") else{
            throw NSError(
                domain: "AuthService", code: 401, userInfo: [NSLocalizedDescriptionKey : "User not authenticated"]
            )
        }
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        var body: [String: Any] = [:]
        
        if let avatar = avatar{
            body["avatar"] = avatar
        }
        
        if let links = links{
            body["links"] = links.map{
                [
                    "title" : $0.title,
                    "url" : $0.url
                ]
            }
        }
        req.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let(_, res) = try await URLSession.shared.data(for: req)
        
        guard let http = res as? HTTPURLResponse else{
            throw URLError(.badServerResponse)
        }
        
        if http.statusCode != 200{
            throw NSError(
                domain: "AuthService", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey : "Failed to update profile"]
            )
        }
    }
}

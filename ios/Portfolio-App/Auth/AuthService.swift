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
    
    
    
}

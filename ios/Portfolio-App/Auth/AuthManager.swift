//
//  AuthManager.swift
//  Portfolio-App
//
//  Created for centralization of authentication state
//

import SwiftUI
import Combine

class AuthManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: User?
    
    init() {
        checkAuthStatus()
    }
    
    func checkAuthStatus() {
        if let token = UserDefaults.standard.string(forKey: "jwt_token"), !token.isEmpty {
            // In a real app, you might want to validate the token or fetch the user profile here
            // For now, we'll just assume valid token means authenticated
            isAuthenticated = true
            
            // Note: detailed user info would typically be fetched from an API /users/me endpoint
            // using the token if not persisted locally.
        } else {
            isAuthenticated = false
            currentUser = nil
        }
    }
    
    func login(user: User, token: String) {
        // Save token
        UserDefaults.standard.set(token, forKey: "jwt_token")
        
        // Update state
        DispatchQueue.main.async {
            self.objectWillChange.send()
            self.currentUser = user
            self.isAuthenticated = true
        }
    }
    
    func logout() {
        // Remove token
        UserDefaults.standard.removeObject(forKey: "jwt_token")
        
        // Update state
        self.currentUser = nil
        self.isAuthenticated = false
    }
}

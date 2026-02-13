//
//  RootView.swift
//  Portfolio-App
//
//  Created by jatin foujdar on 13/02/26.
//

import SwiftUI

struct RootView: View {
    
    @State private var isAuthenticated: Bool = false
    
    var body: some View {
    
        Group {
            if isAuthenticated {
                // Main app - user is logged in
                NavigationStack {
                    ProfileCardView(manager: ProfileManager(
                        user: User(
                            id: "",
                            name: "Loading...",
                            email: "",
                            avatar: nil,
                            links: [],
                            userType: ""
                        )
                    ))
                }
            } else {
                // Auth flow - user NOT logged in
                ContentView()
            }
        }
        .onAppear {
            checkAuthStatus()
        }
    }
    
    private func checkAuthStatus() {
        // Check if JWT token exists in UserDefaults
        if let token = UserDefaults.standard.string(forKey: "jwt_token"), !token.isEmpty {
            isAuthenticated = true
        } else {
            isAuthenticated = false
        }
    }
}

#Preview {
    RootView()
}

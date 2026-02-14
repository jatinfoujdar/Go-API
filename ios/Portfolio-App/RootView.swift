//
//  RootView.swift
//  Portfolio-App
//
//  Created by jatin foujdar on 13/02/26.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var authManager: AuthManager
    
    @State private var isTreeAnimationCompleted = false
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                if isTreeAnimationCompleted {
                    // Main app - user is logged in
                    // Using a dummy user if currentUser is nil but auth is true (e.g. fresh launch)
                    // Ideally, you'd fetch the user profile here if currentUser is nil
                    if let user = authManager.currentUser {
                        NavigationStack {
                            ProfileCardView(manager: ProfileManager(user: user))
                        }
                    } else {
                         // Fallback/Loading state while we might fetch user details
                         // For this iteration, we might need to handle the case where we have a token but no user object in memory yet.
                         // A simple solution for now is to create a placeholder or fetch.
                         // Let's assume for the immediate login flow, currentUser is set.
                         NavigationStack {
                             ProfileCardView(manager: ProfileManager(
                                user: User(
                                    id: "1",
                                    name: "Loading...",
                                    email: "",
                                    avatar: nil,
                                    links: [],
                                    userType: ""
                                )
                            ))
                         }
                    }
                } else {
                    // Show transition animation
                    TreeLoadingView {
                        withAnimation {
                            isTreeAnimationCompleted = true
                        }
                    }
                    .transition(.opacity)
                }
            } else {
                // Auth flow - user NOT logged in
                ContentView()
                    // .environmentObject(authManager) // Auto-inherited
            }
        }
        .onChange(of: authManager.isAuthenticated) { oldValue, newValue in
            if !newValue {
                // Reset animation state on logout
                isTreeAnimationCompleted = false
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AuthManager())
}

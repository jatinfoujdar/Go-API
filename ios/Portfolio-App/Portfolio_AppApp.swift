//
//  Portfolio_AppApp.swift
//  Portfolio-App
//
//  Created by jatin foujdar on 06/02/26.
//

import SwiftUI

@main
struct Portfolio_AppApp: App {
    @StateObject private var authManager = AuthManager()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(.dark)
                .environmentObject(authManager)
        }
    }
}

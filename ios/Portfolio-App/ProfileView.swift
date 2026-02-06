//
//  ProfileView.swift
//  Portfolio-App
//
//  Created by jatin foujdar on 06/02/26.
//

import SwiftUI

struct ProfileView: View {
    let name: String
    let email: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.orange)
            
            VStack(spacing: 8) {
                Text(name)
                    .font(.title)
                    .bold()
                
                Text(email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button("Log Out") {
                // Handle logout logic
            }
            .foregroundColor(.red)
        }
        .padding()
        .navigationTitle("Profile")
    }
}

#Preview {
    ProfileView(name: "Jatin", email: "jatin@example.com")
}

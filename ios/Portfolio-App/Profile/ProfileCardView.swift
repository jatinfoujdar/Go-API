//
//  ProfileCardView.swift
//  Portfolio-App
//
//  Created by jatin foujdar on 10/02/26.
//
//
//  ProfileCardView.swift
//  Portfolio-App
//
//  Created by jatin foujdar on 10/02/26.
//

import SwiftUI

struct ProfileCardView: View {
    
    @ObservedObject var manager: ProfileManager
    
    var body: some View {
        ZStack {
            // Background image
            Image("4")
                .resizable()
                .scaledToFill()
                
            
            // Glass layer
      
            
            VStack(spacing: 16) {
                
                // Avatar
                AsyncImage(url: URL(string: manager.user.avatar ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    default:
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white.opacity(0.7))
                            .padding(24)
                    }
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(.white.opacity(0.6), lineWidth: 2)
                )
                .shadow(radius: 8)
                
                // Name + Email
                VStack(spacing: 6) {
                    Text(manager.user.name)
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(manager.user.email)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                // Links
                if let links = manager.user.links, !links.isEmpty {
                    VStack(spacing: 10) {
                        ForEach(links, id: \.url) { socialLink in
                            if let url = URL(string: socialLink.url) {
                                SwiftUI.Link(destination: url) {
                                    HStack {
                                        Text(socialLink.title)
                                            .font(.system(size: 15, weight: .semibold))
                                        Spacer()
                                        Image(systemName: "arrow.up.right")
                                    }
                                    .padding()
                                    
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                                }
                                .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.top, 8)
                }
                
                Spacer()
            }
            .padding(24)
        }
        .frame(width: 350, height: 520)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(.white.opacity(0.25), lineWidth: 1.5)
        )
        .shadow(color: .black.opacity(0.4), radius: 20, y: 12)
        // Navigation button in top-right corner
        .overlay(
            NavigationLink {
                ProfileView(manager: manager)
            } label: {
                Image(systemName: "person.circle")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                    .padding()
            },
            alignment: .topTrailing
        )
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        ProfileCardView(
            manager: ProfileManager(
                user: User(
                    id: "1",
                    name: "Jatin Foujdar",
                    email: "jatin@email.com",
                    avatar: "https://i.pravatar.cc/300",
                    links: [
                        Link(title: "GitHub", url: "https://github.com"),
                        Link(title: "LinkedIn", url: "https://linkedin.com")
                    ],
                    userType: "creator"
                )
            )
        )
        .preferredColorScheme(.dark)
        .padding()
        
    }
}

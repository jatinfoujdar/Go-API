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
    let avatar: String?
    let links: [Link]

    var body: some View {
        VStack(spacing: 20) {
            
            AsyncImage(url: URL(string: avatar ?? "")){ phase in
                
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 100, height: 100)
                case .success(let image):
                    image
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.orange)
                        .clipShape(Circle())
                case .failure:
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.orange)
                    
                @unknown default:
                    EmptyView()
                }
            }               
                
                VStack(spacing: 8) {
                    Text(name)
                        .font(.title)
                        .bold()
                    
                    Text(email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if !links.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Links")
                            .font(.headline)
                        
                        ForEach(links, id: \.url) { socialLink in
                            if let url = URL(string: socialLink.url) {
                                SwiftUI.Link(destination: url) {
                                    HStack {
                                        Text(socialLink.title)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                    }
                                }
                            }
                        }
                    }
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
    ProfileView(
        name: "Jatin",
        email: "jatin@example.com",
        avatar: "https://avatars.githubusercontent.com/u/1?v=4",
        links: [
            Link(title: "GitHub", url: "https://github.com/jatin"),
            Link(title: "LinkedIn", url: "https://linkedin.com/in/jatin"),
            Link(title: "Portfolio", url: "https://jatin.dev")
        ]
    )
}


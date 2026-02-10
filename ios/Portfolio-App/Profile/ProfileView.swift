//
//  ProfileView.swift
//  Portfolio-App
//
//  Created by jatin foujdar on 06/02/26.
//

import SwiftUI

struct ProfileView: View {
    
    // MARK: - Editable State
    @State private var name: String
    @State private var avatarURL: String
    @State private var links: [Link]
    
    // For new link input
    @State private var newLinkTitle: String = ""
    @State private var newLinkURL: String = ""
    
    @Environment(\.dismiss) var dismiss
    @State private var isLoading = false
    @State private var errorMessage = ""
    
    // Init from existing user
    init(user: User) {
        _name = State(initialValue: user.name)
        _avatarURL = State(initialValue: user.avatar ?? "")
        _links = State(initialValue: user.links ?? [])
    }
    
    var body: some View {
        Form {
            if !errorMessage.isEmpty {
                Section {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
            
            Section(header: Text("Profile Information")) {
                
                // Avatar Preview (Centered)
                HStack {
                    Spacer()
                    AsyncImage(url: URL(string: avatarURL)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 80, height: 80)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        case .failure:
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .overlay(Circle().stroke(Color.secondary.opacity(0.2), lineWidth: 1))
                    Spacer()
                }
                .padding(.vertical, 8)
                .listRowBackground(Color.clear)
                
                TextField("Name", text: $name)
                TextField("Avatar URL", text: $avatarURL)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .keyboardType(.URL)
            }
            
            // MARK: - Social Links Section
            Section(header: Text("Social Links")) {
                
                ForEach(links.indices, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 5) {
                        TextField("Title", text: $links[index].title)
                            .font(.headline)
                        TextField("URL", text: $links[index].url)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .autocapitalization(.none)
                            .keyboardType(.URL)
                    }
                    .padding(.vertical, 4)
                }
                .onDelete { indices in
                    links.remove(atOffsets: indices)
                }
                
                // Add new link
                VStack(spacing: 10) {
                    HStack {
                        TextField("New Link Title", text: $newLinkTitle)
                        TextField("New Link URL", text: $newLinkURL)
                            .autocapitalization(.none)
                            .keyboardType(.URL)
                    }
                    
                    Button(action: addNewLink) {
                        Label("Add Link", systemImage: "plus.circle.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .disabled(newLinkTitle.isEmpty || newLinkURL.isEmpty)
                }
                .padding(.vertical, 8)
            }
            
            // MARK: - Actions
            Section {
                Button(action: saveProfile) {
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Save Changes")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                    }
                }
                .disabled(isLoading)
                
                Button("Log Out") {
                    UserDefaults.standard.removeObject(forKey: "jwt_token")
                    // In a real app, you'd trigger a root view change here
                    dismiss()
                }
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveProfile()
                }
                .disabled(isLoading)
            }
        }
    }
    
    // MARK: - Functions
    
    private func addNewLink() {
        links.append(Link(title: newLinkTitle, url: newLinkURL))
        newLinkTitle = ""
        newLinkURL = ""
    }
    
    private func saveProfile() {
        isLoading = true
        errorMessage = ""
        
        Task {
            do {
                try await AuthService.shared.updateProfile(avatar: avatarURL, links: links)
                print("Profile updated successfully")
                isLoading = false
                dismiss() // Return to the Card view
            } catch {
                print("Error updating profile: \(error)")
                errorMessage = "Failed to update profile. Please try again."
                isLoading = false
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        ProfileView(user: User(
            id: "1",
            name: "Jatin Foujdar",
            email: "jatin@email.com",
            avatar: nil,
            links: [],
            userType: "creator"
        ))
    }
}

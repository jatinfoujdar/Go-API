//
//  ProfileView.swift
//  Portfolio-App
//
//  Created by jatin foujdar on 06/02/26.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var manager: ProfileManager
    
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
    
    // Init from manager
    init(manager: ProfileManager) {
        self.manager = manager
        _name = State(initialValue: manager.user.name)
        _avatarURL = State(initialValue: manager.user.avatar ?? "")
        _links = State(initialValue: manager.user.links ?? [])
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
                
                HStack {
                    TextField("Avatar URL", text: $avatarURL)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .keyboardType(.URL)
                    
                    Button {
                        if let pasted = UIPasteboard.general.string {
                            avatarURL = pasted
                        }
                    } label: {
                        Image(systemName: "doc.on.clipboard")
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(.borderless)
                }
            }
            
            // MARK: - Social Links Section
            Section(header: Text("Social Links")) {
                
                ForEach(links.indices, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 5) {
                        TextField("Title", text: $links[index].title)
                            .font(.headline)
                        
                        HStack {
                            TextField("URL", text: $links[index].url)
                                .font(.subheadline)
                                .foregroundColor(.blue)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .keyboardType(.URL)
                            
                            Button {
                                if let pasted = UIPasteboard.general.string {
                                    links[index].url = pasted
                                }
                            } label: {
                                Image(systemName: "doc.on.clipboard")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .onDelete { indices in
                    links.remove(atOffsets: indices)
                }
                
                // Add new link
                VStack(spacing: 12) {
                    TextField("New Link Title", text: $newLinkTitle)
                    
                    HStack {
                        TextField("New Link URL", text: $newLinkURL)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .keyboardType(.URL)
                        
                        Button {
                            if let pasted = UIPasteboard.general.string {
                                newLinkURL = pasted
                            }
                        } label: {
                            Image(systemName: "doc.on.clipboard")
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(.borderless)
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
                
                // Update the shared state so the Card view refreshes
                let updatedUser = User(
                    id: manager.user.id,
                    name: name,
                    email: manager.user.email,
                    avatar: avatarURL,
                    links: links,
                    userType: manager.user.userType
                )
                
                await MainActor.run {
                    manager.user = updatedUser
                    print("Profile updated successfully in shared state")
                    isLoading = false
                    dismiss()
                }
            } catch {
                print("Error updating profile: \(error)")
                await MainActor.run {
                    errorMessage = "Failed to update profile. Please try again."
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(manager: ProfileManager(
            user: User(
                id: "1",
                name: "Jatin Foujdar",
                email: "jatin@email.com",
                avatar: nil,
                links: [],
                userType: "creator"
            )
        ))
    }
    .preferredColorScheme(.dark)
}

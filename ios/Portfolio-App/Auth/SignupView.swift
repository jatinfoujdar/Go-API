//
//  SignupView.swift
//  Portfolio-App
//
//  Created by jatin foujdar on 06/02/26.
//

import SwiftUI
import RiveRuntime

struct SignupView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var navigateToProfile = false
    @State private var loggedInUser: User?
    @State private var manager: ProfileManager?
    
    // Rive
    @StateObject private var riveController = RiveController()
    
    enum FocusField {
        case name, email, password
    }
    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                // Header / Close
                ZStack {
                    HStack {
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.primary)
                                .padding(10)
                                .background(Color(UIColor.secondarySystemBackground))
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    
                    Text("Create Account")
                        .font(.headline)
                        .opacity(0.7)
                }
                .padding(.top, 10)
                
                // Rive Animation
                riveController.view()
                    .frame(height: 200)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                
                VStack(spacing: 12) {
                    
                    // Name Field
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(.orange)
                            .frame(width: 20)
                        
                        TextField("Full Name", text: $name)
                            .autocapitalization(.words)
                            .focused($focusedField, equals: .name)
                            .onChange(of: name) {
                                riveController.setLookValue(val: Double(name.count))
                            }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(focusedField == .name ? Color.orange : Color.clear, lineWidth: 1)
                    )
                    
                    // Email Field
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.orange)
                            .frame(width: 20)
                        
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .focused($focusedField, equals: .email)
                            .onChange(of: email) {
                                riveController.setLookValue(val: Double(email.count))
                            }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(focusedField == .email ? Color.orange : Color.clear, lineWidth: 1)
                    )
                    
                    // Password Field
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.orange)
                            .frame(width: 20)
                        
                        SecureField("Password (min. 8 chars)", text: $password)
                            .focused($focusedField, equals: .password)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(focusedField == .password ? Color.orange : Color.clear, lineWidth: 1)
                    )
                }
                .onChange(of: focusedField) {
                    if focusedField == .password {
                        riveController.setHandUpState(flag: true)
                    } else {
                        riveController.setHandUpState(flag: false)
                    }
                    
                    // Reset looking if lost focus from text fields
                    if focusedField == nil {
                         riveController.setLookValue(val: 0)
                    }
                }
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                Button(action: handleSignup) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.orange)
                            .frame(height: 55)
                        
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Sign Up")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.top, 10)
                .disabled(isLoading || name.isEmpty || email.isEmpty || password.count < 8)
                
                Spacer()
            }
            .padding(.horizontal, 30)
            //.background(Color(UIColor.systemBackground).ignoresSafeArea())
            .navigationDestination(isPresented: $navigateToProfile) {
                if let manager = manager {
                    ProfileCardView(manager: manager)
                }
            }
            .onAppear {
                riveController.setHandUpState(flag: false)
                riveController.setLookValue(val: 0)
            }
        }
    }
    
    private func handleSignup() {
        isLoading = true
        errorMessage = ""
        focusedField = nil
        
        Task {
            do {
                let response = try await AuthService.shared.signup(email: email, password: password, name: name)
                
                // Rive Success
                await MainActor.run {
                    riveController.resolveSuccess()
                }
                try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
                
                print("Signed up and logged in: \(response.user.name)")
                loggedInUser = response.user
                manager = ProfileManager(user: response.user) // Initialize manager
                isLoading = false
                navigateToProfile = true
            } catch {
                errorMessage = error.localizedDescription
                await MainActor.run {
                    riveController.resolveFail()
                    isLoading = false
                }
            }
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var showSignup = false
    @State private var navigateToProfile = false
    @State private var loggedInUser: User?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                NavigationLink(destination: ProfileView(name: loggedInUser?.name ?? "", email: loggedInUser?.email ?? ""), isActive: $navigateToProfile) {
                    EmptyView()
                }
                Spacer()
                
                // Header
                VStack(spacing: 8) {
                    Text("Welcome Back")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("Please sign in to continue")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 30)
                
                // Input Fields
                VStack(spacing: 15) {
                    CustomTextField(placeholder: "Email", icon: "envelope", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    CustomSecureField(placeholder: "Password", icon: "lock", text: $password)
                }
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.top, 5)
                }
                
                // Login Button
                Button(action: handleLogin) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.orange)
                            .frame(height: 55)
                        
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Log In")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.top, 20)
                .disabled(isLoading || email.isEmpty || password.isEmpty)
                
                Spacer()
                
                // Footer
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.secondary)
                    
                    Button("Sign Up") {
                        showSignup = true
                    }
                    .foregroundColor(.orange)
                    .fontWeight(.bold)
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 30)
            .background(Color(UIColor.systemBackground).ignoresSafeArea())
            .sheet(isPresented: $showSignup) {
                SignupView()
            }
        }
    }
    
    private func handleLogin() {
        isLoading = true
        errorMessage = ""
        
        Task {
            do {
                let response = try await AuthService.shared.login(email: email, password: password)
                print("Logged in successfully: \(response.user.name)")
                loggedInUser = response.user
                isLoading = false
                navigateToProfile = true
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
}

// Reusable Components
struct CustomTextField: View {
    var placeholder: String
    var icon: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.orange)
                .frame(width: 20)
            
            TextField(placeholder, text: $text)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct CustomSecureField: View {
    var placeholder: String
    var icon: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.orange)
                .frame(width: 20)
            
            SecureField(placeholder, text: $text)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

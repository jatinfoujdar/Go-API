import SwiftUI
import RiveRuntime

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var showSignup = false
    
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    
    // Rive Integration
    @StateObject private var riveController = RiveController()
    
    enum FocusField {
        case email, password
    }
    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        VStack(spacing: 25) {
            
            // Rive Animation
            riveController.view()
                .frame(height: 250)
                .ignoresSafeArea(.keyboard, edges: .bottom)
            
            // Header (Condensed)
            VStack(spacing: 8) {
                Text("Welcome Back")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
            }
            
            // Input Fields
            VStack(spacing: 15) {
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
                    
                    SecureField("Password", text: $password)
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
                
                if focusedField == .email {
                    if email.isEmpty {
                        riveController.setLookValue(val: 0)
                    }
                }
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
        .sheet(isPresented: $showSignup) {
            SignupView()
        }
        .onAppear {
            // Reset states
            riveController.setHandUpState(flag: false)
            riveController.setLookValue(val: 0)
        }
    }
    
    private func handleLogin() {
        isLoading = true
        errorMessage = ""
        focusedField = nil
        
        Task {
            do {
                let response = try await AuthService.shared.login(email: email, password: password)
                
                // Rive Success
                await MainActor.run {
                    riveController.resolveSuccess()
                }
                
                // Delay for animation
                try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
                
                await MainActor.run {
                    // Update global auth state
                    authManager.login(user: response.user, token: response.token)
                    isLoading = false
                    // Dismiss the sheet
                    dismiss()
                }
            } catch {
                errorMessage = error.localizedDescription
                // Rive Fail
                await MainActor.run {
                    riveController.resolveFail()
                    isLoading = false
                }
            }
        }
    }
}

// Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthManager())
    }
}

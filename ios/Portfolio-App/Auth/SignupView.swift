import SwiftUI

struct SignupView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 25) {
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.primary)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .clipShape(Circle())
                }
                Spacer()
            }
            .padding(.top, 20)
            
            VStack(spacing: 8) {
                Text("Create Account")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("Join us to start your journey")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 20)
            
            VStack(spacing: 15) {
                CustomTextField(placeholder: "Full Name", icon: "person", text: $name)
                    .autocapitalization(.words)
                
                CustomTextField(placeholder: "Email", icon: "envelope", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                CustomSecureField(placeholder: "Password (min. 8 chars)", icon: "lock", text: $password)
            }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.top, 5)
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
            .padding(.top, 20)
            .disabled(isLoading || name.isEmpty || email.isEmpty || password.count < 8)
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .background(Color(UIColor.systemBackground).ignoresSafeArea())
    }
    
    private func handleSignup() {
        isLoading = true
        errorMessage = ""
        
        Task {
            do {
                let response = try await AuthService.shared.signup(email: email, password: password, name: name)
                print("Signed up and logged in: \(response.user.name)")
                isLoading = false
                presentationMode.wrappedValue.dismiss()
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}

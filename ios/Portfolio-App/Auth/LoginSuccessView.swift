import SwiftUI
import RiveRuntime

struct LoginSuccessView: View {
    @ObservedObject var manager: ProfileManager
    @State private var navigateToProfile = false
    @State private var treeProgress: Double = 0
    @State private var timer: Timer?
    
    // Rive Integration for the tree animation with state machine
    private let riveModel: RiveViewModel
    
    init(manager: ProfileManager) {
        self.manager = manager
        // Use the correct state machine name from the Dart code
        self.riveModel = RiveViewModel(
            fileName: Constants.treeDemoFileName,
            stateMachineName: "State Machine 1"
        )
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                riveModel.view()
                    .frame(width: 400, height: 400)
                
                Text("Login Successful!")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                Text("Growing your profile...")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.top, 8)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $navigateToProfile) {
            ProfileCardView(manager: manager)
        }
        .onAppear {
            startTreeGrowth()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func startTreeGrowth() {
        let growthDuration: Double = 3.0 // 3 seconds
        let maxProgress: Double = 100.0
        let updateInterval: Double = 0.05 // Update every 50ms for smooth animation
        let progressIncrement = maxProgress / (growthDuration / updateInterval)
        
        // Start with initial value
        riveModel.setInput("input", value: 1.0 as Double)
        
        timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { _ in
            if treeProgress >= maxProgress {
                timer?.invalidate()
                // Navigate to profile after growth completes
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    navigateToProfile = true
                }
            } else {
                treeProgress += progressIncrement
                riveModel.setInput("input", value: treeProgress as Double)
            }
        }
    }
}

#Preview {
    NavigationStack {
        LoginSuccessView(
            manager: ProfileManager(
                user: User(
                    id: "1",
                    name: "Jatin Foujdar",
                    email: "jatin@email.com",
                    avatar: nil,
                    links: nil,
                    userType: "creator"
                )
            )
        )
    }
}

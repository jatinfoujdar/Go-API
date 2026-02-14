import SwiftUI
import Combine
import RiveRuntime

struct TreeLoadingView: View {
    var onComplete: () -> Void
    
    @StateObject private var riveViewModel = RiveViewModel(fileName: Constants.treeDemoFileName)
    @State private var progress: CGFloat = 0.0
    
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // Rive Animation
            riveViewModel.view()
                .ignoresSafeArea()
            
            // Loading Overlay
            VStack {
                Spacer()
                
                VStack(spacing: 10) {
                    Text("Loading your profile...")
                        .font(.headline)
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                    
                    // Simple Custom Progress Bar
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 200, height: 6)
                        
                        Capsule()
                            .fill(Color.orange)
                            .frame(width: 200 * progress, height: 6)
                    }
                }
                .padding(.bottom, 60)
            }
        }
        .onReceive(timer) { _ in
            if progress < 1.0 {
                progress += 0.02 // Adjust speed here (approx 2.5 seconds)
                // Drive the "input" state for tree growth (0-100)
                // Assuming standard naming convention. If it doesn't work, we might need to check the .riv file.
                try? riveViewModel.setInput("input", value: Double(progress * 100))
            } else {
                timer.upstream.connect().cancel()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    onComplete()
                }
            }
        }
    }
}

#Preview {
    TreeLoadingView(onComplete: {})
}

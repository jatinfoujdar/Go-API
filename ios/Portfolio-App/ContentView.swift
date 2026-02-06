import SwiftUI

struct ContentView: View {
    
    let activities = [
        ("Projects", "square.stack.3d.up"),
        ("GitHub", "chevron.left.slash.chevron.right"),
        ("Tech Stack", "server.rack"),
        ("Open Source", "shippingbox"),
        ("Experience", "briefcase"),
        ("Resume", "doc.richtext"),
        ("Achievements", "trophy"),
        ("Certifications", "checkmark.seal"),
        ("LinkedIn", "link"),
        ("Contact", "paperplane")
    ]
    
    @State private var rotationDegrees: Double = 0
    @State private var selectedIndex: Int = 0
    
    @State private var animateBlob = false
    @State private var showLogin = false
    @State private var showSignup = false
    
    var body: some View {
        ZStack {
            
            Color.black.ignoresSafeArea()
            
            // MARK: Liquid Background
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.orange.opacity(0.55),
                            Color.orange.opacity(0.15),
                            .clear
                        ],
                        center: .center,
                        startRadius: 40,
                        endRadius: 260
                    )
                )
                .frame(width: 420, height: 420)
                .blur(radius: 80)
                .offset(x: animateBlob ? 140 : -140,
                        y: animateBlob ? -180 : 180)
                .animation(
                    .easeInOut(duration: 9)
                    .repeatForever(autoreverses: true),
                    value: animateBlob
                )
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.purple.opacity(0.45),
                            .clear
                        ],
                        center: .center,
                        startRadius: 20,
                        endRadius: 240
                    )
                )
                .frame(width: 380, height: 380)
                .blur(radius: 90)
                .offset(x: animateBlob ? -160 : 160,
                        y: animateBlob ? 200 : -200)
                .animation(
                    .easeInOut(duration: 11)
                    .repeatForever(autoreverses: true),
                    value: animateBlob
                )
            
            VStack(spacing: 40) {
                
                Text("Built With Intent")
                    .font(.title2.bold())
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(.top, 60)
                
                //--------------------------------------------------
                // Wheel
                
                ZStack {
                    
                    ZStack {
                        ForEach(Array(activities.enumerated()), id: \.offset) { index, activity in
                            
                            ActivityIcon(
                                icon: activity.1,
                                isSelected: selectedIndex == index,
                                wheelRotation: rotationDegrees
                            )
                            .offset(offset(for: index))
                        }
                    }
                    .rotationEffect(.degrees(rotationDegrees))
                    
                    GlassCapsule(title: activities[selectedIndex].0)
                }
                .frame(width: 340, height: 340)
                
                Spacer()
                
             
                //--------------------------------------------------
                // NEW: Login / Signup Buttons
                
                BottomAuthButtons(showLogin: $showLogin, showSignup: $showSignup)
                    .padding(.bottom, 40)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            animateBlob = true
        }
        .overlay {
            TimelineView(.animation) { timeline in
                
                let time = timeline.date.timeIntervalSinceReferenceDate
                
                Color.clear
                    .onChange(of: time) {
                        rotationDegrees += 0.25
                        updateSelection()
                    }
            }
        }
        .sheet(isPresented: $showLogin) {
            LoginView()
        }
        .sheet(isPresented: $showSignup) {
            SignupView()
        }
    }
}

//////////////////////////////////////////////////////////////
// MARK: Selection Math

extension ContentView {
    
    private func updateSelection() {
        
        let anglePerItem = 360.0 / Double(activities.count)
        let normalized = rotationDegrees.truncatingRemainder(dividingBy: 360)
        
        var index = Int(round(-normalized / anglePerItem)) % activities.count
        
        if index < 0 { index += activities.count }
        
        if index != selectedIndex {
            selectedIndex = index
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        }
    }
    
    private func offset(for index: Int) -> CGSize {
        
        let count = Double(activities.count)
        let angle = (Double(index) / count) * 360 - 180
        let radians = angle * .pi / 180
        
        let radius: CGFloat = 150
        
        return CGSize(
            width: CGFloat(cos(radians)) * radius,
            height: CGFloat(sin(radians)) * radius
        )
    }
}

//////////////////////////////////////////////////////////////
// MARK: Bottom Buttons

struct BottomAuthButtons: View {
    @Binding var showLogin: Bool
    @Binding var showSignup: Bool
    
    var body: some View {
        
        HStack(spacing: 16) {
            
            // Login
            
            Button {
                showLogin = true
            } label: {
                Text("Login")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.white.opacity(0.2))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            
            
            // Sign Up
            
            Button {
                showSignup = true
            } label: {
                Text("Sign Up")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        LinearGradient(
                            colors: [
                                Color.orange,
                                Color.orange.opacity(0.7)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(color: .orange.opacity(0.6),
                            radius: 18,
                            y: 8)
            }
        }
        .padding(.horizontal, 24)
    }
}

//////////////////////////////////////////////////////////////
// MARK: Glass Capsule

struct GlassCapsule: View {
    
    let title: String
    
    var body: some View {
        
        ZStack {
            
            Capsule().fill(.ultraThinMaterial)
            Capsule().fill(Color.white.opacity(0.06))
            
            Capsule()
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.8),
                            Color.white.opacity(0.08)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
            
            Text(title)
                .font(.headline)
                .foregroundStyle(.white)
                .padding(.horizontal, 18)
                .id(title)
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity),
                        removal: .move(edge: .bottom).combined(with: .opacity)
                    )
                )
                .animation(
                    .spring(response: 0.55, dampingFraction: 0.88),
                    value: title
                )
        }
        .frame(width: 190, height: 60)
        .shadow(color: .black.opacity(0.6), radius: 30, y: 20)
    }
}

//////////////////////////////////////////////////////////////
// MARK: Icon

struct ActivityIcon: View {
    
    let icon: String
    let isSelected: Bool
    let wheelRotation: Double
    
    var body: some View {
        
        ZStack {
            Circle()
                .fill(isSelected ? Color.orange : Color.white.opacity(0.05))
                .frame(width: 66, height: 66)
            
            Circle()
                .stroke(Color.white.opacity(0.12))
                .frame(width: 66, height: 66)
            
            Image(systemName: icon)
                .font(.system(size: 26, weight: .medium))
                .foregroundStyle(.white)
        }
        .scaleEffect(isSelected ? 1.3 : 1)
        .shadow(color: isSelected ? .orange.opacity(0.8) : .clear,
                radius: 20)
        .rotationEffect(.degrees(-wheelRotation))
        .animation(.spring(response: 0.35,
                           dampingFraction: 0.7),
                   value: isSelected)
    }
}

//////////////////////////////////////////////////////////////

#Preview {
    ContentView()
}

import SwiftUI

struct ActivitySelectionView: View {
    
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
    
    var body: some View {
        ZStack {
            
            ////////////////////////////////////////////////////////////
            // MARK: Cinematic Dark Background
            
            RadialGradient(
                colors: [
                    Color.orange.opacity(0.30),
                    Color.black.opacity(0.95),
                    Color.black
                ],
                center: .center,
                startRadius: 60,
                endRadius: 500
            )
            .ignoresSafeArea()
            
            
            VStack(spacing: 40) {
                
                Text("What Activity you like to play?")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .padding(.top, 60)
                
                
                ////////////////////////////////////////////////////////////
                // MARK: Wheel
                    
                ZStack {
                    
                    //--------------------------------------------------
                    // Rotating Layer ONLY
                    
                    ZStack {
                        
                        Circle()
                            .stroke(.white.opacity(0.08), lineWidth: 1)
                            .frame(width: 300, height: 300)
                        
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

                    
                    //--------------------------------------------------
                    // MARK: Premium Glass Capsule
                    
                    GlassCapsule(title: activities[selectedIndex].0)
                }
                .frame(width: 340, height: 340)
                
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
        
        
        ////////////////////////////////////////////////////////////
        // MARK: Apple-Style Animation Engine (No Timer)
        
        .overlay {
            TimelineView(.animation) { timeline in
                
                let time = timeline.date.timeIntervalSinceReferenceDate
                
                Color.clear
                    .onChange(of: time) {
                        
                        rotationDegrees += 0.22   // slow premium speed
                        updateSelection()
                    }
            }
        }
    }
}

//////////////////////////////////////////////////////////////
// MARK: Selection Math

extension ActivitySelectionView {
    
    private func updateSelection() {
        
        let anglePerItem = 360.0 / Double(activities.count)
        
        let normalized =
        rotationDegrees.truncatingRemainder(dividingBy: 360)
        
        var index = Int(
            round(-normalized / anglePerItem)
        ) % activities.count
        
        if index < 0 { index += activities.count }
        
        if index != selectedIndex {
            selectedIndex = index
            
            UIImpactFeedbackGenerator(style: .soft)
                .impactOccurred()
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
// MARK: Glass Capsule (REAL Glass)

struct GlassCapsule: View {
    
    let title: String
    
    var body: some View {
        
        ZStack {
            
            // TRUE blur
            Capsule()
                .fill(.ultraThinMaterial)
            
            // soft tint
            Capsule()
                .fill(Color.white.opacity(0.05))
            
            // light reflection
            Capsule()
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.7),
                            Color.white.opacity(0.05)
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
        }
        .frame(width: 180, height: 58)
        .shadow(color: .black.opacity(0.45), radius: 25, y: 12)
        .shadow(color: .white.opacity(0.05), radius: 6)
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
                .fill(
                    isSelected ?
                    Color.orange :
                    Color.white.opacity(0.04)
                )
                .frame(width: 66, height: 66)
            
            Circle()
                .stroke(Color.white.opacity(0.15))
                .frame(width: 66, height: 66)
            
            Image(systemName: icon)
                .font(.system(size: 26, weight: .medium))
                .foregroundStyle(.white)
        }
        .scaleEffect(isSelected ? 1.25 : 1)
        .shadow(color: isSelected ? .orange.opacity(0.7) : .clear,
                radius: 18)
        
        // Keeps icons upright
        .rotationEffect(.degrees(-wheelRotation))
        .animation(.spring(response: 0.35,
                           dampingFraction: 0.7),
                   value: isSelected)
    }
}

//////////////////////////////////////////////////////////////

#Preview {
    ActivitySelectionView()
}

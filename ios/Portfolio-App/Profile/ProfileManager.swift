import SwiftUI
import Combine

class ProfileManager: ObservableObject {
    @Published var user: User
    
    init(user: User) {
        self.user = user
    }
}

//
//  RiveController.swift
//  Portfolio-App
//

import SwiftUI
import Combine
import RiveRuntime

/// Controller wraps a RiveViewModel using composition (not inheritance)
/// to avoid Swift strict concurrency actor-isolation conflicts.
class RiveController: ObservableObject {
    
    let riveModel: RiveViewModel
    
    init() {
        self.riveModel = RiveViewModel(
            fileName: Constants.riveFileName,
            stateMachineName: Constants.stateMachine
        )
    }
    
    /// Returns the SwiftUI view for embedding in your layout
    func view() -> some View {
        riveModel.view()
    }
    
    // MARK: - Animation Triggers
    
    func resolveSuccess() {
        riveModel.triggerInput(Constants.successAnimation)
    }
    
    func resolveFail() {
        riveModel.triggerInput(Constants.failAnimation)
    }
    
    func setLookValue(val: Double) {
        riveModel.setInput(Constants.lookAnimation, value: val)
        riveModel.setInput(Constants.checkAnimation, value: val > 0)
    }
    
    func setHandUpState(flag: Bool) {
        riveModel.setInput(Constants.handsupAnimation, value: flag)
    }
}

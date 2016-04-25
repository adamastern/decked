//
//  DecorationManager.swift
//  pinch
//
//  Created by Adam Stern on 21/04/2016.
//  Copyright © 2016 TurboPython. All rights reserved.
//

import UIKit

public class DecorationManager {
    
    weak public var decoration: ManagedDecoration?
    public var presented = false
    internal let dismissAfter: NSTimeInterval
    private let onDismiss: (manager: DecorationManager, animated: Bool) -> Void
    private var dismissalTimer: NSTimer?
    
    internal init(decoration: ManagedDecoration, dismissAfter: NSTimeInterval, onDismiss: (manager: DecorationManager, animated: Bool) -> Void) {
        self.decoration = decoration
        self.onDismiss = onDismiss
        self.dismissAfter = dismissAfter
    }
    
    deinit {
        cancelDismissalTimer()
    }
    
    public func dismiss(animated: Bool) {
        onDismiss(manager: self, animated: animated)
    }
    
    // MARK - lifecycle
    
    internal func decorationDidAppear() {
        self.presented = true
        if dismissAfter > 0 {
            startDismissalTimer()
        }
    }
    
    internal func decorationWillDisappear() {
        cancelDismissalTimer()
    }
    
    // MARK - dismissal timer
    
    private func startDismissalTimer() {
        cancelDismissalTimer()
        dismissalTimer = NSTimer.scheduledTimerWithTimeInterval(dismissAfter, target: self, selector: #selector(dismissalTimerFired), userInfo: nil, repeats: false)
    }
    
    private func cancelDismissalTimer() {
        if dismissalTimer != nil && dismissalTimer?.valid == true {
            dismissalTimer!.invalidate()
            dismissalTimer = nil
        }
    }
    
    @objc private func dismissalTimerFired() {
        dismiss(true)
    }
    
}
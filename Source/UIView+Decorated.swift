//
//  UIView+Decorated.swift
//  pinch
//
//  Created by Adam Stern on 19/04/2016.
//  Copyright © 2016 TurboPython. All rights reserved.
//

import UIKit

private struct DecoratedViewAssociatedKeys {
    static var DecorationViews = "DecorationViews"
    static var LayoutChangeNotifyView = "LayoutChangeNotifyView"
}

internal struct DecorationContainer {
    let decoration: Decoration
    let position: DecorationPosition?
    let queue: DecorationQueue?
    let insets: UIEdgeInsets
}

extension UIView: Decorated{
    
    internal var decorationContainers: [DecorationContainer]? {
        get {
            return getAssociatedObject(self, associativeKey: &DecoratedViewAssociatedKeys.DecorationViews);
        }
        set {
            if let newVal = newValue as [DecorationContainer]!{
                setAssociatedObject(self, value: newVal, associativeKey: &DecoratedViewAssociatedKeys.DecorationViews, policy: objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
    }
    
    internal var layoutChangeNotifyView: LayoutNotificationView? {
        get {
            return getAssociatedObject(self, associativeKey: &DecoratedViewAssociatedKeys.LayoutChangeNotifyView);
        }
        set {
            if let newVal = newValue as LayoutNotificationView!{
                setAssociatedObject(self, value: newVal, associativeKey: &DecoratedViewAssociatedKeys.LayoutChangeNotifyView, policy: objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
    }
    
    public var decorations: [Decoration]? {
        get {
            if let arr = decorationContainers {
                return arr.map{$0.decoration}
            }
            return []
        }
    }
    
    public func addDecoration(decoration: Decoration, atPosition position: DecorationPosition, insets: UIEdgeInsets) {
        self.setupIfNeeded()
        let existingContainer = self.decorationContainers!.filter{$0.position != nil && $0.position == .Center}.first
        if let existingContainer = existingContainer {
            removeDecoration(existingContainer.decoration)
        }
        let container = DecorationContainer(decoration: decoration, position: position, queue: nil, insets: insets)
        self.decorationContainers!.append(container)
        let view = decoration.decorationView()
        self.addSubview(view)
        layoutDecorations()
    }
    
    public func addDecoration(decoration: Decoration, atPosition position: DecorationPosition){
        self.addDecoration(decoration, atPosition: position, insets: UIEdgeInsetsZero)
    }
    
    public func removeDecoration(decoration: Decoration){
        if let decorations = decorations {
            let idx = decorations.indexOf{$0 === decoration}
            if let idx = idx {
                self.decorationContainers!.removeAtIndex(idx)
                let view = decoration.decorationView()
                view.removeFromSuperview()
            }
        }
    }
    
    public func removeDecorationAtPosition(position: DecorationPosition) {
        if let containers = decorationContainers {
            let container = containers.filter{$0.position == position}.first
            if let container = container {
                self.removeDecoration(container.decoration)
            }
        }
    }
    
    public func layoutDecorations() {
        if let containers = decorationContainers {
            for container in containers {
                let insets = container.insets
                let view = container.decoration.decorationView()
                let viewSize = view.sizeThatFits(self.bounds.size)
                
                let position = container.position
                let queue = container.queue
                
                var bounds: CGRect = CGRectZero
                var center: CGPoint = CGPointZero
                
                if let _ = queue {
                    
                    switch queue! {
                    case .Top:
                        bounds = CGRectMake(0, 0, viewSize.width, viewSize.height)
                        center = CGPointMake(self.bounds.size.width / 2, (insets.top + (viewSize.height / 2)) - insets.bottom)
                        break;
                    case .Bottom:
                        bounds = CGRectMake(0, 0, viewSize.width, viewSize.height)
                        center = CGPointMake(self.bounds.size.width / 2, (insets.top + self.bounds.size.height) - ((viewSize.height / 2) + insets.bottom))
                        break;
                    }
                    
                } else {
                    
                    switch position! {
                    case .Top:
                        bounds = CGRectMake(0, 0, viewSize.width, viewSize.height)
                        center = CGPointMake(self.bounds.size.width / 2, (insets.top + (viewSize.height / 2)) - insets.bottom)
                        break;
                    case .Center:
                        bounds = CGRectMake(0, 0, viewSize.width, viewSize.height)
                        center = CGPointMake(self.bounds.size.width / 2, (insets.top + (self.bounds.size.height / 2)) - insets.bottom)
                        break;
                    case .Bottom:
                        bounds = CGRectMake(0, 0, viewSize.width, viewSize.height)
                        center = CGPointMake(self.bounds.size.width / 2, (self.bounds.size.height + insets.top) - ((viewSize.height / 2) + insets.bottom))
                        break;
                    }
                    
                }
                
                view.bounds = bounds
                view.center = center
                
            }
        }
    }
    
    public func queueDecoration(decoration: ManagedDecoration, inQueue queue: DecorationQueue, insets: UIEdgeInsets) -> DecorationManager{
        return self.queueDecoration(decoration, inQueue: queue, insets: insets, dismissAfter: 0)
    }
    
    public func queueDecoration(decoration: ManagedDecoration, inQueue queue: DecorationQueue, insets: UIEdgeInsets, dismissAfter: NSTimeInterval) -> DecorationManager{
        self.setupIfNeeded()
        let manager = DecorationManager(decoration: decoration, dismissAfter: dismissAfter) { [weak self] (manager: DecorationManager, animated: Bool) in
            self?.dismissDecoration(manager.decoration!)
        }
        decoration.manager = manager
        let container = DecorationContainer(decoration: decoration, position: nil, queue: queue, insets: insets)
        self.decorationContainers!.append(container)
        progressDecorationQueueIfNeeded(queue)
        return manager
    }
    
    public func dismissDecoration(decoration: ManagedDecoration) {
        if let containers = decorationContainers {
            let container = containers.filter{$0.decoration === decoration}.first
            if let container = container, let queue = container.queue, let manager = decoration.manager {
                manager.decorationWillDisappear()
                let animatedManager = decoration.decorationAnimationManager()
                animatedManager.decorationWillDisappear(decoration, inQueue: queue, completion: { [weak self] in
                    self?.removeDecoration(decoration)
                    self?.progressDecorationQueueIfNeeded(queue)
                    })
            }
        }
    }
    
    private func setupIfNeeded() {
        if self.decorationContainers == nil {
            self.decorationContainers = []
            self.layoutChangeNotifyView = LayoutNotificationView(frame: CGRectMake(-9999,-9999,1,1), layoutChangeHandler: { [weak self] (change: LayoutNotificationViewChange) in
                self?.layoutDecorations()
                }, subviewChangeHandler: { [weak self] in
                    if let _ = self {
                        for view in (self!.decorationContainers!.filter{$0.position != nil}.map{$0.decoration.decorationView()}) {
                            self?.bringSubviewToFront(view)
                        }
                        for view in (self!.decorationContainers!.filter{$0.queue != nil && ($0.decoration as! ManagedDecoration).manager?.presented == true}.map{$0.decoration.decorationView()}) {
                            self?.bringSubviewToFront(view)
                        }
                    }
                })
            self.layoutChangeNotifyView!.hidden = true
            self.addSubview(self.layoutChangeNotifyView!)
        }
    }
    
    private func progressDecorationQueueIfNeeded(queue: DecorationQueue) {
        if let containers = decorationContainers {
            let container = containers.filter{$0.queue == queue}.first
            if let container = container, let decoration = container.decoration as? ManagedDecoration, let manager = (container.decoration as! ManagedDecoration).manager {
                if !manager.presented {
                    layoutDecorations()
                    let view = decoration.decorationView()
                    let animatedManager = decoration.decorationAnimationManager()
                    animatedManager.decorationWillAppear(decoration, inQueue: container.queue!)
                    self.addSubview(view)
                    animatedManager.decorationDidAppear(decoration, inQueue: container.queue!)
                    manager.decorationDidAppear()
                }
            }
        }
    }
    
}

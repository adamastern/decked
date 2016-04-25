//
//  Decorated.swift
//  pinch
//
//  Created by Adam Stern on 19/04/2016.
//  Copyright © 2016 TurboPython. All rights reserved.
//

import UIKit

@objc public enum DecorationQueue: Int {
    case Top
    case Bottom
}

public protocol Decorated: class {
    
    var decorations: [Decoration]? {get}
    
    func addDecoration(decoration: Decoration, atPosition position: DecorationPosition)
    
    func addDecoration(decoration: Decoration, atPosition position: DecorationPosition, insets: UIEdgeInsets)
    
    func removeDecoration(decoration: Decoration)
    
    func removeDecorationAtPosition(position: DecorationPosition)
    
    func queueDecoration(decoration: ManagedDecoration, inQueue queue: DecorationQueue, insets: UIEdgeInsets) -> DecorationManager
    
    func queueDecoration(decoration: ManagedDecoration, inQueue queue: DecorationQueue, insets: UIEdgeInsets, dismissAfter: NSTimeInterval) -> DecorationManager
    
    func dismissDecoration(decoration: ManagedDecoration)
    
    func layoutDecorations()

}

public protocol ManagedDecorated: class {
    associatedtype StateType
    func configureDecorationsForState(state: StateType) -> (top: Decoration?, center: Decoration?, bottom: Decoration?)
    func setDecorationState(state: StateType)
}

extension ManagedDecorated where Self: UIViewController{
    func setDecorationState(state: StateType){
        let states = self.configureDecorationsForState(state)
        if let top = states.top {
            self.view.addDecoration(top, atPosition: .Top)
        } else {
            self.view.removeDecorationAtPosition(.Top)
        }
        
        if let center = states.center {
            self.view.addDecoration(center, atPosition: .Center)
        } else {
            self.view.removeDecorationAtPosition(.Center)
        }
        
        if let bottom = states.bottom {
            self.view.addDecoration(bottom, atPosition: .Bottom)
        } else {
            self.view.removeDecorationAtPosition(.Bottom)
        }
    }
}
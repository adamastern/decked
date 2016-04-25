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
//
//  DecoratedStateProvider.swift
//  Decked
//
//  Created by Adam Stern on 25/04/2016.
//  Copyright © 2016 decked. All rights reserved.
//

import UIKit


public protocol DecoratedStateProvider: class {
    
    associatedtype StateType
    
    func providesForDecorated() -> Decorated
    
    func configureDecorationsForState(state: StateType) -> (top: Decoration?, center: Decoration?, bottom: Decoration?)
    
    func setDecorationState(state: StateType)
    
}

extension DecoratedStateProvider{
    
    public func setDecorationState(state: StateType){
        let states = self.configureDecorationsForState(state)
        let decorated = self.providesForDecorated()
        if let top = states.top {
            decorated.addDecoration(top, atPosition: .Top)
        } else {
            decorated.removeDecorationAtPosition(.Top)
        }
        
        if let center = states.center {
            decorated.addDecoration(center, atPosition: .Center)
        } else {
            decorated.removeDecorationAtPosition(.Center)
        }
        
        if let bottom = states.bottom {
            decorated.addDecoration(bottom, atPosition: .Bottom)
        } else {
            decorated.removeDecorationAtPosition(.Bottom)
        }
    }
    
}

extension DecoratedStateProvider where Self: Decorated {
    
    public func providesForDecorated() -> Decorated {
        return self
    }
    
}
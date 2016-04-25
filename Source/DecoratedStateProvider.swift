//
//  DecoratedStateProvider.swift
//  Decked
//
//  Created by Adam Stern on 25/04/2016.
//  Copyright © 2016 decked. All rights reserved.
//

import UIKit

public struct DecorationStateProviderInfoKeys{
    public static let Error = "DecorationStateProviderInfoError"
}

public protocol DecoratedStateProvider: class {
    
    associatedtype StateType
    
    func providesForDecorated() -> Decorated
    
    func configureDecorationsForState(state: StateType, info: [String : Any]?) -> (top: DecorationConfiguration?, center: DecorationConfiguration?, bottom: DecorationConfiguration?)
    
    func setDecorationState(state: StateType, info: [String : Any]?)
    
}

extension DecoratedStateProvider{
    
    public func setDecorationState(state: StateType, info: [String : Any]?){
        let states = self.configureDecorationsForState(state, info: info)
        let decorated = self.providesForDecorated()
        if let top = states.top {
            decorated.addDecoration(top.decoration, atPosition: .Top, insets: top.insets)
        } else {
            decorated.removeDecorationAtPosition(.Top)
        }
        
        if let center = states.center {
            decorated.addDecoration(center.decoration, atPosition: .Center, insets: center.insets)
        } else {
            decorated.removeDecorationAtPosition(.Center)
        }
        
        if let bottom = states.bottom {
            decorated.addDecoration(bottom.decoration, atPosition: .Bottom, insets: bottom.insets)
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
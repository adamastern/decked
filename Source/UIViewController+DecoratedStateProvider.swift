//
//  UIViewController+DecoratedStateProvider.swift
//  Decked
//
//  Created by Adam Stern on 25/04/2016.
//  Copyright © 2016 decked. All rights reserved.
//

import UIKit

extension DecoratedStateProvider where Self: UIViewController{
    
    public func providesForDecorated() -> Decorated {
        return self.view
    }
    
}
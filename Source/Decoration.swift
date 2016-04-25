//
//  Decoration.swift
//  pinch
//
//  Created by Adam Stern on 19/04/2016.
//  Copyright © 2016 TurboPython. All rights reserved.
//

import UIKit

@objc public enum DecorationPosition: Int{
    case Center
    case Top
    case Bottom
}

@objc public protocol Decoration: class {
    
    func decorationView() -> UIView
    
}
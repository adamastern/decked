//
//  ManagedDecoration.swift
//  pinch
//
//  Created by Adam Stern on 23/04/2016.
//  Copyright © 2016 TurboPython. All rights reserved.
//

import UIKit

public protocol ManagedDecoration: Decoration {
    
    var manager: DecorationManager? {get set}
    
    func decorationAnimationManager() -> DecorationAnimationManager
    
}
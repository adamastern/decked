//
//  DecorationAnimationManager.swift
//  pinch
//
//  Created by Adam Stern on 21/04/2016.
//  Copyright © 2016 TurboPython. All rights reserved.
//

import UIKit

public protocol DecorationAnimationManager {

    //enter
    func decorationWillAppear(decoration: ManagedDecoration, inQueue queue: DecorationQueue)
    func decorationDidAppear(decoration: ManagedDecoration, inQueue queue: DecorationQueue)
    
    //exit
    func decorationWillDisappear(decoration: ManagedDecoration, inQueue queue: DecorationQueue, completion: () -> Void)
    
}



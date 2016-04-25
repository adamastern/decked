//
//  DecorationConfiguration.swift
//  Decked
//
//  Created by Adam Stern on 25/04/2016.
//  Copyright © 2016 decked. All rights reserved.
//

import UIKit

public struct DecorationConfiguration{
    
    public let decoration: Decoration
    
    public let insets: UIEdgeInsets
    
    public init(decoration: Decoration, insets: UIEdgeInsets){
        self.decoration = decoration
        self.insets = insets
    }
    
}
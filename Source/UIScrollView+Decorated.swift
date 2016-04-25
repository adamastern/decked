//
//  UIScrollView+Decorated.swift
//  pinch
//
//  Created by Adam Stern on 22/04/2016.
//  Copyright © 2016 TurboPython. All rights reserved.
//

import UIKit

public extension UIScrollView {
    
    public override func addDecoration(decoration: Decoration, atPosition position: DecorationPosition, insets: UIEdgeInsets) {
        super.addDecoration(decoration, atPosition: position, insets: insets)
        if position == .Top {
            let view = decoration.decorationView()
            let viewSize = view.sizeThatFits(self.bounds.size)
            self.contentInset.top += viewSize.height + insets.top + insets.bottom
        } else if position == .Bottom {
            let view = decoration.decorationView()
            let viewSize = view.sizeThatFits(self.bounds.size)
            self.contentInset.bottom += viewSize.height + insets.top + insets.bottom
        }
    }
    
    public override func removeDecoration(decoration: Decoration) {
        if let decorationContainers = decorationContainers {
            let container = decorationContainers.filter{$0.decoration === decoration}.first
            if let container = container, let position = container.position {
                if position == .Top {
                    let view = decoration.decorationView()
                    let viewSize = view.sizeThatFits(self.bounds.size)
                    self.contentInset.top -= (viewSize.height + container.insets.top + container.insets.bottom)
                } else if position == .Bottom {
                    let view = decoration.decorationView()
                    let viewSize = view.sizeThatFits(self.bounds.size)
                    self.contentInset.bottom -= (viewSize.height + container.insets.top + container.insets.bottom)
                }
            }
        }
        super.removeDecoration(decoration)
    }
    
    override func layoutDecorations() {
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
                        center = CGPointMake(self.bounds.size.width / 2, (self.contentOffset.y + insets.top + (viewSize.height / 2)) - insets.bottom)
                        break;
                    case .Bottom:
                        bounds = CGRectMake(0, 0, viewSize.width, viewSize.height)
                        center = CGPointMake(self.bounds.size.width / 2, (self.contentOffset.y + insets.top + self.bounds.size.height) - ((viewSize.height / 2) + insets.bottom))
                        break;
                    }
                    
                } else {
                    
                    switch position! {
                    case .Top:
                        bounds = CGRectMake(0, 0, viewSize.width, viewSize.height)
                        center = CGPointMake(self.bounds.size.width / 2, -((viewSize.height / 2) + insets.bottom))
                        break;
                    case .Center:
                        bounds = CGRectMake(0, 0, viewSize.width, viewSize.height)
                        center = CGPointMake(self.bounds.size.width / 2, (self.contentOffset.y + insets.top + (self.bounds.size.height / 2)) - insets.bottom)
                        break;
                    case .Bottom:
                        bounds = CGRectMake(0, 0, viewSize.width, viewSize.height)
                        center = CGPointMake(self.bounds.size.width / 2, contentSize.height + insets.top + (viewSize.height / 2))
                        break;
                    }
                    
                }
                
                view.bounds = bounds
                view.center = center
                
            }
        }
    }
}
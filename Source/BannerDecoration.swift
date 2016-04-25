//
//  BannerDecoration.swift
//  pinch
//
//  Created by Adam Stern on 19/04/2016.
//  Copyright © 2016 TurboPython. All rights reserved.
//

import UIKit


public enum BannerNotificationStyle{
    case Success
    case Neutral
    case Warning
    case Error
}

public class BannerDecoration: UIView, ManagedDecoration, DecorationAnimationManager {
    
    public var manager: DecorationManager?
    
    public var style: BannerNotificationStyle!{
        didSet{
            configureForStyle()
        }
    }
    
    public var title: String?{
        didSet{
            label.text = title
            layoutSubviews()
        }
    }
    
    public var font: UIFont?{
        didSet{
            label.font = font
            layoutSubviews()
        }
    }
    
    private let dismissButton = UIButton(type: .System)
    private let label = UILabel()
    private var tapHandler: (() -> Bool)?
    
    public init(style: BannerNotificationStyle, title: String, onTap:(() -> Bool)?){
        
        tapHandler = onTap
        
        super.init(frame: CGRectZero)
        
        label.textAlignment = .Center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        addSubview(label)
        
        addSubview(dismissButton)
        dismissButton.setImage(UIImage.cross(CGSizeMake(12, 12)), forState: .Normal)
        dismissButton.addTarget(self, action: #selector(dismissButtonPressed), forControlEvents: .TouchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
        
        self.setupInitialStyles(style, title: title)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInitialStyles(style: BannerNotificationStyle, title: String){
        self.style = style
        self.title = title
        self.font = UIFont.systemFontOfSize(13)
    }
    
    // MARK - layout
    
    override public func sizeThatFits(size: CGSize) -> CGSize {
        return CGSizeMake(size.width, 34)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        let horizontalInset: CGFloat = 44
        let labelWidth = bounds.size.width - (horizontalInset * 2)
        label.bounds = CGRectMake(0, 0, labelWidth, bounds.size.height)
        label.center = CGPointMake(bounds.size.width/2, bounds.size.height/2)
        
        dismissButton.bounds = CGRectMake(0, 0, horizontalInset, bounds.size.height)
        dismissButton.center = CGPointMake(bounds.size.width - (horizontalInset / 2), bounds.size.height/2)
    }
    
    private func configureForStyle() {
        
        var backgroundColor: UIColor
        var tintColor: UIColor
        
        switch style!{
        case .Success:
            backgroundColor = UIColor(red:0.20, green:0.62, blue:0.48, alpha:1.00)
            tintColor = UIColor.whiteColor()
            break;
        case .Neutral:
            backgroundColor = UIColor(red:0.24, green:0.24, blue:0.24, alpha:1.00)
            tintColor = UIColor.whiteColor()
            break;
        case .Warning:
            backgroundColor = UIColor(red:0.90, green:0.64, blue:0.00, alpha:1.00)
            tintColor = UIColor.whiteColor()
            break;
        case .Error:
            backgroundColor = UIColor(red:0.66, green:0.02, blue:0.07, alpha:1.00)
            tintColor = UIColor.whiteColor()
            break;
            
        }
        
        self.backgroundColor = backgroundColor
        label.textColor = tintColor
        dismissButton.tintColor = tintColor
        
    }
    
    // MARK - interaction
    
    @objc private func dismissButtonPressed() {
        self.manager?.dismiss(true)
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer){
        if let handler = self.tapHandler {
            if handler() {
                self.manager?.dismiss(true)
            }
            
        }
    }
    
    // MARK - decoration
    
    public override func decorationView() -> UIView {
        return self
    }
    
    public func decorationAnimationManager() -> DecorationAnimationManager {
        return self
    }
    
    public func decorationWillAppear(decoration: ManagedDecoration, inQueue queue: DecorationQueue) {
        if queue == .Top {
            self.transform = CGAffineTransformMakeTranslation(0, -self.frame.size.height)
        } else if queue == .Bottom {
            self.transform = CGAffineTransformMakeTranslation(0, self.frame.size.height)
        }
    }
    
    public func decorationDidAppear(decoration: ManagedDecoration, inQueue queue: DecorationQueue) {
        UIView.animateWithDuration(0.15, delay: 0, options: .CurveEaseOut, animations: {
            self.transform = CGAffineTransformIdentity
        }) { (finished) in
            
        }
    }
    
    public func decorationWillDisappear(decoration: ManagedDecoration, inQueue queue: DecorationQueue, completion: () -> Void) {
        UIView.animateWithDuration(0.15, delay: 0, options: .CurveEaseOut, animations: {
            if queue == .Top {
                self.transform = CGAffineTransformMakeTranslation(0, -self.frame.size.height)
            } else if queue == .Bottom {
                self.transform = CGAffineTransformMakeTranslation(0, self.frame.size.height)
            }
        }) { (finished) in
            completion()
        }
    }
    
}

private extension UIImage {
    
    class func cross(size: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSaveGState(ctx)
        
        CGContextSetStrokeColorWithColor(ctx, UIColor.whiteColor().CGColor)
        CGContextSetLineWidth(ctx, 2.0)
        CGContextSetLineCap(ctx, .Butt)
        
        CGContextMoveToPoint(ctx, 0, 0)
        CGContextAddLineToPoint(ctx, size.width, size.height)
        CGContextMoveToPoint(ctx, size.width, 0)
        CGContextAddLineToPoint(ctx, 0, size.height)
        CGContextStrokePath(ctx)
        
        
        CGContextRestoreGState(ctx)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img
        
    }
    
}

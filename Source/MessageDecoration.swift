//
//  MessageDecoration.swift
//  Decked
//
//  Created by Adam Stern on 25/04/2016.
//  Copyright © 2016 decked. All rights reserved.
//

import UIKit

public class MessageDecoration: UIView {
    
    override public class func initialize(){
        MessageDecoration.appearance().buttonColor = UIButton().tintColor
        MessageDecoration.appearance().buttonFont = UIFont.systemFontOfSize(13)
        MessageDecoration.appearance().messageTextColor = UIColor.darkGrayColor()
        MessageDecoration.appearance().messageFont = UIFont.systemFontOfSize(15)
    }
    
    private let imageView = UIImageView()
    private let messageLabel = UILabel()
    private let button = UIButton(type: .System)
    private var buttonTapHandler: (() -> ())?
    
    public dynamic var buttonColor: UIColor! {
        didSet {
            self.button.setTitleColor(buttonColor, forState: .Normal)
            self.button.layer.borderColor = buttonColor.CGColor
        }
    }
    
    public dynamic var buttonFont: UIFont!{
        didSet {
            self.button.titleLabel?.font = buttonFont
            layoutSubviews()
        }
    }
    
    public dynamic var messageTextColor: UIColor!{
        didSet {
            self.messageLabel.textColor = messageTextColor
        }
    }
    
    public dynamic var messageFont: UIFont!{
        didSet {
            self.messageLabel.font = messageFont
            layoutSubviews()
        }
    }
    
    public init(image: UIImage?, message: String, buttonTitle: String, buttonTapHandler: (() -> ())?) {
        super.init(frame: CGRectZero)
        
        self.buttonTapHandler = buttonTapHandler
        
        addSubview(imageView)
        addSubview(messageLabel)
        addSubview(button)
    
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 28, 0, 28)
        button.layer.borderWidth = 1
        button.setTitle(buttonTitle, forState: .Normal)
        button.addTarget(self, action: #selector(buttonTapped(_:)), forControlEvents: .TouchUpInside)
        
        messageLabel.textAlignment = .Center
        messageLabel.numberOfLines = 0
        messageLabel.text = message
        
        imageView.image = image ?? UIImage.standardMessageIcon(CGSizeMake(80, 80))
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func sizeThatFits(size: CGSize) -> CGSize {
        return calculateSizeThatFits(size, applyLayout: false)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        calculateSizeThatFits(bounds.size, applyLayout: true)
    }
    
    private func calculateSizeThatFits(size: CGSize, applyLayout: Bool) -> CGSize{
        
        let insets = UIEdgeInsetsMake(0, size.width / 6, 0, size.width / 6)
        let maxWidth = size.width - (insets.left + insets.right)
        let buttonHeight: CGFloat = 32
        let padding: CGFloat = 20
        
        var remainingHeight = size.height - (buttonHeight + padding)
        let imageSize = imageView.sizeThatFits(CGSizeMake(maxWidth, remainingHeight))
        remainingHeight -= imageSize.height + padding
        let titleSize = messageLabel.sizeThatFits(CGSizeMake(maxWidth, remainingHeight))
        let totalHeight = imageSize.height + padding + titleSize.height + padding + buttonHeight
        
        if applyLayout {
            
            var yPosition: CGFloat = (size.height - totalHeight) / 2
            imageView.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height)
            imageView.center = CGPointMake(size.width / 2, yPosition + (imageSize.height / 2))
            
            yPosition += padding + imageSize.height
            messageLabel.bounds = CGRectMake(0, 0, titleSize.width, titleSize.height)
            messageLabel.center = CGPointMake(size.width / 2, yPosition + (titleSize.height / 2))
            
            yPosition += padding + titleSize.height
            button.sizeToFit()
            button.bounds = CGRectMake(0, 0, min(button.bounds.size.width, maxWidth), buttonHeight)
            button.center = CGPointMake(size.width / 2, yPosition + (buttonHeight/2))
            button.layer.cornerRadius = 6
        }
        
        return CGSizeMake(size.width, totalHeight)
        
    }
    
    @objc private func buttonTapped(sender: AnyObject) {
        if let tapHandler = self.buttonTapHandler {
            tapHandler()
        }
    }
    
}

private extension UIImage {
    
    class func standardMessageIcon(size: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSaveGState(ctx)
        
        CGContextSetStrokeColorWithColor(ctx, UIColor.lightGrayColor().CGColor)
        CGContextSetLineWidth(ctx, 4.0)
        CGContextSetLineCap(ctx, .Round)
        
        let inset = size.width * 0.33
        CGContextMoveToPoint(ctx, inset, inset)
        CGContextAddLineToPoint(ctx, size.width - inset, size.height - inset)
        CGContextMoveToPoint(ctx, size.width - inset , inset)
        CGContextAddLineToPoint(ctx, inset, size.height - inset)
        CGContextStrokePath(ctx)
        
        CGContextAddArc(ctx,
                        size.width/2, size.height/2,
                        (size.width - 8) / 2,
                        0,
                        6.28319,
                        1)
        CGContextStrokePath(ctx)
        
        
        CGContextRestoreGState(ctx)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img
        
    }
    
}

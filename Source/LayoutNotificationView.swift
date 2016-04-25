//
//  UILayoutNotifyView.swift
//  pinch
//
//  Created by Adam Stern on 19/04/2016.
//  Copyright © 2016 TurboPython. All rights reserved.
//

import UIKit

private struct LayoutNotificationViewKVOKeys{
    static let ContentInset = "contentInset"
    static let ContentOffset = "contentOffset"
    static let Sublayers = "sublayers"
}

internal enum LayoutNotificationViewChange{
    case Layout
    case ContentOffset
    case ContentInset
}

internal class LayoutNotificationView: UIView {
    
    let layoutChangeHandler: (change: LayoutNotificationViewChange) -> Void
    let subviewChangeHandler: () -> Void
    var superviewContentOffset: CGPoint = CGPointZero
    var superviewContentInset: UIEdgeInsets = UIEdgeInsetsZero
    private var observersAttached = false
    
    init(frame: CGRect, layoutChangeHandler: (change: LayoutNotificationViewChange) -> Void, subviewChangeHandler:() -> Void){
        self.layoutChangeHandler = layoutChangeHandler
        self.subviewChangeHandler = subviewChangeHandler
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        unbindSuperviewObservers()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutChangeHandler(change: .Layout)
    }
    
    override func didMoveToSuperview() {
        if let view = superview as? UIScrollView {
            superviewContentInset = view.contentInset
            superviewContentOffset = view.contentOffset
        }
        bindSuperviewObservers()
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        unbindSuperviewObservers()
    }
    
    private func bindSuperviewObservers() {
        if !observersAttached && superview != nil {
            observersAttached = true
            superview!.layer.addObserver(self, forKeyPath: LayoutNotificationViewKVOKeys.Sublayers, options: [.New], context: nil)
            if superview! is UIScrollView {
                superview!.addObserver(self, forKeyPath: LayoutNotificationViewKVOKeys.ContentInset, options: [.New], context: nil)
                superview!.addObserver(self, forKeyPath: LayoutNotificationViewKVOKeys.ContentOffset, options: [.New], context: nil)
            }
        }
    }
    
    private func unbindSuperviewObservers() {
        if observersAttached && superview != nil{
            observersAttached = false
            superview!.layer.removeObserver(self, forKeyPath: LayoutNotificationViewKVOKeys.Sublayers)
            if superview! is UIScrollView {
                superview!.removeObserver(self, forKeyPath: LayoutNotificationViewKVOKeys.ContentInset)
                superview!.removeObserver(self, forKeyPath: LayoutNotificationViewKVOKeys.ContentOffset)
            }
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if let superview = self.superview, let keyPath = keyPath {
            if keyPath == LayoutNotificationViewKVOKeys.Sublayers {
                subviewChangeHandler()
            }
            if let superview = superview as? UIScrollView{
                if keyPath == LayoutNotificationViewKVOKeys.ContentOffset {
                    superviewContentOffset = superview.contentOffset
                    layoutChangeHandler(change: .ContentOffset)
                } else if keyPath == LayoutNotificationViewKVOKeys.ContentInset {
                    superviewContentInset = superview.contentInset
                    layoutChangeHandler(change: .ContentInset)
                }
            }
        }
    }
    
}

//
//  LayoutNotificationViewTests.swift
//  Decked
//
//  Created by Adam Stern on 25/04/2016.
//  Copyright © 2016 decked. All rights reserved.
//

import XCTest
@testable import Decked

class LayoutNotificationViewTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCallsLayoutChangeHandlerOnLayoutChange() {
        let expectation = expectationWithDescription("calls layoutChangeHandler")
        let parentView = UIView()
        let view = LayoutNotificationView(frame: CGRectZero, layoutChangeHandler: { (change) in
            XCTAssertTrue(change == .Layout)
            expectation.fulfill()
        }) {
            
        }
        parentView.addSubview(view)
        view.layoutSubviews()
        
        waitForExpectationsWithTimeout(1, handler: nil)
    }
    
    func testCallsLayoutChangeHandlerOnScrollViewContentOffsetChange() {
        let expectation = expectationWithDescription("calls layoutChangeHandler")
        let parentView = UIScrollView(frame: CGRectMake(0, 0, 320, 500))
        parentView.contentSize = CGSizeMake(320, 1000)
        let view = LayoutNotificationView(frame: CGRectZero, layoutChangeHandler: { (change) in
            XCTAssertTrue(change == .ContentOffset)
            expectation.fulfill()
        }) {
            
        }
        parentView.addSubview(view)
        parentView.contentOffset = CGPointMake(0, 200)
        
        waitForExpectationsWithTimeout(1, handler: nil)
    }
    
    func testCallsLayoutChangeHandlerOnScrollViewContentInsetChange() {
        let expectation = expectationWithDescription("calls layoutChangeHandler")
        let parentView = UIScrollView(frame: CGRectMake(0, 0, 320, 500))
        parentView.contentSize = CGSizeMake(320, 1000)
        let view = LayoutNotificationView(frame: CGRectZero, layoutChangeHandler: { (change) in
            if change == .ContentInset {
                expectation.fulfill()
            }
        }) {
            
        }
        parentView.addSubview(view)
        parentView.contentInset = UIEdgeInsetsMake(20, 0, 20, 0)
        
        waitForExpectationsWithTimeout(1, handler: nil)
    }
    
    func testCallsLayoutChangeHandlerOnSuperviewSubviewsChange() {
        let expectation = expectationWithDescription("calls subviewChangeHandler")
        let parentView = UIView()
        let view = LayoutNotificationView(frame: CGRectZero, layoutChangeHandler: { (change) in
        }) {
            expectation.fulfill()
        }
        parentView.addSubview(view)
        let extraView = UIView()
        parentView.addSubview(extraView)
        
        waitForExpectationsWithTimeout(1, handler: nil)
    }
    
}

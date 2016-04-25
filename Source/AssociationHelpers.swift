//
//  AssociationHelpers.swift
//  pinch
//
//  Created by Adam Stern on 18/03/2016.
//  Copyright © 2016 TurboPython. All rights reserved.
//

import UIKit
import ObjectiveC

final class Lifted<T> {
    let value: T
    init( _ x: T) {
        value = x
    }
}

private func lift<T>(x: T) -> Lifted<T>  {
    return Lifted(x)
}

func setAssociatedObject<T>(object: AnyObject, value: T, associativeKey: UnsafePointer<Void>, policy: objc_AssociationPolicy) {
    if let v: AnyObject = value as? AnyObject {
        objc_setAssociatedObject(object, associativeKey, v,  policy)
    } else {
        objc_setAssociatedObject(object, associativeKey, lift(value),  policy)
    }
}

func getAssociatedObject<T>(object: AnyObject, associativeKey: UnsafePointer<Void>) -> T? {
    if let v = objc_getAssociatedObject(object, associativeKey) as? T {
        return v
    } else if let v = objc_getAssociatedObject(object, associativeKey) as? Lifted<T> {
        return v.value
    } else {
        return nil
    }
}
//
//  JSValue.swift
//  Birch
//
//  Created by Jesse Grosjean on 6/14/16.
//  Copyright © 2016 Jesse Grosjean. All rights reserved.
//

import Foundation
import JavaScriptCore

extension JSValue {
    
    public func selfOrNil() -> JSValue? {
        if isNull || isUndefined {
            return nil
        }
        return self
    }
    
    // must be ...
    public class func fromItemTypeArray(items: [ItemType], context: JSContext) -> JSValue {
        let jsItems = JSValue(newArrayInContext: context)
        for i in 0..<items.count {
            jsItems.setValue(items[i], atIndex: i)
        }
        return jsItems
    }

    // ... a better way?
    public func toItemTypeArray() -> [ItemType] {
        let length = Int(valueForProperty("length").toInt32())
        var result: [ItemType] = []
        for i in 0..<length {
            if let each = valueAtIndex(i) {
                result.append(each)
            }
        }
        return result
    }
    
}
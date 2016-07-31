//
//  ItemPathQueryType.swift
//  BirchOutline
//
//  Created by Jesse Grosjean on 7/24/16.
//  Copyright © 2016 Jesse Grosjean. All rights reserved.
//

import Foundation
import JavaScriptCore

public protocol ItemPathQueryType: AnyObject {
    
    func onDidChange(callback: (items: [ItemType]) -> Void) -> DisposableType

    var itemPath: String { get set }
    
    var started: Bool { get }
    func start()
    func stop()
    
    var results: [ItemType] { get }
    
}

public class ItemPathQuery: ItemPathQueryType {
    
    var jsItemPathQuery: JSValue
    
    init(jsItemPathQuery: JSValue) {
        self.jsItemPathQuery = jsItemPathQuery
    }
    
    public func onDidChange(callback: (items: [ItemType]) -> Void) -> DisposableType {
        let callbackWrapper: @convention(block) (items: JSValue) -> Void = { items in
            callback(items: items.toItemTypeArray())
        }
        return jsItemPathQuery.invokeMethod("onDidChange", withArguments: [unsafeBitCast(callbackWrapper, AnyObject.self)])
    }
    
    public var itemPath: String {
        get {
            return jsItemPathQuery.valueForProperty("itemPath").toString()
        }
        set(value) {
            return jsItemPathQuery.setValue(itemPath, forProperty: "itemPath")
        }
    }
    
    public var started: Bool {
        return jsItemPathQuery.valueForProperty("started").toBool()
    }
    
    public func start() {
        jsItemPathQuery.invokeMethod("start", withArguments: [])
    }
    
    public func stop() {
        jsItemPathQuery.invokeMethod("stop", withArguments: [])
    }
    
    public var results: [ItemType] {
        return jsItemPathQuery.invokeMethod("items", withArguments: []).toItemTypeArray()
    }

}

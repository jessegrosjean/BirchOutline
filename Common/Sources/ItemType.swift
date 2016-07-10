//
//  ItemType.swift
//  Birch
//
//  Created by Jesse Grosjean on 6/14/16.
//  Copyright © 2016 Jesse Grosjean. All rights reserved.
//

import Foundation
import JavaScriptCore


public protocol ItemType: AnyObject {
    
    var id: String { get }
    var outline: OutlineType { get }
    
    var parent: ItemType? { get }
    var firstChild: ItemType? { get }
    var lastChild: ItemType? { get }
    var previousSibling: ItemType? { get }
    var nextSibling: ItemType? { get }
    var children: [ItemType] { get }

    func insertChildren(children: [ItemType], beforeSibling: ItemType?)
    func appendChildren(children: [ItemType])
    func removeChildren(children: [ItemType])
    func removeFromParent()

    var attributes: [String:String] { get }
    func hasAttribute(name: String) -> Bool
    func attributeForName(name: String) -> String?
    func setAttribute(name: String, value: AnyObject)
    
    var body: String { get set }
    
}

extension JSValue: ItemType {

    public var id: String {
        return valueForProperty("id").toString()
    }

    public var outline: OutlineType {
        return valueForProperty("outline")
    }

    public var parent: ItemType? {
        return valueForProperty("parent").selfOrNil()
    }

    public var firstChild: ItemType? {
        return valueForProperty("firstChild").selfOrNil()
    }

    public var lastChild: ItemType? {
        return valueForProperty("lastChild").selfOrNil()
    }

    public var previousSibling: ItemType? {
        return valueForProperty("previousSibling").selfOrNil()
    }

    public var nextSibling: ItemType? {
        return valueForProperty("nextSibling").selfOrNil()
    }
    
    public var children: [ItemType] {
        return valueForProperty("children").toItemTypeArray() 
    }
    
    public func insertChildren(children: [ItemType], beforeSibling: ItemType?) {
        let mapped: [AnyObject] = children.map { $0 }
        if let beforeSibling = beforeSibling {
            invokeMethod("insertChildrenBefore", withArguments: [mapped, beforeSibling])
        } else {
            invokeMethod("insertChildrenBefore", withArguments: [mapped])
        }
    }

    public func appendChildren(children: [ItemType]) {
        let mapped: [AnyObject] = children.map { $0 }
        invokeMethod("appendChildren", withArguments: [mapped])
    }
    
    public func removeChildren(children: [ItemType]) {
        let mapped: [AnyObject] = children.map { $0 }
        invokeMethod("removeChildren", withArguments: [mapped])
    }
    
    public func removeFromParent() {
       invokeMethod("removeFromParent", withArguments: [])
    }

    public var attributes: [String:String] {
        return valueForProperty("attributes").toDictionary() as? [String:String] ?? [:]
    }
    
    public func hasAttribute(name: String) -> Bool {
        return invokeMethod("hasAttribute", withArguments: [name]).toBool()
    }
    
    public func attributeForName(name: String) -> String? {
        return invokeMethod("getAttribute", withArguments: [name]).selfOrNil()?.toString()
    }

    public func setAttribute(name: String, value: AnyObject) {
        invokeMethod("setAttribute", withArguments: [name, value])
    }
    
    public var body: String {
        get {
            return valueForProperty("bodyString").toString()
        }
        set (value) {
            setValue(value, forProperty: "bodyString")
        }
    }

}
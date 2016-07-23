//
//  OutlineType.swift
//  Birch
//
//  Created by Jesse Grosjean on 6/14/16.
//  Copyright © 2016 Jesse Grosjean. All rights reserved.
//

import Foundation
import JavaScriptCore

public protocol OutlineType {
    
    var root: ItemType { get }
    var items: [ItemType] { get }
    
    func itemForID(id: String) -> ItemType?
    func evaluateItemPath(path: String) -> [ItemType]
    
    func createItem(text: String) -> ItemType
    func cloneItem(item: ItemType, deep: Bool) -> ItemType
    func cloneItems(items: [ItemType], deep: Bool) -> [ItemType]
    
    var changed: Bool { get }
    func updateChangeCount(changeKind: ChangeKind)
    func onDidUpdateChangeCount(callback: (changeKind: ChangeKind) -> Void) -> DisposableType
    func onDidChange(callback: (mutation: MutationType) -> Void) -> DisposableType
    
    func undo()
    func redo()
    
    func serialize(options: [String: AnyObject]?) -> String
    func reloadSerialization(serialization: String, options: [String: AnyObject]?)

    var retainCount: Int { get }
}

public enum ChangeKind {

    case Done
    case Undone
    case Redone
    case Cleared

    public init?(string: String) {
        switch string {
        case "Done":
            self = .Done
        case "Undone":
            self = .Undone
        case "Redone":
            self = .Redone
        case "Cleared":
            self = .Cleared
        default:
            return nil
        }
    }
    
    public func toString() -> String {
        switch self {
        case .Done:
            return "Done"
        case .Undone:
            return "Undone"
        case .Redone:
            return "Redone"
        case .Cleared:
            return "Cleared"
        }
    }

}

public class Outline: OutlineType {
    
    public var jsOutline: JSValue
    
    init(jsOutline: JSValue) {
        self.jsOutline = jsOutline
    }

    public var root: ItemType {
        return jsOutline.valueForProperty("root")
    }
    
    public var items: [ItemType] {
        return jsOutline.valueForProperty("items").toItemTypeArray()
    }
    
    public func itemForID(id: String) -> ItemType? {
        return jsOutline.invokeMethod("getItemForID", withArguments: [id]).selfOrNil()
    }
    
    public func evaluateItemPath(path: String) -> [ItemType] {
        return jsOutline.invokeMethod("evaluateItemPath", withArguments: [path]).toItemTypeArray()
    }
    
    public func createItem(text: String) -> ItemType {
        return jsOutline.invokeMethod("createItem", withArguments: [text])
    }
    
    public func cloneItem(item: ItemType, deep: Bool = true) -> ItemType {
        return jsOutline.invokeMethod("cloneItem", withArguments: [item, deep])
    }
    
    public func cloneItems(items: [ItemType], deep: Bool = true) -> [ItemType] {
        let jsItems = JSValue.fromItemTypeArray(items, context: jsOutline.context)
        let jsItemsClone = jsOutline.invokeMethod("cloneItems", withArguments: [jsItems, deep])
        return jsItemsClone.toItemTypeArray()
    }

    public var changed: Bool {
        return jsOutline.valueForProperty("isChanged").toBool()
    }
    
    public func updateChangeCount(changeKind: ChangeKind) {
        jsOutline.invokeMethod("updateChangeCount", withArguments: [changeKind.toString()])
    }
    
    public func onDidUpdateChangeCount(callback: (changeKind: ChangeKind) -> Void) -> DisposableType {
        let callbackWrapper: @convention(block) (changeKindString: String) -> Void = { changeKindString in
            callback(changeKind: ChangeKind(string: changeKindString)!)
        }
        return jsOutline.invokeMethod("onDidUpdateChangeCount", withArguments: [unsafeBitCast(callbackWrapper, AnyObject.self)])
    }
    
    public func onDidChange(callback: (mutation: MutationType) -> Void) -> DisposableType {
        let callbackWrapper: @convention(block) (mutation: JSValue) -> Void = { mutation in
            callback(mutation: Mutation(jsMutation: mutation))
        }
        return jsOutline.invokeMethod("onDidChange", withArguments: [unsafeBitCast(callbackWrapper, AnyObject.self)])
    }
    
    public func undo() {
        jsOutline.invokeMethod("undo", withArguments: [])
    }
    
    public func redo() {
        jsOutline.invokeMethod("redo", withArguments: [])
    }
    
    public func serialize(options:[String: AnyObject]?) -> String {
        return jsOutline.invokeMethod("serialize", withArguments: [options ?? [:]]).toString()
    }
    
    public func reloadSerialization(serialization: String, options: [String: AnyObject]?) {
        jsOutline.invokeMethod("reloadSerialization", withArguments: [serialization, options ?? [:]])
    }
    
    public var retainCount: Int {
        return Int(jsOutline.valueForProperty("retainCount").toInt32())
    }
    
}
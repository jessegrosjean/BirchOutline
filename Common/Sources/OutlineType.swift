//
//  OutlineType.swift
//  Birch
//
//  Created by Jesse Grosjean on 6/14/16.
//  Copyright © 2016 Jesse Grosjean. All rights reserved.
//

import Foundation
import JavaScriptCore

public protocol OutlineType: AnyObject {
    
    var jsOutline: JSValue { get }
    
    var root: ItemType { get }
    var items: [ItemType] { get }
    
    func itemForID(_ id: String) -> ItemType?
    func evaluateItemPath(_ path: String) -> [ItemType]
    
    func createItem(_ text: String) -> ItemType
    func cloneItem(_ item: ItemType, deep: Bool) -> ItemType
    func cloneItems(_ items: [ItemType], deep: Bool) -> [ItemType]

    func groupUndo(_ callback: @escaping () -> Void)
    func groupChanges(_ callback: @escaping () -> Void)
    
    var changed: Bool { get }
    func updateChangeCount(_ changeKind: ChangeKind)
    func onDidUpdateChangeCount(_ callback: @escaping (_ changeKind: ChangeKind) -> Void) -> DisposableType
    func onDidChange(_ callback: @escaping (_ mutation: MutationType) -> Void) -> DisposableType
    func onDidEndChanges(_ callback: @escaping (_ mutations: [MutationType]) -> Void) -> DisposableType
    
    func undo()
    func redo()
    
    var serializedMetadata: String { get set }
    
    func serializeItems(_ items: [ItemType], options: [String : Any]?) -> String
    func deserializeItems(_ serializedItems: String, options: [String : Any]?) -> [ItemType]?
    func serialize(_ options: [String: Any]?) -> String
    func reloadSerialization(_ serialization: String, options: [String: Any]?)

    var retainCount: Int { get }
}

public enum ChangeKind {

    case done
    case undone
    case redone
    case cleared

    public init?(string: String) {
        switch string {
        case "Done":
            self = .done
        case "Undone":
            self = .undone
        case "Redone":
            self = .redone
        case "Cleared":
            self = .cleared
        default:
            return nil
        }
    }
    
    public func toString() -> String {
        switch self {
        case .done:
            return "Done"
        case .undone:
            return "Undone"
        case .redone:
            return "Redone"
        case .cleared:
            return "Cleared"
        }
    }

}

open class Outline: OutlineType {
    
    open var jsOutline: JSValue
    
    public init(jsOutline: JSValue) {
        self.jsOutline = jsOutline
    }

    open var root: ItemType {
        return jsOutline.forProperty("root")
    }
    
    open var items: [ItemType] {
        return jsOutline.forProperty("items").toItemTypeArray()
    }
    
    open func itemForID(_ id: String) -> ItemType? {
        return jsOutline.invokeMethod("getItemForID", withArguments: [id]).selfOrNil()
    }
    
    open func evaluateItemPath(_ path: String) -> [ItemType] {
        return jsOutline.invokeMethod("evaluateItemPath", withArguments: [path]).toItemTypeArray()
    }
    
    open func createItem(_ text: String) -> ItemType {
        return jsOutline.invokeMethod("createItem", withArguments: [text])
    }
    
    open func cloneItem(_ item: ItemType, deep: Bool = true) -> ItemType {
        return jsOutline.invokeMethod("cloneItem", withArguments: [item, deep])
    }
    
    open func cloneItems(_ items: [ItemType], deep: Bool = true) -> [ItemType] {
        let jsItems = JSValue.fromItemTypeArray(items, context: jsOutline.context)
        let jsItemsClone = jsOutline.invokeMethod("cloneItems", withArguments: [jsItems, deep])
        return jsItemsClone!.toItemTypeArray()
    }

    public func groupUndo(_ callback: @escaping () -> Void) {
        let callbackWrapper: @convention(block) () -> Void = {
            callback()
        }
        jsOutline.invokeMethod("groupUndo", withArguments: [unsafeBitCast(callbackWrapper, to: AnyObject.self)])
    }

    public func groupChanges(_ callback: @escaping () -> Void) {
        let callbackWrapper: @convention(block) () -> Void = {
            callback()
        }
        jsOutline.invokeMethod("groupChanges", withArguments: [unsafeBitCast(callbackWrapper, to: AnyObject.self)])
    }
    
    open var changed: Bool {
        return jsOutline.forProperty("isChanged").toBool()
    }
    
    open func updateChangeCount(_ changeKind: ChangeKind) {
        jsOutline.invokeMethod("updateChangeCount", withArguments: [changeKind.toString()])
    }
    
    open func onDidUpdateChangeCount(_ callback: @escaping (_ changeKind: ChangeKind) -> Void) -> DisposableType {
        let callbackWrapper: @convention(block) (_ changeKindString: String) -> Void = { changeKindString in
            callback(ChangeKind(string: changeKindString)!)
        }
        return jsOutline.invokeMethod("onDidUpdateChangeCount", withArguments: [unsafeBitCast(callbackWrapper, to: AnyObject.self)])
    }
    
    open func onDidChange(_ callback: @escaping (_ mutation: MutationType) -> Void) -> DisposableType {
        let callbackWrapper: @convention(block) (_ mutation: JSValue) -> Void = { mutation in
            callback(Mutation(jsMutation: mutation))
        }
        return jsOutline.invokeMethod("onDidChange", withArguments: [unsafeBitCast(callbackWrapper, to: AnyObject.self)])
    }

    open func onDidEndChanges(_ callback: @escaping (_ mutations: [MutationType]) -> Void) -> DisposableType {
        let callbackWrapper: @convention(block) (_ mutation: JSValue) -> Void = { jsMutations in
            let length = Int((jsMutations.forProperty("length").toInt32()))
            var mutations = [Mutation]()
            for i in 0..<length {
                mutations.append(Mutation(jsMutation: jsMutations.atIndex(i)))
            }
            callback(mutations)
        }
        return jsOutline.invokeMethod("onDidEndChanges", withArguments: [unsafeBitCast(callbackWrapper, to: AnyObject.self)])
    }
    
    open func undo() {
        jsOutline.invokeMethod("undo", withArguments: [])
    }
    
    open func redo() {
        jsOutline.invokeMethod("redo", withArguments: [])
    }
    
    public var serializedMetadata: String {
        get {
            return jsOutline.forProperty("serializedMetadata").toString()
        }
        set {
            jsOutline.setValue(newValue, forProperty: "serializedMetadata")
        }
    }

    open func serializeItems(_ items: [ItemType], options: [String : Any]?) -> String {
        let mapped: [Any] = items.map { $0 }
        return jsOutline.invokeMethod("serializeItems", withArguments: [mapped, options ?? [:]]).toString()
    }

    open func deserializeItems(_ serializedItems: String, options: [String : Any]?) -> [ItemType]? {
        return jsOutline.invokeMethod("deserializeItems", withArguments: [serializedItems, options ?? [:]]).toItemTypeArray()
    }
    
    open func serialize(_ options:[String: Any]?) -> String {
        return jsOutline.invokeMethod("serialize", withArguments: [options ?? [:]]).toString()
    }
    
    open func reloadSerialization(_ serialization: String, options: [String: Any]?) {
        jsOutline.invokeMethod("reloadSerialization", withArguments: [serialization, options ?? [:]])
    }
    
    open var retainCount: Int {
        return Int(jsOutline.forProperty("retainCount").toInt32())
    }
    
}

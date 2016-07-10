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
    
    func serialize(type: String?) -> String
    func reloadSerialization(serialization: String, type:String?)

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

extension JSValue: OutlineType {

    public var root: ItemType {
        return valueForProperty("root")
    }
    
    public var items: [ItemType] {
        return valueForProperty("items").toArray() as! [ItemType]
    }
    
    public func itemForID(id: String) -> ItemType? {
        return invokeMethod("getItemForID", withArguments: [id]).selfOrNil()
    }
    
    public func evaluateItemPath(path: String) -> [ItemType] {
        return invokeMethod("evaluateItemPath", withArguments: [path]).toArray() as! [ItemType]
    }

    public func createItem(text: String) -> ItemType {
        return invokeMethod("createItem", withArguments: [text])
    }

    public func serialize(type: String?) -> String {
        if let type = type {
            return invokeMethod("serialize", withArguments: [type]).toString()
        } else {
            return invokeMethod("serialize", withArguments: []).toString()
        }
    }
    
    public func reloadSerialization(serialization: String, type:String?) {
        if let type = type {
            invokeMethod("reloadSerialization", withArguments: [serialization, type])
        } else {
            invokeMethod("reloadSerialization", withArguments: [serialization])
        }
    }

}
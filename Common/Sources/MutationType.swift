//
//  MutationType.swift
//  BirchOutline
//
//  Created by Jesse Grosjean on 7/23/16.
//  Copyright © 2016 Jesse Grosjean. All rights reserved.
//

import Foundation
import JavaScriptCore

public enum MutationKind {
    
    case Attribute
    case Body
    case Children

}

public protocol MutationType: AnyObject {
    
    var target: ItemType { get }
    var type: MutationKind { get }
    var addedItems: [ItemType]? { get }
    var removedItems: [ItemType]? { get }
    var previousSibling: ItemType? { get }
    var nextSibling: ItemType? { get }
    
}

public class Mutation: MutationType {
    
    public var jsMutation: JSValue
    
    init(jsMutation: JSValue) {
        self.jsMutation = jsMutation
    }
    
    public var target: ItemType {
        return jsMutation.valueForProperty("target")
    }
    
    public var type: MutationKind {
        switch jsMutation.valueForProperty("type").toString() {
        case "attribute":
            return .Attribute
        case "body":
            return .Body
        case "children":
            return .Children
        default:
            assert(false, "Unexpected mutation type string")
        }
    }
    
    public var addedItems: [ItemType]? {
        if let addedItems = jsMutation.valueForProperty("addedItems").selfOrNil() {
            return addedItems.toItemTypeArray()
        }
        return nil
    }
    
    public var removedItems: [ItemType]? {
        if let removedItems = jsMutation.valueForProperty("removedItems").selfOrNil() {
            return removedItems.toItemTypeArray()
        }
        return nil
    }

    public var previousSibling: ItemType? {
        return jsMutation.valueForProperty("previousSibling").selfOrNil()
    }

    public var nextSibling: ItemType? {
        return jsMutation.valueForProperty("nextSibling").selfOrNil()
    }

}

//
//  CrossPlatform.swift
//  BirchOutline
//
//  Created by Jesse Grosjean on 7/10/16.
//  Copyright © 2016 Jesse Grosjean. All rights reserved.
//

import Foundation

#if os(iOS)

    import UIKit
    
    //public typealias Responder = UIResponder
    //public typealias Image = UIImage
    //public typealias Color = UIColor

    extension ChangeKind {
        public init(changeKind: UIDocumentChangeKind) {
            switch changeKind {
            case .Done:
                self = .Done
            case .Undone:
                self = .Undone
            case .Redone:
                self = .Redone
            case .Cleared:
                self = .Cleared
            }
        }
        
        public func toCocoaChangeKind() -> UIDocumentChangeKind {
            switch self {
            case .Done:
                return .Done
            case .Undone:
                return .Undone
            case .Redone:
                return .Redone
            case .Cleared:
                return .Cleared
            }
        }
    }
    
#elseif os(OSX)
    
    //import AppKit
    
    //public typealias Responder = NSResponder
    //public typealias Image = NSImage
    //public typealias Color = NSColor

    extension ChangeKind {
        public init?(changeKind: NSDocumentChangeType) {
            switch changeKind {
            case .ChangeDone:
                self = .Done
            case .ChangeUndone:
                self = .Undone
            case .ChangeRedone:
                self = .Redone
            case .ChangeCleared:
                self = .Cleared
            //case ChangeReadOtherContents:
            //case ChangeAutosaved:
            //case ChangeDiscardable:
            default:
                return nil
            }
        }
        
        public func toCocoaChangeKind() -> NSDocumentChangeType {
            switch self {
            case .Done:
                return .ChangeDone
            case .Undone:
                return .ChangeUndone
            case .Redone:
                return .ChangeRedone
            case .Cleared:
                return .ChangeCleared
            }
        }
    }
    
#endif

func cpAlert(messageText: String, informativeText: String = "") {
    print("\(messageText)\n\n\(informativeText)")
}
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
            case .done:
                self = .done
            case .undone:
                self = .undone
            case .redone:
                self = .redone
            case .cleared:
                self = .cleared
            }
        }
        
        public func toCocoaChangeKind() -> UIDocumentChangeKind {
            switch self {
            case .done:
                return .done
            case .undone:
                return .undone
            case .redone:
                return .redone
            case .cleared:
                return .cleared
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
            case .changeDone:
                self = .done
            case .changeUndone:
                self = .undone
            case .changeRedone:
                self = .redone
            case .changeCleared:
                self = .cleared
            //case ChangeReadOtherContents:
            //case ChangeAutosaved:
            //case ChangeDiscardable:
            default:
                return nil
            }
        }
        
        public func toCocoaChangeKind() -> NSDocumentChangeType {
            switch self {
            case .done:
                return .changeDone
            case .undone:
                return .changeUndone
            case .redone:
                return .changeRedone
            case .cleared:
                return .changeCleared
            }
        }
    }
    
#endif

func cpAlert(_ messageText: String, informativeText: String = "") {
    print("\(messageText)\n\n\(informativeText)")
}

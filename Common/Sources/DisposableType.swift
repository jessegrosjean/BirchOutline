//
//  File.swift
//  BirchOutline
//
//  Created by Jesse Grosjean on 7/6/16.
//  Copyright © 2016 Jesse Grosjean. All rights reserved.
//

import Foundation
import JavaScriptCore

public protocol DisposableType: AnyObject {
    
    func dispose()
    
}

extension JSValue: DisposableType {

    public func dispose() {
        invokeMethod("dispose", withArguments: [])
    }
    
}
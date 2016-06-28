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
    
}
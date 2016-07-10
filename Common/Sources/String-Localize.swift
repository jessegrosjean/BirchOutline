//
//  String.swift
//  BirchOutline
//
//  Created by Jesse Grosjean on 6/28/16.
//  Copyright © 2016 Jesse Grosjean. All rights reserved.
//

import Foundation

public extension String {
    
    public func localized(comment: String? = nil) -> String {
        return NSLocalizedString(self, comment: comment ?? "")
    }

}
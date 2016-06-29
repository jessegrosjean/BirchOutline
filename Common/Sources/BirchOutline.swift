//
//  Birch.swift
//  Birch
//
//  Created by Jesse Grosjean on 6/10/16.
//  Copyright © 2016 Jesse Grosjean. All rights reserved.
//

public class BirchOutline {

    public static var sharedContext = BirchScriptContext()

    public static func createOutline(type: String?, content: String?) -> OutlineType {
        return sharedContext.createOutline(type, content: content)
    }
    
    public static func createTaskPaperOutline(content: String?) -> OutlineType {
        return sharedContext.createTaskPaperOutline(content)
    }
    
}
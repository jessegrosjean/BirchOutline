//
//  Birch.swift
//  Birch
//
//  Created by Jesse Grosjean on 6/10/16.
//  Copyright © 2016 Jesse Grosjean. All rights reserved.
//

import JavaScriptCore

public class Birch {
    
    public static func createOutline(type: String?, content: String?) -> OutlineType {
        return JavaScriptContext.sharedInstance.jsOutlineClass.constructWithArguments([type ?? "text/plain", content ?? ""])
    }
    
    public static func createTaskPaperOutline(content: String?) -> OutlineType {
        return JavaScriptContext.sharedInstance.jsOutlineClass.constructWithArguments(["text/taskpaper", content ?? ""])
    }

}
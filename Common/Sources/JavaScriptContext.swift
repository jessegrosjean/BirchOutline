//
//  JavaScriptContext.swift
//  Birch
//
//  Created by Jesse Grosjean on 5/31/16.
//  Copyright © 2016 Jesse Grosjean. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(OSX)
import Cocoa
#endif

import JavaScriptCore
import WebKit

public class JavaScriptContext {

    public static let sharedInstance = JavaScriptContext()

    public var context: JSContext
    
    public var jsBirchOutline: JSValue {
        return context.objectForKeyedSubscript("birchoutline")
    }
    
    public var jsOutlineClass: JSValue {
        return jsBirchOutline.valueForProperty("Outline")
    }

    public var jsItemClass: JSValue {
        return jsBirchOutline.valueForProperty("Item")
    }

    public var jsMutationClass: JSValue {
        return jsBirchOutline.valueForProperty("Mutation")
    }
    
    public var jsItemSerializerClass: JSValue {
        return jsBirchOutline.valueForProperty("ItemSerializer")
    }

    public var jsDateTimeClass: JSValue {
        return jsBirchOutline.valueForProperty("DateTime")
    }

    init () {
        context = JSContext()
        context.name = "BirchOutlineJavaScriptContext"
        
        setExceptionHandler(context)
        setTimeoutAndClearTimeoutHandlers(context)
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let scriptPath = bundle.pathForResource("birchoutline", ofType: "js")
        let script = try! String(contentsOfFile: scriptPath!)
        
        context.evaluateScript(script)
    }
    
}

func setExceptionHandler(context: JSContext) {
    context.exceptionHandler = { context, exception in
        print("Exception: \(exception)")
        print("Stack: \(exception.valueForProperty("stack"))")
    }
}

func setTimeoutAndClearTimeoutHandlers(context: JSContext) {
    var setTimeoutID: Int32 = 1
    var setTimeOutIDsToCallbacks = [Int32:JSValue]()
    
    let setTimeout: @convention(block) (JSValue, Int) -> JSValue = { (callback, wait) in
        let thisTimeOutID = setTimeoutID
        setTimeoutID += 1
        setTimeOutIDsToCallbacks[thisTimeOutID] = callback
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(UInt64(wait) * NSEC_PER_MSEC)), dispatch_get_main_queue(), { () -> Void in
            setTimeOutIDsToCallbacks[thisTimeOutID]?.callWithArguments([])
        })
        return JSValue.init(int32: setTimeoutID, inContext: context)
    }
    
    let clearTimeout: @convention(block) (JSValue) -> Void = { (timeoutID) in
        setTimeOutIDsToCallbacks.removeValueForKey(timeoutID.toInt32())
    }

    context.setObject(unsafeBitCast(setTimeout, AnyObject.self), forKeyedSubscript: "setTimeout")
    context.setObject(unsafeBitCast(clearTimeout, AnyObject.self), forKeyedSubscript: "clearTimeout")
}
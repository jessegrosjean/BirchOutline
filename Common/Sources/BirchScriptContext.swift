//
//  JavaScriptContext.swift
//  Birch
//
//  Created by Jesse Grosjean on 5/31/16.
//  Copyright © 2016 Jesse Grosjean. All rights reserved.
//

import JavaScriptCore
import WebKit

public class BirchScriptContext {
    
    public var context: JSContext!    
    public var jsBirchExports: JSValue!
    
    var jsOutlineClass: JSValue {
        return jsBirchExports.valueForProperty("Outline")
    }

    var jsItemClass: JSValue {
        return jsBirchExports.valueForProperty("Item")
    }

    var jsMutationClass: JSValue {
        return jsBirchExports.valueForProperty("Mutation")
    }
    
    var jsItemSerializerClass: JSValue {
        return jsBirchExports.valueForProperty("ItemSerializer")
    }

    var jsDateTimeClass: JSValue {
        return jsBirchExports.valueForProperty("DateTime")
    }

    var jsItemPathClass: JSValue {
        return jsBirchExports.valueForProperty("ItemPath")
    }

    public init (scriptPath: String? = nil) {
        context = JSContext()
        context.name = "BirchOutlineJavaScriptContext"
        
        setExceptionHandler(context)
        setTimeoutAndClearTimeoutHandlers(context)
        
        let bundle = NSBundle(forClass: BirchScriptContext.self)
        let path = scriptPath ?? bundle.pathForResource("birchoutline", ofType: "js")
        let script = try! String(contentsOfFile: path!)
        let birchExportsName = path?.lastPathComponent.stringByDeletingPathExtension
        
        context.evaluateScript(script)
        
        jsBirchExports = context.objectForKeyedSubscript(birchExportsName)
    }
    
    public func createOutline(type: String?, content: String?) -> OutlineType {
        return Outline(jsOutline: jsOutlineClass.constructWithArguments([type ?? "text/plain", content ?? ""]))
    }
    
    public func createTaskPaperOutline(content: String?) -> OutlineType {
        return Outline(jsOutline: jsOutlineClass.constructWithArguments(["text/taskpaper", content ?? ""]))
    }
    
    public func syntaxHighlightItemPath(attributedString: NSMutableAttributedString) {
        guard attributedString.length > 0 else {
            return
        }
        
        let parseInfo = jsItemPathClass.invokeMethod("parse", withArguments: [attributedString.string]).toDictionary() as NSDictionary
        let keywords = parseInfo["keywords"] as! [[String: AnyObject]]
        let defaultAttributes = [
            NSFontAttributeName: NSFont.systemFontOfSize(0)
        ]
        
        attributedString.beginEditing()
        attributedString.setAttributes(defaultAttributes, range: NSMakeRange(0, attributedString.length))
        
        for each in keywords {
            let offset = each["offset"] as! Int
            let label = each["label"] as! String
            let text = each["text"] as! String
            let range = NSMakeRange(offset, text.utf8.count)

            switch label {
            case "keyword.set", "keyword.boolean":
                attributedString.addAttribute(NSFontAttributeName, value: NSFont.boldSystemFontOfSize(0), range: range)
            case "keyword.operation.relation",
                 "keyword.operation.modifier":
                attributedString.addAttribute(NSForegroundColorAttributeName, value: NSColor.grayColor(), range: range)
            case "string.quoted",
                 "string.unquoted":
                break;
            case "entity.other.axis",
                 "entity.other.tag",
                 "entity.other.attribute-name":
                attributedString.addAttribute(NSForegroundColorAttributeName, value: NSColor.grayColor(), range: range)
            default:
                break
            }
        }
        
        if let errorOffset = parseInfo.valueForKeyPath("error.location.start.offset") as? Int {
            attributedString.addAttribute(NSForegroundColorAttributeName, value: NSColor.redColor(), range: NSMakeRange(errorOffset, attributedString.length - errorOffset))
        }
        
        attributedString.endEditing()
    }
    
}

func setExceptionHandler(context: JSContext) {
    context.exceptionHandler = { context, exception in
        cpAlert("Uncaught JavaScript Exception".localized(), informativeText: "\(exception)\n\n\(exception.valueForProperty("stack"))".localized())
        exit(EXIT_SUCCESS)
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
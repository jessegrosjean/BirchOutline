//
//  OutlineTests.swift
//  Birch
//
//  Created by Jesse Grosjean on 6/11/16.
//  Copyright © 2016 Jesse Grosjean. All rights reserved.
//

import XCTest
import JavaScriptCore
@testable import BirchOutline

class OutlineTests: XCTestCase {

    var outline: OutlineType!
    
    override func setUp() {
        super.setUp()
        let path = NSBundle(forClass: self.dynamicType).pathForResource("Outline", ofType: "txt")!
        let textContents = try! NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
        outline = BirchOutline.createTaskPaperOutline(textContents as String)
    }
    
    override func tearDown() {
        outline = nil
    }

    func testInit() {
        XCTAssertNotNil(outline)
        XCTAssertEqual(outline.root.firstChild!.firstChild!.body, "two")
    }

    func testRemoveFromParent() {
        let two = outline.root.firstChild!.firstChild!
        two.removeFromParent()
        XCTAssertEqual(outline.root.firstChild!.firstChild!.body, "five")
        XCTAssertNil(two.parent)
        XCTAssertEqual(outline.serialize(nil), "one\n\tfive\n\t\tsix")
    }

    func testSetTextContent() {
        outline.reloadSerialization("one\n\ttwo @done\n\tthree", options: nil)
        XCTAssertEqual(outline.root.firstChild!.body, "one")
        XCTAssertEqual(outline.root.lastChild!.body, "one")
        XCTAssertEqual(outline.serialize(nil), "one\n\ttwo @done\n\tthree")
    }

    func testItems() {
        XCTAssertEqual(outline.items[0].body, "one")
        XCTAssertEqual(outline.items[5].body, "six")
    }

    func testEvaluateItemPath() {
        XCTAssertEqual(outline.evaluateItemPath("one")[0].body, "one")
    }

    func testOnDidUpdateChangeCountDone() {
        let disposable = outline.onDidUpdateChangeCount { changeType in
            XCTAssertEqual(changeType, ChangeKind.Done)
        }
        outline.root.firstChild!.body = "moose"
        disposable.dispose()
    }
    
    func testOnDidUpdateChangeCountUndone() {
        outline.root.firstChild!.body = "moose"
        let disposable = outline.onDidUpdateChangeCount { changeType in
            XCTAssertEqual(changeType, ChangeKind.Undone)
        }
        outline.undo()
        disposable.dispose()
        
    }

}
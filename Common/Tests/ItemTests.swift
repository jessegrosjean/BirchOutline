//
//  ItemTypeTests.swift
//  Birch
//
//  Created by Jesse Grosjean on 6/14/16.
//  Copyright © 2016 Jesse Grosjean. All rights reserved.
//

import XCTest
import JavaScriptCore
@testable import BirchOutline

class ItemTests: XCTestCase {
    
    var outline: OutlineType!
    var item: ItemType!
    
    override func setUp() {
        super.setUp()
        
        outline = Birch.createOutline(nil, content: nil)
        item = outline.createItem("hello")
    }
    
    override func tearDown() {
        outline = nil
    }
    
    func testInit() {
        XCTAssertNotNil(item)
        XCTAssertEqual(item.body, "hello")
        XCTAssertEqual(item.attributes, [:])
        XCTAssertNil(item.attributeForName("notfound"))
    }

    func testSetAttribute() {
        item.setAttribute("one", value: "two")
        XCTAssertEqual(item.attributes, ["one":"two"])
        XCTAssertEqual(item.attributeForName("one"), "two")
    }

    func testSetBody() {
        item.body = "hello again"
        XCTAssertEqual(item.body, "hello again")
    }

    func testInsertChildren() {
        item.insertChildren([outline.createItem("child 1"), outline.createItem("child 2")], beforeSibling: nil)
        XCTAssertEqual(item.firstChild!.body, "child 1")
        XCTAssertEqual(item.firstChild!.nextSibling!.body, "child 2")
    }

    func testRemoveChildren() {
        let children = [outline.createItem("child 1"), outline.createItem("child 2")]
        item.insertChildren(children, beforeSibling: nil)
        item.removeChildren(children)
        XCTAssertNil(item.firstChild)
    }

}
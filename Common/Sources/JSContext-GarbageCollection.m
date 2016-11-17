//
//  JSContext-GarbageCollection.m
//  BirchOutline
//
//  Created by Jesse Grosjean on 8/22/16.
//  Copyright © 2016 Jesse Grosjean. All rights reserved.
//

#import "JSContext-GarbageCollection.h"

JS_EXPORT void JSSynchronousGarbageCollectForDebugging(JSContextRef ctx);

@implementation JSContext (GarbageCollection)

- (void)garbageCollect {
    JSSynchronousGarbageCollectForDebugging(self.JSGlobalContextRef);
}

@end

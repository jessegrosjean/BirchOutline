//
//  ObjC.h
//  TaskPaper
//
//  Created by Jesse Grosjean on 7/6/16.
//  Copyright © 2016 Jesse Grosjean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjC : NSObject

+ (BOOL)catchException:(void(^)())tryBlock error:(__autoreleasing NSError **)error;

@end

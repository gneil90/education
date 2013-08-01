//
//  NSObject+ManualReferenceCounting.h
//  ManualReferenceCounting
//
//  Created by Mac Owner on 7/31/13.
//  Copyright (c) 2013 1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MaRC)

- (id)custom_retain;
- (void)custom_release;

/*
 *ownership police,
 *methods that are from group alloc/init/copy/mutableCopy !always returns object which owner you are
 */
+(id)allocWithNewObject;
+(id)copyNewObject;
+(id)mutableCopyNewObject;
+(id)newObject;

/*
 *ownership police,
 *methods which are not from group alloc/init/copy/mutableCopy !always returns object which you do not own
 */
+(id)custom_object;

@end

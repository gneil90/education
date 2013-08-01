//
//  MyClass.h
//  ManualReferenceCounting
//
//  Created by Mac Owner on 7/31/13.
//  Copyright (c) 2013 1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomAutoreleasePool : NSAutoreleasePool
{
    CFMutableArrayRef _objects;
}

+ (void)addObject: (id)object;

- (void)addObject: (id)object;

@end

@interface NSObject (MAAutoreleasePool)

- (id)custom_autorelease;

@end
//
//
//  ManualReferenceCounting
//
//  Created by Mac Owner on 7/31/13.
//  Copyright (c) 2013 1. All rights reserved.
//
//

#import "NSObject+ManualReferenceCounting.h"
#import "CustomAutoreleasePool.h"

@implementation CustomAutoreleasePool

//creating array of pools, because user can have multiple instances of NSAutoreleasePool class on each thread, the innermost object becomes active, the following method creates array of pools
+ (CFMutableArrayRef)_arrayOfPools
{
    //returns dictionary, which is unique for current thread
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    
    NSString *key = @"CustomAutoreleasePoolArray";
    
    //needed stack of pools which is storing in thread dictionary under the key
    CFMutableArrayRef array = (CFMutableArrayRef)[threadDictionary objectForKey: key];
    if(!array)
    {
        //if this is first fire of method, creating and setting array in order to store in dictionary
        array = CFArrayCreateMutable(NULL, 0, NULL);
        [threadDictionary setObject: (id)array forKey: key];
        CFRelease(array);
    }
    return array;
}

//self-explanatory method, we are just putting object to the pool, which is at the top of stack
+ (void)addObject: (id)object
{
    CFArrayRef stackOfPools = [self _arrayOfPools];
    CFIndex count = CFArrayGetCount(stackOfPools);
    //pool at the top of stack is active pool, so we are obtaining active pool in _arrayOfPools on our local thread.
    CustomAutoreleasePool *pool = (id)CFArrayGetValueAtIndex(stackOfPools, count - 1);
    [pool addObject: object];
    
}

//initializing array of objects, and putting self to the top of pool stack
- (id)init
{
    if((self = [super init]))
    {
        _objects = CFArrayCreateMutable(NULL, 0, NULL);
        CFArrayAppendValue([[self class] _arrayOfPools], self);
    }
    return self;
}

- (void)dealloc
{
    //sending custom_release message to each object in array
    if(_objects)
    {
        for(id object in (id)_objects)
            [object custom_release];
        CFRelease(_objects);
    }
    //now we want to remove autorelease instance from pool (because user can create nested autorelease pools, we should remove all top pools frome the stack)
    CFMutableArrayRef stackOfPools = [[self class] _arrayOfPools];
    CFIndex index = CFArrayGetCount(stackOfPools);
    while(index-- > 0)
    {
        CustomAutoreleasePool *pool = (id)CFArrayGetValueAtIndex(stackOfPools, index);
        if(pool == self)
        {
            //if instance of autoreleaseClass is pool at index in our stack of pools, then break
            CFArrayRemoveValueAtIndex(stackOfPools, index);
            break;
        }
        else
        {
            //otherwise, we send release message to pool and it will be destroyed (because retain message can not been sent to autorelease class), that is why this pool calls his own dealloc method and enters this loop again.
            [pool release];
        }
    }
    
    [super dealloc];
}

//putting object to the end of arrayOfObjects
- (void)addObject: (id)object
{
    CFArrayAppendValue(_objects, object);
}

@end


@implementation NSObject (MAAutoreleasePool)

- (id)custom_autorelease
{
    [CustomAutoreleasePool addObject: self];
    return self;
}

@end


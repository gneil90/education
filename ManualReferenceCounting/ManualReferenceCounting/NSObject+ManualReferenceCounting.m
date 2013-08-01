//
//  NSObject+ManualReferenceCounting.m
//  ManualReferenceCounting
//
//  Created by Mac Owner on 7/31/13.
//  Copyright (c) 2013 1. All rights reserved.
//

#import "NSObject+ManualReferenceCounting.h"
#import "CustomAutoreleasePool.h"

static CFMutableDictionaryRef dictionaryWithReferenceCount;

//returns count of references
static unsigned long GetReferenceCountOfObject(void *key)
{
    /**
     *once the object is created, reference (retain) count is assigned to 1, that is why new object
     *receives correct count 1 automatically. 
     */
    if(!dictionaryWithReferenceCount)
        return 1;
    
    const void *refCountValue;
    //if there is no object in dictionary, again assigning 1 to refCount
    if(!CFDictionaryGetValueIfPresent(dictionaryWithReferenceCount, key, &refCountValue))
        return 1;
    return (unsigned long)refCountValue;
}

static void SetReferenceCountOfObject(void *key, unsigned long count)
{
    if(count <= 1)
    {
        if(dictionaryWithReferenceCount) //if dictionary was not created, there is no reason to remove
            CFDictionaryRemoveValue(dictionaryWithReferenceCount, key);
    }
    else
    {
        if(!dictionaryWithReferenceCount)
            dictionaryWithReferenceCount = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);
        CFDictionarySetValue(dictionaryWithReferenceCount, key, (void *)count);
    }
}

static void IncrementReferenceCount(void *object)
{
    
    unsigned long count = GetReferenceCountOfObject(object);
    SetReferenceCountOfObject(object, count + 1);
}

static unsigned long DecrementReferenceCount(void *object)
{
    unsigned long count = GetReferenceCountOfObject(object);
    unsigned long newCount = count - 1;
    SetReferenceCountOfObject(object, newCount);
    
    return newCount;
}


//wrapping Increment,Decrement methods. self-explanatory
@implementation NSObject (MaRC)

//we implemented our reference count in such way, that every object that was created automatically ref count 1 will be assigned, thus we do not make any manipulation with reference count when implement following four methods, which returns object with ownership
+(id)allocWithNewObject
{
    return [[[self class] alloc ]init];
}

+(id)newObject
{
    return [[self class]new];
}

+(id)mutableCopyNewObject:(id)object
{
    return [object mutableCopy];
}

+(id)copyNewObject:(id)object
{
    return [object copy];
}

//returning new object with no ownership
+(id)custom_object
{
    return [[[[self class]alloc]init]custom_autorelease];
}


- (id)custom_retain;
{
    IncrementReferenceCount(self);
    return self;
}

- (void)custom_release;
{
    unsigned long newCount = DecrementReferenceCount(self);
    if(newCount == 0)
        [self dealloc];
}
@end



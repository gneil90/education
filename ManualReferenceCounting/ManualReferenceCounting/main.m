//
//  main.m
//  ManualReferenceCounting
//
//  Created by Yan Saraev on 7/31/13.
//  Copyright (c) 2013 1. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "NSObject+ManualReferenceCounting.h"
#import "CustomAutoreleasePool.h"



@interface ObjectClass : NSObject
{
@public
    int count;
}
@end

@implementation ObjectClass
- (void)dealloc
{
    fprintf(stderr, "ObjectClass instance %p dealloc\n", self);
    [super dealloc];
}
@end

int main(int argc, char **argv)
{
        /*CFMutableArrayRef arrayOfTestsObjects = CFArrayCreateMutable(NULL, 0, NULL);
    
        //number of test objects to create
        for(int i = 0; i < 1; i++)
        {
            ObjectClass *obj = [[ObjectClass alloc] init];
            CFArrayAppendValue(arrayOfTestsObjects, obj);
            int randomNumberOfRetains = random() % 10;
            NSLog(@"object will be retained %d times",randomNumberOfRetains);
            (*obj).count = randomNumberOfRetains;
            for(int j = 0; j < (*obj).count; j++)
                [obj custom_retain];
        }
        
        while(CFArrayGetCount(arrayOfTestsObjects))
        {
            CFIndex count = CFArrayGetCount(arrayOfTestsObjects);
            CFIndex index = random() % count;
            ObjectClass *obj = (id)CFArrayGetValueAtIndex(arrayOfTestsObjects, index);
            
            //we are going to send custom_release message one more time than retain, because as
            //we created object, it automatically has 1 reference count.
            int refcount = (*obj).count + 1;
            NSLog(@"object will receive release method %d times",refcount);
            while(refcount-- > 0)
                [obj custom_release];
            
            CFArrayRemoveValueAtIndex(arrayOfTestsObjects, index);
        }
        
        
        CFRelease(arrayOfTestsObjects);*/


        /*
        *testing custom autorelease pool implementation
        */
        
        CustomAutoreleasePool *autoreleasePool = [[CustomAutoreleasePool alloc]init];

        for(int i = 0; i < 20; i++)
        {
        CustomAutoreleasePool *autoreleasePool2 = [[CustomAutoreleasePool alloc]init];
        ObjectClass *testObj = [[[ObjectClass alloc]init]custom_autorelease];
        [autoreleasePool2 dealloc];
        }

        [autoreleasePool dealloc];
}


//----------------------------------------------------------------------------//
//|
//|             MachOKit - A Lightweight Mach-O Parsing Library
//|             NSFileManager+MKTest.m
//|
//|             D.V.
//|             Copyright (c) 2014-2015 D.V. All rights reserved.
//|
//| Permission is hereby granted, free of charge, to any person obtaining a
//| copy of this software and associated documentation files (the "Software"),
//| to deal in the Software without restriction, including without limitation
//| the rights to use, copy, modify, merge, publish, distribute, sublicense,
//| and/or sell copies of the Software, and to permit persons to whom the
//| Software is furnished to do so, subject to the following conditions:
//|
//| The above copyright notice and this permission notice shall be included
//| in all copies or substantial portions of the Software.
//|
//| THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//| OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//| MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//| IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
//| CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
//| TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//| SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//----------------------------------------------------------------------------//

#import "NSFileManager+MKTest.h"

//----------------------------------------------------------------------------//
@implementation NSFileManager (MKTest)

//|++++++++++++++++++++++++++++++++++++|//
+ (NSArray*)allExecutableURLs:(MKExecutableType)type
{
    NSArray* (^getFrameworkExecutables)(NSURL*) = ^(NSURL *directoryURL) {
    @autoreleasepool {
        NSArray *frameworks = [NSFileManager.defaultManager contentsOfDirectoryAtURL:directoryURL includingPropertiesForKeys:@[] options:NSDirectoryEnumerationSkipsHiddenFiles error:NULL];
        NSMutableArray *frameworkExecutables = [NSMutableArray arrayWithCapacity:frameworks.count];
        for (NSURL *frameworkURL in frameworks)
        {
            NSBundle *bundle = [[NSBundle alloc] initWithURL:frameworkURL];
            if (bundle.executableURL)
                [frameworkExecutables addObject:bundle.executableURL];
        }
        return frameworkExecutables;
    }};
    
    static NSArray *publicOSX = nil;
    if (publicOSX == nil)
        publicOSX = getFrameworkExecutables([NSURL fileURLWithPath:@"/System/Library/Frameworks" isDirectory:YES]);
    /*
    static NSArray *privateOSX = nil;
    if (privateOSX == nil)
        privateOSX = getFrameworkExecutables([NSURL fileURLWithPath:@"/System/Library/PrivateFrameworks" isDirectory:YES]);
    
    static NSArray *publiciOS = nil;
    if (publiciOS == nil)
        publiciOS = getFrameworkExecutables([NSURL fileURLWithPath:@"/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/System/Library/Frameworks" isDirectory:YES]);
    
    static NSArray *privateiOS = nil;
    if (privateiOS == nil)
        privateiOS = getFrameworkExecutables([NSURL fileURLWithPath:@"/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/System/Library/Frameworks" isDirectory:YES]);
    */
    NSMutableArray *retValue = [NSMutableArray array];
    if (type & MKFrameworkTypeOSXPublicFramework) [retValue addObjectsFromArray:publicOSX];
    //if (type & MKFrameworkTypeOSXPrivateFramework) [retValue addObjectsFromArray:privateOSX];
    //if (type & MKFrameworkTypeiOSPublicFramework) [retValue addObjectsFromArray:publiciOS];
    //if (type & MKFrameworkTypeiOSPrivateFramework) [retValue addObjectsFromArray:privateiOS];
    
    return [retValue subarrayWithRange:NSMakeRange(0, 15)];
}

//|++++++++++++++++++++++++++++++++++++|//
+ (NSArray*)sharedCachesInDirectoryAtURL:(NSURL*)directoryURL
{
    NSArray *files = [NSFileManager.defaultManager contentsOfDirectoryAtURL:directoryURL includingPropertiesForKeys:@[] options:NSDirectoryEnumerationSkipsHiddenFiles error:NULL];
    return [files filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSURL *evaluatedObject, __unused NSDictionary<NSString *,id> * bindings) {
        return [[evaluatedObject path] rangeOfString:@"dyld_shared_cache_"].location != NSNotFound;
    }]];
}

@end

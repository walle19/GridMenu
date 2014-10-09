//  GridMenu
//  ControllerInterface.m
//
//  Copyright (c) 2014 nikhil. All rights reserved.
//

#import "ControllerInterface.h"

@implementation ControllerInterface
@synthesize isMenuScreenActive=_isMenuScreenActive;

+ (id)sharedInterface {
    static ControllerInterface *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        //Do some task...
    }
    return self;
}

- (void)setFlag:(BOOL)value {
    _isMenuScreenActive = value;
}

@end

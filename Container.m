//
//  Container.m
//  BAC
//
//  Created by Trent Callan on 8/27/13.
//  Copyright (c) 2013 Trent Callan. All rights reserved.
//

#import "Container.h"

@implementation Container
@synthesize information;
@synthesize ouncesHeld;

- (id) initWithInformation: (NSString*)info OuncesHeld: (double)ounces{
    self = [super init];
    if (self) {
    information = info;
    ouncesHeld = ounces;
    }
    return self;
}
- (NSString*) description{
    return [[NSString alloc] initWithFormat:@"Info = %@  Volume = %.1f",information,ouncesHeld];
}

@end

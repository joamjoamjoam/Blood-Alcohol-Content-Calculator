//
//  Container.h
//  BAC
//
//  Created by Trent Callan on 8/27/13.
//  Copyright (c) 2013 Trent Callan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Container : NSObject
@property (strong, nonatomic) NSString* information;
@property double ouncesHeld;


- (id) initWithInformation: (NSString*)desc OuncesHeld: (double)ounces;

@end

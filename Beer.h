//
//  Beer.h
//  BAC
//
//  Created by Trent Callan on 8/26/13.
//  Copyright (c) 2013 Trent Callan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Beer : NSObject<NSCoding>

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) UIImage* img;
@property double abvDecimal;
@property double ouncesConsumed;

-(id) initWithName: (NSString*)nme andABV: (double)abv;
-(id) initWithName: (NSString*)nme;
-(double) totalOuncesOfPureAlcoholConsumed;
- (void)encodeWithCoder: (NSCoder*) encoder;
- (id)initWithCoder:(NSCoder *)decoder;
@end

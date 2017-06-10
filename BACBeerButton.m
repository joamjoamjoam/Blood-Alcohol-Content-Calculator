//
//  BACBeerButton.m
//  BAC
//
//  Created by Trent Callan on 9/7/13.
//  Copyright (c) 2013 Trent Callan. All rights reserved.
//

#import "BACBeerButton.h"

@implementation BACBeerButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.text = @"Select Beer";
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

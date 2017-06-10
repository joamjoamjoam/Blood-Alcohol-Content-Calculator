//
//  Beer.m
//  BAC
//
//  Created by Trent Callan on 8/26/13.
//  Copyright (c) 2013 Trent Callan. All rights reserved.
//

#import "Beer.h"

@implementation Beer
@synthesize name;
@synthesize img;
@synthesize abvDecimal;
@synthesize ouncesConsumed;

-(id) init{
    
    self = [super init];
    if (self) {
        ouncesConsumed = 0;
        img = [UIImage imageNamed:@"beerglass.jpg"];
    }
    return self;
}
-(id) initWithName: (NSString*)nme andABV: (double)abv{
    self = [super init];
    
    if (self) {
        name = nme;
        abvDecimal = abv;
        img = [UIImage imageNamed:@"beerglass.jpg"];
    }
    return self;
}

-(id) initWithName: (NSString*)nme{
    self = [super init];
    if (self) {
        name = nme;
        img = [UIImage imageNamed:@"beerglass.jpg"];
    }
    return self;
}


- (void)encodeWithCoder: (NSCoder*) encoder{
    
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.img forKey:@"img"];
    [encoder encodeDouble:self.abvDecimal forKey:@"abvDecimal"];
    [encoder encodeDouble:self.ouncesConsumed forKey:@"ouncesConsumed"];
    
    
}

- (id)initWithCoder:(NSCoder *)decoder{
    self = [super init];
    
    if (self) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.img = [decoder decodeObjectForKey:@"img"];
        self.abvDecimal = [decoder decodeDoubleForKey:@"abvDecimal"];
        self.ouncesConsumed = [decoder decodeDoubleForKey:@"ouncesConsumed"];
        
    }
    return self;
}



-(double) totalOuncesOfPureAlcoholConsumed{
    double total = abvDecimal * ouncesConsumed;
    return total;
}

@end

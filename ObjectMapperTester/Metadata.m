//
//  Metadata.m
//  ObjectMapperTester
//
//  Created by Mahmood1 on 9/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Metadata.h"

@implementation Metadata
@synthesize result_type;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc {
    [result_type release];
    [super dealloc];
}

@end

//
//  Result.m
//  ObjectMapperTester
//
//  Created by Mahmood1 on 9/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Result.h"

@implementation Result

@synthesize created_at, from_user, from_user_id, text, to_user_id_str, metadata;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc {
    [created_at release];
    [from_user release];
    [from_user_id release];
    [text release];
    [to_user_id_str release];
    [metadata release];
    [super dealloc];
}

@end

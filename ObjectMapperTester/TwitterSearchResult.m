//
//  TwitterSearchResult.m
//  ObjectMapperTester
//
//  Created by Mahmood1 on 9/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "TwitterSearchResult.h"

@implementation TwitterSearchResult

@synthesize completed_in, max_id, query, refresh_url, results, results_per_page;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc 
{
    [completed_in release];
    [max_id release];
    [query release];
    [refresh_url release];
    [results release];
    [results_per_page release];
    
    [super dealloc];
}

@end

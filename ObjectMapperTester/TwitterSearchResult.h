//
//  TwitterSearchResult.h
//  ObjectMapperTester
//
//  Created by Mahmood1 on 9/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//URL for this service: https://dev.twitter.com/docs/api/1/get/search
// I haven't considered all json data for simplicity

#import <Foundation/Foundation.h>

@interface TwitterSearchResult : NSObject
{
    NSNumber* completed_in;
    NSNumber* max_id;
    NSString* query;
    NSString* refresh_url;
    NSArray* results;
    NSNumber* results_per_page;
    
}

@property (nonatomic, retain) NSNumber* completed_in;
@property (nonatomic, retain) NSNumber* max_id;
@property (nonatomic, retain) NSString* query;
@property (nonatomic, retain) NSString* refresh_url;
@property (nonatomic, retain) NSArray* results;
@property (nonatomic, retain) NSNumber* results_per_page;

@end

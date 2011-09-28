//
//  main.m
//  ObjectMapperTester
//
//  Created by Mahmood1 on 9/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "ObjectMapper.h"

#import "TwitterSearchResult.h"
#import "Result.h"
#import "Metadata.h"

int main (int argc, const char * argv[])
{

    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

   
    NSMutableURLRequest* request = [[[NSMutableURLRequest alloc]
                                     initWithURL: [NSURL URLWithString:@"http://search.twitter.com/search.json?q=Muhammad"]] autorelease];
    [request setHTTPMethod:@"GET"];
    NSURLResponse* response = nil;
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: &error];
    NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSDictionary* resultDictionary = [jsonString objectFromJSONString];
    //NSLog(@"%@", jsonString);
    
    /*****************************************************************************************************************/

    NSDictionary* types = [NSDictionary dictionaryWithObject:@"Result" forKey:@"TwitterSearchResult.results"];
    TwitterSearchResult* twitterSearchResult = [[TwitterSearchResult alloc]init];
    [resultDictionary toObject:twitterSearchResult withTypes:types ];
    
    
    NSLog(@"statistics: \n %@ %@ %@ %@ %@", [twitterSearchResult completed_in],
          [twitterSearchResult max_id], [twitterSearchResult query], [twitterSearchResult refresh_url], [twitterSearchResult results_per_page]);
    NSArray* result = [twitterSearchResult results];
    for (Result* res in result)
    {
        NSLog(@"%@ %@ %@ %@ %@", [res created_at], [res from_user], [res from_user_id], [res to_user_id_str], 
              [[res metadata]result_type] );
    }
    
    [twitterSearchResult release];
    /*****************************************************************************************************************/
    
    

    [pool drain];
    return 0;
}


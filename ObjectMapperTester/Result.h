//
//  Result.h
//  ObjectMapperTester
//
//  Created by Mahmood1 on 9/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Metadata.h"

@interface Result : NSObject
{
    NSString* created_at;
    NSString* from_user;
    NSNumber* from_user_id;
    NSString* text;
    NSString* to_user_id_str;
    Metadata* metadata;
    
}

@property (nonatomic, retain) NSString* created_at;
@property (nonatomic, retain) NSString* from_user;
@property (nonatomic, retain) NSNumber* from_user_id;
@property (nonatomic, retain) NSString* text;
@property (nonatomic, retain) NSString* to_user_id_str;
@property (nonatomic, retain) Metadata* metadata;

@end

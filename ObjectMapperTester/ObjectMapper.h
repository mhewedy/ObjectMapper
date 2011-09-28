//
//  ObjectMapper.h
//  ObjectMapper
//
//  Created by Muhammad Hewedy mohammed_a_hewedy@hotmail.com on 9/25/11.
//  Copyright 2011 . All rights reserved.
//
/*
 Copyright 2011 Muhammad Hewedy
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface ObjectMapper : NSObject
{
    NSMutableDictionary* cachedPropertyList;
    NSDictionary* types;
}
-(id) initWithTypes: (NSDictionary*) types;
-(void) objectFromDictionary: (NSDictionary*) dict object: (id) object;

@end

@interface ObjectMapper(private)

-(BOOL) set: (id) object property:(NSString*) property value:(id) value;
-(NSString*) getSetFunction: (NSString*) property;
-(NSDictionary*) getPropertiesOfClass:(Class) clazz;
-(NSString*) getTypeforArrayProperty: (id) object property: (NSString*) property;

//TODO: expose the following methods to users
-(void) arrayFromArray: (NSArray*) value object: (NSMutableArray*) outArray objectType: (NSString*) type;       // tested
-(void) dictionaryFromDictionary: (NSDictionary*) value object: (NSMutableDictionary*) outDict objectType: (NSString*) type; // not tested yet!
@end

@interface NSDictionary (ObjectMapper)
-(void) toObject:(id) object withTypes: (NSDictionary*) types;
@end
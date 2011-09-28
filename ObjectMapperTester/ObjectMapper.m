//
//  ObjectMapper.m
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

#import "ObjectMapper.h"

@implementation ObjectMapper

- (id)init 
{
    self = [super init];
    if (self) 
    {
        cachedPropertyList = [[NSMutableDictionary alloc]init];
    }
    return self;
}

-(id) initWithTypes: (NSDictionary*) _types
{
    self = [self init];
    if (self)
    {
        types = [_types retain];
    }
    return self;
}

-(void) objectFromDictionary: (NSDictionary*) dict object: (id) object
{
    NSString* objectId = [NSString stringWithFormat:@"%p", object];
    NSDictionary* propsDict = [cachedPropertyList objectForKey:objectId];
    
    if (propsDict == nil)
    {
        propsDict = [self getPropertiesOfClass:[object class]];
        [cachedPropertyList setValue:propsDict forKey:objectId];
    }
    
    for (id property in propsDict)
    {
        NSString* type = [propsDict objectForKey:property];
        id value = [dict objectForKey: property];
        
        if (value != nil && value != kCFNull/* For json null*/) 
        {
            if ( [NSClassFromString(type) isSubclassOfClass:[NSString class]] ||
                [NSClassFromString(type) isSubclassOfClass:[NSNumber class]] )
            {
                [self set:object property:property value:value];
            
            }else if([NSClassFromString(type) isSubclassOfClass:[NSDictionary class]])
            {
                NSUInteger count = [value count];
                NSMutableDictionary* instanceDict = [[NSMutableDictionary alloc]initWithCapacity:count];
                [object performSelector:NSSelectorFromString([self getSetFunction:property]) withObject:instanceDict];
                NSString* dictType = [self getTypeforArrayProperty:object property:property];
                [self dictionaryFromDictionary:value object:instanceDict objectType:dictType];
                [instanceDict release];
            }else if([NSClassFromString(type) isSubclassOfClass:[NSArray class]])
            {
                NSUInteger count = [value count];
                NSMutableArray* instanceArrr = [[NSMutableArray alloc]initWithCapacity:count];
                [object performSelector:NSSelectorFromString([self getSetFunction:property]) withObject:instanceArrr];
                NSString* arrayType = [self getTypeforArrayProperty:object property:property];
                [self arrayFromArray:value object:instanceArrr objectType:arrayType];
                [instanceArrr release];
            }else // custom type (user objects)
            {
                id custObj = [[NSClassFromString(type) alloc]init];
                [object performSelector:NSSelectorFromString([self getSetFunction:property]) withObject:custObj];
                [self objectFromDictionary:value object:custObj];
                [custObj release];
            }
        }
        
    }
}

- (void)dealloc {
    [cachedPropertyList release];
    [types release];
    [super dealloc];
}

@end

@implementation ObjectMapper(private)

static const char *getPropertyType(objc_property_t property);

-(void) arrayFromArray: (NSArray*) value object: (NSMutableArray*) outArray objectType: (NSString*) type
{
    NSUInteger count = [value count];
    
    if (count > 0)
    {     
        for (id currentValue in value) 
        {
            id newObj = [[NSClassFromString(type) alloc] init];
            [self objectFromDictionary:currentValue object:newObj];
            [outArray addObject:newObj];
            [newObj release];
        }
    }
}

-(void) dictionaryFromDictionary: (NSDictionary*) value object: (NSMutableDictionary*) outDict objectType: (NSString*) type
{
    NSUInteger count = [value count];
    
    if (count > 0)
    {   
        for (id property in value)
        {
            id newObj = [[NSClassFromString(type) alloc] init];
            id currentValue = [value objectForKey:property];
            [self objectFromDictionary:currentValue object:newObj];
            [outDict setObject:newObj forKey:property];
            [newObj release];
        }
    }
}

-(NSString*) getTypeforArrayProperty: (id) object property: (NSString*) property
{
    NSString* classProperty = [NSString stringWithFormat:@"%@.%@", [object class], property];
    
    NSString* type = [types objectForKey:classProperty];
    
    if (type)
        return type;
    else
    {
        type = [types objectForKey:property];
        if (type) 
            return type;
        else
        {
            NSLog(@"Fetal error: type not found for property: %@", classProperty);
            return nil;
        }
    }
}

-(BOOL) set: (id) object property:(NSString*) property value:(id) value
{
    NSString* setter = [self getSetFunction:property];
    SEL setterSelector = NSSelectorFromString(setter);
    
    if ( [object respondsToSelector:setterSelector] )
    {
        [object performSelector: setterSelector withObject: value];
        return YES;
    }else
    {
        NSLog(@"object of type %@ doesn't responds to selector %@", [object class], setter);
        return NO;
    }
}

-(NSString*) getSetFunction: (NSString*) property
{
    NSString* setName = [NSString stringWithFormat: @"%@%@", [[property substringWithRange:NSMakeRange(0, 1)] capitalizedString], 
                         [property substringFromIndex:1]];
    NSString* settterString = [NSString stringWithFormat:@"set%@:", setName];
    return  settterString;
}

/**
 * I am not the original auather of this method
 */
-(NSDictionary*) getPropertiesOfClass:(Class) clazz
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t* properties = class_copyPropertyList(clazz, &outCount);
    for(i = 0; i < outCount; i++)
    {
        objc_property_t _property = properties[i];
        const char *propName = property_getName(_property);
        if(propName) 
        {
            const char *propType = getPropertyType(_property);
            NSString *propertyName = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
            NSString *propertyType = [NSString stringWithCString:propType encoding:NSUTF8StringEncoding];
            [dict setValue:propertyType forKey:propertyName];
        }
    }
    free(properties);
    return dict;
}

/**
 * I am not the original auather of this method
 */
static const char *getPropertyType(objc_property_t property) 
{
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) 
    {
        if (attribute[0] == 'T') 
        {
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "@";
}

@end


@implementation NSDictionary (ObjectMapper)

-(void) toObject:(id) object withTypes: (NSDictionary*) types
{
    ObjectMapper* objectMapper = [[ObjectMapper alloc] initWithTypes:types];
    long double currTime = [[NSDate date] timeIntervalSince1970] * 1000 ;
    [objectMapper objectFromDictionary:self object:object];
    NSLog(@"parsing object %@ tooks %Lf ms", [object class], ([[NSDate date] timeIntervalSince1970] * 1000) - currTime);
    [objectMapper release];
}
@end




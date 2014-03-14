// NSManagedObject+ActiveRecord.m
//
// Copyright (c) 2014 Marin Usalj <http://mneorr.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "NSManagedObject+ActiveRecord.h"
#import "ObjectiveSugar.h"
#import "ObjectiveRelation.h"

@implementation NSManagedObjectContext (ActiveRecord)

+ (NSManagedObjectContext *)defaultContext {
    return [[CoreDataManager sharedManager] managedObjectContext];
}

@end

@implementation NSManagedObject (ActiveRecord)

#pragma mark - Fetch request building

+ (id)all {
    return [ObjectiveRelation relationWithManagedObjectClass:[self class]];
}

+ (id)where:(id)condition, ... {
    va_list va_arguments;
    va_start(va_arguments, condition);
    id relation = [[self all] where:condition arguments:va_arguments];
    va_end(va_arguments);

    return relation;
}

+ (id)order:(id)order {
    return [[self all] order:order];
}

+ (id)reverseOrder {
    return [[self all] reverseOrder];
}

+ (id)limit:(NSUInteger)limit {
    return [[self all] limit:limit];
}

+ (id)offset:(NSUInteger)offset {
    return [[self all] offset:offset];
}

+ (id)inContext:(NSManagedObjectContext *)context {
    return [[self all] inContext:context];
}

#pragma mark Counting

+ (NSUInteger)count {
    return [[self all] count];
}

#pragma mark Plucking

+ (instancetype)firstObject {
    return [[self all] firstObject];
}

+ (instancetype)lastObject {
    return [[self all] lastObject];
}

+ (instancetype)find:(id)condition, ... {
    va_list va_arguments;
    va_start(va_arguments, condition);
    id relation = [[self all] where:condition arguments:va_arguments];
    va_end(va_arguments);

    return [relation firstObject];
}

#pragma mark - Manipulating entities

+ (instancetype)findOrCreate:(NSDictionary *)properties {
    return [[self all] findOrCreate:properties];
}

+ (instancetype)create {
    return [[self all] create];
}

+ (instancetype)create:(NSDictionary *)attributes {
    return [[self all] create:attributes];
}

+ (void)updateAll:(NSDictionary *)attributes {
    [[self all] updateAll:attributes];
}

- (void)update:(NSDictionary *)attributes {
    if (attributes == nil || (id)attributes == [NSNull null]) return;

    for (id key in attributes) [self willChangeValueForKey:key];
    [attributes each:^(id key, id value) {
        id remoteKey = [self.class keyForRemoteKey:key];

        if ([remoteKey isKindOfClass:[NSString class]])
            [self setSafeValue:value forKey:remoteKey];
        else
            [self hydrateObject:value ofClass:remoteKey[@"class"] forKey:remoteKey[@"key"] ?: key];
    }];
    for (id key in attributes) [self didChangeValueForKey:key];
}

- (BOOL)save {
    return [self saveTheContext];
}

+ (void)deleteAll {
    [[self all] deleteAll];
}

- (void)delete {
    [self.managedObjectContext deleteObject:self];
}

#pragma mark - Naming

+ (NSString *)entityName {
    return NSStringFromClass(self);
}

#pragma mark - Private

- (BOOL)saveTheContext {
    if (![self.managedObjectContext hasChanges]) return YES;

    NSError *error = nil;
    BOOL save = [self.managedObjectContext save:&error];

    if (!save || error) {
        NSLog(@"Unresolved error in saving context for entity:\n%@!\nError: %@", self, error);
        return NO;
    }

    return YES;
}

- (void)hydrateObject:(id)properties ofClass:(Class)class forKey:(NSString *)key {
    [self setSafeValue:[self objectOrSetOfObjectsFromValue:properties ofClass:class]
                forKey:key];
}

- (id)objectOrSetOfObjectsFromValue:(id)value ofClass:(Class)class {
    if ([value isKindOfClass:[NSDictionary class]])
        return [[class inContext:self.managedObjectContext] findOrCreate:value];
    
    else if ([value isKindOfClass:[NSArray class]])
        return [NSSet setWithArray:[value map:^id(NSDictionary *dict) {
            return [[class inContext:self.managedObjectContext] findOrCreate:dict];
        }]];
    else
        return [[class inContext:self.managedObjectContext] findOrCreate:@{ [class primaryKey]: value }];
}

- (void)setSafeValue:(id)value forKey:(id)key {

    if (value == nil || value == [NSNull null]) {
        [self setPrimitiveValue:nil forKey:key];
        return;
    }

    NSDictionary *attributes = [[self entity] attributesByName];
    NSAttributeType attributeType = [attributes[key] attributeType];

    if ((attributeType == NSStringAttributeType) && ([value isKindOfClass:[NSNumber class]]))
        value = [value stringValue];

    else if ([value isKindOfClass:[NSString class]]) {

        if ([self isIntegerAttributeType:attributeType])
            value = [NSNumber numberWithInteger:[value integerValue]];

        else if (attributeType == NSBooleanAttributeType)
            value = [NSNumber numberWithBool:[value boolValue]];

        else if (attributeType == NSFloatAttributeType)
            value = [NSNumber numberWithDouble:[value doubleValue]];

        else if (attributeType == NSDateAttributeType) {
            static NSDateFormatter *dateFormatter;
            static dispatch_once_t singletonToken;
            dispatch_once(&singletonToken, ^{
                dateFormatter = [NSDateFormatter new];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss z"];
            });

            value = [dateFormatter dateFromString:value];
        }
    }

    [self setPrimitiveValue:value forKey:key];
}

- (BOOL)isIntegerAttributeType:(NSAttributeType)attributeType {
    return (attributeType == NSInteger16AttributeType) ||
           (attributeType == NSInteger32AttributeType) ||
           (attributeType == NSInteger64AttributeType);
}

@end

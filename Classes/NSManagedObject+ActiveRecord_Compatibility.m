// NSManagedObject+ActiveRecord_Compatibility.m
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

#import "NSManagedObject+ActiveRecord_Compatibility.h"
#import "NSManagedObject+ActiveRecord.h"
#import "ObjectiveRelation.h"

@implementation NSManagedObject (ActiveRecord_Compatibility)

#pragma mark - Default context

+ (NSArray *)allWithOrder:(id)order {
    return [[self order:order] fetchedObjects];
}

+ (NSArray *)where:(id)condition order:(id)order {
    return [[[self where:condition] order:order] fetchedObjects];
}

+ (NSArray *)where:(id)condition limit:(NSNumber *)limit {
    return [[[self where:condition] limit:[limit integerValue]] fetchedObjects];
}

+ (NSArray *)where:(id)condition order:(id)order limit:(NSNumber *)limit {
    return [[[[self where:condition] order:order] limit:[limit integerValue]] fetchedObjects];
}

+ (NSUInteger)countWhere:(id)condition, ... {
    va_list va_arguments;
    va_start(va_arguments, condition);
    id relation = [[self all] where:condition arguments:va_arguments];
    va_end(va_arguments);

    return [relation count];
}

+ (instancetype)first {
    return [[self all] firstObject];
}

+ (instancetype)last {
    return [[self all] lastObject];
}

#pragma mark - Custom context

+ (NSArray *)allInContext:(NSManagedObjectContext *)context {
    return [[self inContext:context] fetchedObjects];
}

+ (NSArray *)allInContext:(NSManagedObjectContext *)context order:(id)order {
    return [[[self inContext:context] order:order] fetchedObjects];
}

+ (NSArray *)where:(id)condition inContext:(NSManagedObjectContext *)context {
    return [[[self inContext:context] where:condition] fetchedObjects];
}

+ (NSArray *)where:(id)condition inContext:(NSManagedObjectContext *)context order:(id)order {
    return [[[[self inContext:context] where:condition] order:order] fetchedObjects];
}

+ (NSArray *)where:(id)condition inContext:(NSManagedObjectContext *)context limit:(NSNumber *)limit {
    return [[[[self inContext:context] where:condition] limit:[limit integerValue]] fetchedObjects];
}

+ (NSArray *)where:(id)condition inContext:(NSManagedObjectContext *)context order:(id)order limit:(NSNumber *)limit {
    return [[[[[self inContext:context] where:condition] order:order] limit:[limit integerValue]] fetchedObjects];
}

+ (NSUInteger)countInContext:(NSManagedObjectContext *)context {
    return [[self inContext:context] count];
}

+ (NSUInteger)countWhere:(id)condition inContext:(NSManagedObjectContext *)context {
    return [[[self inContext:context] where:condition] count];
}

+ (instancetype)findOrCreate:(NSDictionary *)properties inContext:(NSManagedObjectContext *)context {
    return [[self inContext:context] findOrCreate:properties];
}

+ (instancetype)find:(id)condition inContext:(NSManagedObjectContext *)context {
    return [[self inContext:context] find:condition];
}

+ (instancetype)createInContext:(NSManagedObjectContext *)context {
    return [[self inContext:context] create];
}

+ (instancetype)create:(NSDictionary *)attributes inContext:(NSManagedObjectContext *)context {
    return [[self inContext:context] create:attributes];
}

+ (void)deleteAllInContext:(NSManagedObjectContext *)context {
    [[self inContext:context] deleteAll];
}

@end

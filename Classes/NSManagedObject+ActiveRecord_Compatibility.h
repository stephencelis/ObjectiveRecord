// NSManagedObject+ActiveRecord_Compatibility.h
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

#import <CoreData/CoreData.h>

@interface NSManagedObject (ActiveRecord_Compatibility)

#pragma mark - Default context

+ (NSArray *)allWithOrder:(id)order __deprecated;
+ (NSArray *)where:(id)condition order:(id)order __deprecated;
+ (NSArray *)where:(id)condition limit:(NSNumber *)limit __deprecated;
+ (NSArray *)where:(id)condition order:(id)order limit:(NSNumber *)limit __deprecated;

+ (NSUInteger)countWhere:(id)condition, ... __deprecated;

+ (instancetype)first __deprecated;
+ (instancetype)last __deprecated;

#pragma mark - Custom context

+ (NSArray *)allInContext:(NSManagedObjectContext *)context __deprecated;
+ (NSArray *)allInContext:(NSManagedObjectContext *)context order:(id)order __deprecated ;
+ (NSArray *)where:(id)condition inContext:(NSManagedObjectContext *)context __deprecated;
+ (NSArray *)where:(id)condition inContext:(NSManagedObjectContext *)context order:(id)order __deprecated;
+ (NSArray *)where:(id)condition inContext:(NSManagedObjectContext *)context limit:(NSNumber *)limit __deprecated;
+ (NSArray *)where:(id)condition inContext:(NSManagedObjectContext *)context order:(id)order limit:(NSNumber *)limit __deprecated;

+ (NSUInteger)countInContext:(NSManagedObjectContext *)context __deprecated;
+ (NSUInteger)countWhere:(id)condition inContext:(NSManagedObjectContext *)context __deprecated;

+ (instancetype)findOrCreate:(NSDictionary *)properties inContext:(NSManagedObjectContext *)context __deprecated;
+ (instancetype)find:(id)condition inContext:(NSManagedObjectContext *)context __deprecated;
+ (instancetype)createInContext:(NSManagedObjectContext *)context __deprecated;
+ (instancetype)create:(NSDictionary *)attributes inContext:(NSManagedObjectContext *)context __deprecated;
+ (void)deleteAllInContext:(NSManagedObjectContext *)context __deprecated;

@end

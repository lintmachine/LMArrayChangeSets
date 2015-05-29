#import "NSArray+LMIndexChangeSets.h"

@implementation NSArray (IndexChangeSets)

+ (NSDictionary*) indexChangeSetsForUpdatedList:(NSArray*)updated
                                   previousList:(NSArray*)previous
                             identityComparator:(NSComparisonResult (^)(id a, id b))comparator
{
    NSIndexSet* deleted = [previous indexesOfObjectsPassingTest:^BOOL(id prev, NSUInteger idx, BOOL *stop) {
        if (updated == nil || [updated indexOfObjectPassingTest:^BOOL(id curr, NSUInteger idx, BOOL *stop) {
            return (comparator(curr, prev) == NSOrderedSame);
        }] == NSNotFound) {
            return YES;
        }
        return NO;
    }];
    
    NSIndexSet* inserted = [updated indexesOfObjectsPassingTest:^BOOL(id prev, NSUInteger idx, BOOL *stop) {
        if (previous == nil || [previous indexOfObjectPassingTest:^BOOL(id curr, NSUInteger idx, BOOL *stop) {
            return (comparator(curr, prev) == NSOrderedSame);
        }] == NSNotFound) {
            return YES;
        }
        return NO;
    }];
    
    NSMutableDictionary* moved = [NSMutableDictionary dictionary];
    NSMutableIndexSet* unmoved = [NSMutableIndexSet indexSet];
    [previous enumerateObjectsUsingBlock:^(id prev, NSUInteger prevIndex, BOOL *stop) {
        if (![deleted containsIndex:prevIndex]) {
            NSUInteger currIndex = [updated indexOfObjectPassingTest:^BOOL(id curr, NSUInteger idx, BOOL *stop) {
                return (comparator(curr, prev) == NSOrderedSame);
            }];
            
            if (currIndex != prevIndex && ![[moved allValues] containsObject:@(currIndex)]) {
                moved[@(prevIndex)] = @(currIndex);
            }
            else {
                [unmoved addIndex:currIndex];
            }
        }
    }];
    
    NSDictionary* indexChangeSets = @{
        @"deleted"  : deleted   ? deleted  : [NSIndexSet indexSet],
        @"inserted" : inserted  ? inserted : [NSIndexSet indexSet],
        @"moved"    : moved,
        @"unmoved"  : unmoved
    };
    
    return indexChangeSets;
}

@end

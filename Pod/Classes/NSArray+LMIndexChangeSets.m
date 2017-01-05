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
  
  NSMutableArray* previousAfterDeletion = [previous mutableCopy];
  [previousAfterDeletion removeObjectsAtIndexes:deleted];
  
  NSIndexSet* inserted = [updated indexesOfObjectsPassingTest:^BOOL(id prev, NSUInteger idx, BOOL *stop) {
    if (previous == nil || [previous indexOfObjectPassingTest:^BOOL(id curr, NSUInteger idx, BOOL *stop) {
      return (comparator(curr, prev) == NSOrderedSame);
    }] == NSNotFound) {
      return YES;
    }
    return NO;
  }];
  
  NSMutableArray* updatedBeforeInsertion = [updated mutableCopy];
  [updatedBeforeInsertion removeObjectsAtIndexes:inserted];
  
  NSMutableDictionary* moved = [NSMutableDictionary dictionary];
  NSMutableIndexSet* unmoved = [NSMutableIndexSet indexSet];
  [previous enumerateObjectsUsingBlock:^(id prev, NSUInteger prevIndex, BOOL *stop) {
    if (![deleted containsIndex:prevIndex]) {
      NSUInteger currIndex = [updated indexOfObjectPassingTest:^BOOL(id curr, NSUInteger idx, BOOL *stop) {
        return (comparator(curr, prev) == NSOrderedSame);
      }];
      
      int prevAfterDeleteIndex = (int)[previousAfterDeletion indexOfObjectPassingTest:^BOOL(id curr, NSUInteger idx, BOOL *stop) {
        return (comparator(curr, prev) == NSOrderedSame);
      }];
      int updateBeforeInsertIndex = (int)[updatedBeforeInsertion indexOfObjectPassingTest:^BOOL(id curr, NSUInteger idx, BOOL *stop) {
        return (comparator(curr, updated[currIndex]) == NSOrderedSame);
      }];
      
      if (updateBeforeInsertIndex != prevAfterDeleteIndex && ![[moved allValues] containsObject:@(currIndex)]) {
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
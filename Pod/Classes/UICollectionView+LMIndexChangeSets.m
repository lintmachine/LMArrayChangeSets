#import "UICollectionView+LMIndexChangeSets.h"

@implementation UICollectionView (LMIndexChangeSets)

- (void) updateSection:(NSInteger)section
         withChangeSet:(NSDictionary*)indexChangeSet
{
    [self updateSection:section withChangeSet:indexChangeSet reloadingUnmoved:NO];
}

- (void) updateSection:(NSInteger)section
         withChangeSet:(NSDictionary*)indexChangeSet
      reloadingUnmoved:(BOOL)reloading
{
    [indexChangeSet[@"deleted"] enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [self deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:idx inSection:section]]];
    }];
    
    [indexChangeSet[@"inserted"] enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [self insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:idx inSection:section]]];
    }];
    
    [indexChangeSet[@"moved"] enumerateKeysAndObjectsUsingBlock:^(NSNumber* fromIndex, NSNumber* toIndex, BOOL *stop) {
        [self moveItemAtIndexPath:[NSIndexPath indexPathForItem:[fromIndex integerValue] inSection:section]
                                     toIndexPath:[NSIndexPath indexPathForItem:[toIndex integerValue] inSection:section]];
    }];
    
    if (reloading) {
        [indexChangeSet[@"unmoved"] enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            [self reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:idx inSection:section]]];
        }];
    }
}

@end

#import <UIKit/UIKit.h>

@interface UICollectionView (LMIndexChangeSets)

- (void) updateSection:(NSInteger)section
         withChangeSet:(NSDictionary*)indexChangeSet;

- (void) updateSection:(NSInteger)section
         withChangeSet:(NSDictionary*)indexChangeSet
      reloadingUnmoved:(BOOL)reloading;

@end

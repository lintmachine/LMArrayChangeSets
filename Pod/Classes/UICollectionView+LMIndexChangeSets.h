#import <UIKit/UIKit.h>

@interface UICollectionView (LMIndexChangeSets)

- (void) updateSection:(NSInteger)section
         withChangeSet:(NSDictionary*)indexChangeSet;

@end

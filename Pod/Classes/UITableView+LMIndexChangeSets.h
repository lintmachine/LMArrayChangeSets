#import <UIKit/UIKit.h>

@interface UITableView (LMIndexChangeSets)

- (void) updateSection:(NSInteger)section
         withChangeSet:(NSDictionary*)indexChangeSet;

- (void) updateSection:(NSInteger)section
         withChangeSet:(NSDictionary*)indexChangeSet
      reloadingUnmoved:(BOOL)reloading;

@end

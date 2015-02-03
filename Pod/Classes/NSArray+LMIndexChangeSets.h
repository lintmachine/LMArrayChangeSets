#import <Foundation/Foundation.h>

@interface NSArray (LMIndexChangeSets)

+ (NSDictionary*) indexChangeSetsForUpdatedList:(NSArray*)updated
                                   previousList:(NSArray*)previous
                             identityComparator:(NSComparisonResult (^)(id a, id b))comparator;
@end

# LMArrayChangeSets

[![CI Status](http://img.shields.io/travis/cdann/LMArrayChangeSets.svg?style=flat)](https://travis-ci.org/cdann/LMArrayChangeSets)
[![Version](https://img.shields.io/cocoapods/v/LMArrayChangeSets.svg?style=flat)](http://cocoadocs.org/docsets/LMArrayChangeSets)
[![License](https://img.shields.io/cocoapods/l/LMArrayChangeSets.svg?style=flat)](http://cocoadocs.org/docsets/LMArrayChangeSets)
[![Platform](https://img.shields.io/cocoapods/p/LMArrayChangeSets.svg?style=flat)](http://cocoadocs.org/docsets/LMArrayChangeSets)

## Usage

This is a set of simple categories that help with a common pattern I use for updating array-backed UITableViews and UICollectionViews.

It extends NSArray to provide simple diff functionality. You provide the initial array, the updated array, and an identity comparison block, and the method returns an NSDictionary of NSIndexSets with the inserted, deleted, moved and unmoved indexes.

Categories are provided for UITableView and UICollectionView that take the IndexSet dictionary and perform the updates as a batch with row/cell animation. Items that have not moved from their initial position may optionally be reloaded.

### Objective-C Examples

#### UICollectionView

```objectivec
- (void)updateWithItems:(NSArray *)items {
    
    NSDictionary* indexChangeSets = [NSArray indexChangeSetsForUpdatedList:items
                                                              previousList:self.items
                                                        identityComparator:^NSComparisonResult(NSDictionary* a, NSDictionary* b) {
                                                            // This block should determine if the items in the list have the same identity or not
                                                            return [a[@"id"] compare:b[@"id"]];
                                                        }];
    

    
    [self.collectionView performBatchUpdates:^{
        self.items = items;
        [self.collectionView updateSection:0 withChangeSet:indexChangeSets reloadingUnmoved:YES];
    } completion:nil];
}
```

#### UITableView

```objectivec
- (void)updateWithItems:(NSArray *)items {
    
    NSDictionary* indexChangeSets = [NSArray indexChangeSetsForUpdatedList:items
                                                              previousList:self.items
                                                        identityComparator:^NSComparisonResult(NSDictionary* a, NSDictionary* b) {
                                                            // This block should determine if the items in the list have the same identity or not
                                                            return [a[@"id"] compare:b[@"id"]];
                                                        }];
    self.items = items;
    [self.tableView beginUpdates];
    [self.tableView updateSection:0 withChangeSet:indexChangeSets];
    [self.tableView endUpdates];
}
```

### Swift Examples

_Note:_ To use this library in Swift, you must import the library header file into your project's Bridging Header file.

    #import "LMArrayChangeSets.h"

More details about mixing Objective-C and Swift code are available [here](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html).


#### UICollectionView

```swift
func updateWithItems(items:NSArray) {

    let indexChanges = NSArray.indexChangeSetsForUpdatedList(items, previousList: self.items) {
            (anyA:AnyObject!, anyB:AnyObject!) -> NSComparisonResult in
            let a = anyA as MyObject
            let b = anyB as MyObject
            // This should determine if the items have the same identity or not
            return a.id.compare(b.id)
    }
    
    self.collectionView!.performBatchUpdates({
        () -> Void in
        self.items = items
        self.collectionView!.updateSection(0, withChangeSet:indexChanges)
        },
        completion:nil
    )
}
```

#### UITableView

```swift
func updateWithItems(items:NSArray) {

    let indexChanges = NSArray.indexChangeSetsForUpdatedList(items, previousList: self.items) {
            (anyA:AnyObject!, anyB:AnyObject!) -> NSComparisonResult in
            let a = anyA as MyObject
            let b = anyB as MyObject
            // This should determine if the items have the same identity or not
            return a.id.compare(b.id)
    }

    self.items = items
    self.tableView!.beginUpdates()
    self.tableView!.updateSection(0, withChangeSet:indexChanges, reloadingUnmoved:true)
    self.tableView!.endUpdates()
}
```

## Performance

*Please Note:* The algorithm used to determine the change sets is not particularly efficient. O(N^2)

The library was created with developer efficiency in mind, rather than raw performance. As such, it may not perform well with large data sets. 

In my experience, the performance has been perfectly acceptable for data sets with counts in the hundreds. If you plan to use this with larger data sets, you'll want to do some performance testing first and optimize your comparison routine.

I recommend generating the change sets on a background thread.

## Requirements

iOS 6.0+

## Installation

LMArrayChangeSets is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "LMArrayChangeSets"

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Author

cdann, cdann@lintmachine.com

## License

LMArrayChangeSets is available under the MIT license. See the LICENSE file for more info.


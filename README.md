# LMArrayChangeSets

[![CI Status](http://img.shields.io/travis/cdann/LMArrayChangeSets.svg?style=flat)](https://travis-ci.org/cdann/LMArrayChangeSets)
[![Version](https://img.shields.io/cocoapods/v/LMArrayChangeSets.svg?style=flat)](http://cocoadocs.org/docsets/LMArrayChangeSets)
[![License](https://img.shields.io/cocoapods/l/LMArrayChangeSets.svg?style=flat)](http://cocoadocs.org/docsets/LMArrayChangeSets)
[![Platform](https://img.shields.io/cocoapods/p/LMArrayChangeSets.svg?style=flat)](http://cocoadocs.org/docsets/LMArrayChangeSets)

## Usage

This is a set of simple categories that help with a common pattern I use for updating array-backed UITableViews and UICollectionViews.

It extends NSArray to provide simple diff functionality. You provide the initial array, the updated array, and an identity comparison block, and the method returns an NSDictionary of NSIndexSets with the inserted, deleted and moved indexes.

Categories are provided for UITableView and UICollectionView that take the IndexSet dictionary and perform the updates as a batch with row/cell animation.

### UICollectionView example

    - (void)updateWithItems:(NSArray *)items {
        
        NSDictionary* indexChangeSets = [NSArray indexChangeSetsForUpdatedList:items
                                                                  previousList:self.items
                                                            identityComparator:^NSComparisonResult(NSDictionary* a, NSDictionary* b) {
                                                                // This block should determine if the items in the list have the same identity or not
                                                                return [a[@"id"] compare:b[@"id"]];
                                                            }];
        

        
        [self.collectionView performBatchUpdates:^{
            self.items = items;
            [self.collectionView updateSection:0 withChangeSet:indexChangeSets];
        } completion:nil];
    }

### UITableView example

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

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 6.0+

## Installation

LMArrayChangeSets is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "LMArrayChangeSets"

## Author

cdann, cdann@lintmachine.com

## License

LMArrayChangeSets is available under the MIT license. See the LICENSE file for more info.


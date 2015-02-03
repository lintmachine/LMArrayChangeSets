//
//  LMTableViewController.m
//  LMArrayChangeSets
//
//  Created by cdann on 2/2/15.
//  Copyright (c) 2015 cdann. All rights reserved.
//

#import "LMTableViewController.h"
#import "LMArrayChangeSets.h"

static const NSInteger initialItemCount = 20;
static NSInteger totalItems = initialItemCount;

@interface LMTableViewController()
@property (nonatomic,strong) NSArray* items;
@end

@implementation LMTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateWithItems:[self initialItems]];
}

- (NSArray *)items {
    if (_items == nil) {
        _items = @[];
    }
    
    return _items;
}

- (NSArray*) initialItems {
    NSMutableArray* initialItems = [NSMutableArray arrayWithCapacity:initialItemCount];
    for (NSInteger i = 0; i < initialItemCount; ++i) {
        [initialItems addObject:@{@"id":@(i)}];
    }
    return initialItems;
}

- (IBAction) randomize {
    
    NSMutableArray* mutableItems = [self.items mutableCopy];
    
    // Remove some items
    NSInteger deleteCount =  arc4random() % (mutableItems.count / 4);
    for (NSInteger i = 0; i < deleteCount; ++i) {
        NSInteger index =  arc4random() % mutableItems.count;
        [mutableItems removeObjectAtIndex:index];
    }

    NSInteger insertCount =  arc4random() % (mutableItems.count / 4);
    for (NSInteger i = 0; i < insertCount; ++i) {
        NSInteger index =  arc4random() % mutableItems.count;
        [mutableItems insertObject:@{@"id":@(totalItems++)} atIndex:index];
    }

    NSInteger swapCount =  arc4random() % (mutableItems.count / 4);
    for (NSInteger i = 0; i < swapCount; ++i) {
        NSInteger indexA =  arc4random() % mutableItems.count;
        NSInteger indexB =  arc4random() % mutableItems.count;
        [mutableItems exchangeObjectAtIndex:indexA withObjectAtIndex:indexB];
    }
    
    [self updateWithItems:mutableItems];
}

- (IBAction) sort {
    
    [self updateWithItems:[self.items sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1[@"id"] compare:obj2[@"id"]];
    }]];
}

- (IBAction) reset {
    
    [self updateWithItems:[self initialItems]];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.items[indexPath.item][@"id"] stringValue]];
    return cell;
}

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

@end

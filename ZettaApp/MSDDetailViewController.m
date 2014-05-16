//
//  MSDDetailViewController.m
//  ZettaApp
//
//  Created by Matthew Dobson on 5/6/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import "MSDDetailViewController.h"
#import "MSDZettaActionCell.h"
#import "MSDComplexTransitionViewController.h"
#import "ZettaKit/ZettaTransition.h"
#import "ZettaKit/ZettaEventSubscription.h"
#import "ZettaKit/ZettaTransitionField.h"

@interface MSDDetailViewController ()

@property (nonatomic, retain) NSMutableDictionary *forms;
@property BOOL firstValue;
@property float prev;

@property float high;
@property float low;

@property BOOL streaming;

@end

@implementation MSDDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }
}

-(void)subscribeToWebsocket:(NSInteger)sub andUpdateCell:(MSDZettaActionCell *)cell {
    ZettaEventSubscription *subscription = self.detailItem.subscriptions[sub];
    NSString *labelText = cell.actionLabel.text;
    [cell.sparkline clearBaseline];
    self.firstValue = YES;
    [subscription performSubscriptionWithStreamHandler:^(NSString *message) {
        self.streaming = YES;
        NSLog(@"Message:%@", message);
        NSDictionary * jsonData = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        cell.actionLabel.text = [NSString stringWithFormat:@"%@:%@", labelText, [jsonData objectForKey:@"data"]];
        float val = [jsonData[@"data"] floatValue];
        
        if (self.low > val) {
            self.low = val;
            [cell.sparkline setLowerLimit:val];
        }
        
        if (self.high < val) {
            self.high = val;
            [cell.sparkline setUpperLimit:val];
        }
        
        cell.sparkline.value = val;
        
    }];
}

-(void)performTransition:(NSInteger)tran {
    ZettaTransition *transition = self.detailItem.transitions[tran];
    if (transition.fields.count > 1) {
        NSDictionary *fields = [self.forms objectForKey:transition];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        for (NSString *field in fields) {
            UITextField *f = (UITextField*)[fields objectForKey:field];
            [params setValue:f.text forKey:field];
        }
        NSLog(@"%@", params);
        [transition performTransitionWithParameters:params andBlock:^(NSError * error) {
            if (error) {
                NSLog(@"Error: %@", error);
            } else {
                NSLog(@"Transition: %@", transition);
            }
        }];
    } else {
        [transition performTransitionWithBlock:^(NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error);
            } else {
                NSLog(@"Transition: %@", transition);
            }
        }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.low = 0.0f;
    self.high = 0.0f;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.detailItem.subscriptions.count;
    } else if (section == 1) {
        return self.detailItem.transitions.count;
    } else {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MSDZettaActionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TransitionCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        ZettaEventSubscription *e = self.detailItem.subscriptions[indexPath.row];
        NSArray *components = [e.name componentsSeparatedByString:@"-"];
        NSLog(@"%@", [components objectAtIndex:1]);
        cell.actionLabel.text = [components objectAtIndex:1];
    } else if(indexPath.section == 1) {
        ZettaTransition *t = self.detailItem.transitions[indexPath.row];
        NSLog(@"%@", t.name);
        cell.actionLabel.text = t.name;
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MSDZettaActionCell *cell = (MSDZettaActionCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [self subscribeToWebsocket:indexPath.row andUpdateCell:cell];
    } else if (indexPath.section == 1) {
        ZettaTransition *t = self.detailItem.transitions[indexPath.row];
        if (t.fields.count > 1) {
            [self performSegueWithIdentifier:@"StateTransition" sender:self];
        } else {
            [self performTransition:indexPath.row];
        }
    }
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(300, 80);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"StateTransition"]) {
        NSIndexPath *indexPath = [self.collectionView indexPathsForSelectedItems][0];
        ZettaTransition *transition = self.detailItem.transitions[indexPath.row];
        [(MSDComplexTransitionViewController *)[segue destinationViewController] setZettaTransition:transition];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.streaming) {
        for (ZettaEventSubscription *sub in self.detailItem.subscriptions) {
            if (sub.streaming) {
                [sub close];
            }
        }
    }
    
}
@end

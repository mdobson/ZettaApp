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
    self.firstValue = YES;
    [subscription performSubscriptionWithStreamHandler:^(NSString *message) {
        NSLog(@"Message:%@", message);
        NSDictionary * jsonData = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        cell.actionLabel.text = [NSString stringWithFormat:@"%@:%@", labelText, [jsonData objectForKey:@"data"]];
        float val = [jsonData[@"data"] floatValue];
        if (val > 99000.00f) {
            cell.sparkline.value = val - 99000.00f;
        } else {
            cell.sparkline.value = val;
        }
        [cell.sparkline clearBaseline];
        /*if (self.firstValue == YES) {
            float base = [jsonData[@"data"] floatValue];
            cell.sparkline.baselineValue = base;
            [cell.sparkline setUpperLimit:base + 100.00f];
            [cell.sparkline setLowerLimit:base - 100.00f];
            self.firstValue = NO;
            
        }*/
        
        
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
    
	// Do any additional setup after loading the view, typically from a nib.
    /*if (self.detailItem) {
        self.navigationItem.title = self.detailItem.name;
        if (self.detailItem.subscriptions) {
            //place ui button for subscription
            [self.detailItem.subscriptions enumerateObjectsUsingBlock:^(ZettaEventSubscription * obj, NSUInteger idx, BOOL *stop) {
                UIButton *subscribe = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [subscribe setFrame:CGRectMake(50, 60 + (idx * 100), 200, 40)];
                subscribe.tag = idx;
                NSArray *components = [obj.name componentsSeparatedByString:@"-"];
                [subscribe setTitle:[components objectAtIndex:1] forState:UIControlStateNormal];
                [subscribe addTarget:self action:@selector(subscribeToWebsocket:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:subscribe];
            }];
        }
        
        if (self.detailItem.transitions) {
            self.forms = [[NSMutableDictionary alloc] init];
            [self.detailItem.transitions enumerateObjectsUsingBlock:^(ZettaTransition * obj, NSUInteger idx, BOOL *stop) {
                UIView *formView = [[UIView alloc] initWithFrame:CGRectMake(160, 60 + (idx * 35), 200, 50 * obj.fields.count)];
                
                [self.forms setObject:[[NSMutableDictionary alloc] init] forKey:obj.name];
                NSMutableDictionary *form = [self.forms objectForKey:obj.name];
                
                [obj.fields enumerateObjectsUsingBlock:^(ZettaTransitionField * field, NSUInteger fidx, BOOL *fstop) {
                    if (field.type == ZettaHidden) {
                        UIButton *transition = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        [transition setFrame:CGRectMake(0, 0 + (fidx * 35), 200, 40)];
                        [transition setTitle:obj.name forState:UIControlStateNormal];
                        [transition addTarget:self action:@selector(performTransition:) forControlEvents:UIControlEventTouchUpInside];
                        [formView addSubview:transition];
                    } else {
                        UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(0, 0 + (fidx * 35), 200, 40)];
                        text.layer.borderWidth = 0.5f;
                        text.layer.borderColor = [[UIColor blueColor] CGColor];
                        [form setValue:text forKey:field.name];
                        [formView addSubview:text];
                    }
                }];
                [self.view addSubview:formView];
            }];

        }
    }*/
    
    //[self.collectionView registerClass:[MSDZettaActionCell class] forCellWithReuseIdentifier:@"TransitionCell"];
    
    //[self.collectionView reloadData];

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

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

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

@end

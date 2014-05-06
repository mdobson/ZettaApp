//
//  MSDDetailViewController.m
//  ZettaApp
//
//  Created by Matthew Dobson on 5/6/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import "MSDDetailViewController.h"

@interface MSDDetailViewController ()
- (void)configureView;
@end

@implementation MSDDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }
}

-(void)subscribeToWebsocket:(UIButton *)sender {
    NSString *subscription = sender.titleLabel.text;
    [self.detailItem performSubscription:subscription withStreamHandler:^(NSString *message) {
        NSLog(@"Message:%@", message);
    }];
}

-(void)performTransition:(UIButton *)sender {
    NSString *transition = sender.titleLabel.text;
    [self.detailItem performTransition:transition andBlock:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Transition: %@", transition);
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if (self.detailItem) {
        self.navigationItem.title = self.detailItem.name;
        if (self.detailItem.subscriptions) {
            //place ui button for subscription
            [self.detailItem.subscriptions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                UIButton *subscribe = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [subscribe setFrame:CGRectMake(50, 130 + (idx * 100), 200, 40)];
                [subscribe setTitle:obj forState:UIControlStateNormal];
                [subscribe addTarget:self action:@selector(subscribeToWebsocket:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:subscribe];
            }];
        }
        
        if (self.detailItem.transitions) {
            [self.detailItem.transitions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                UIButton *transition = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [transition setFrame:CGRectMake(150, 130 + (idx * 100), 200, 40)];
                [transition setTitle:obj forState:UIControlStateNormal];
                [transition addTarget:self action:@selector(performTransition:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:transition];
            }];

        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

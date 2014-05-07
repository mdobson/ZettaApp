//
//  MSDDetailViewController.m
//  ZettaApp
//
//  Created by Matthew Dobson on 5/6/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import "MSDDetailViewController.h"
#import "ZettaKit/ZettaTransition.h"
#import "ZettaKit/ZettaEventSubscription.h"

@interface MSDDetailViewController ()
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
    ZettaEventSubscription *subscription = self.detailItem.subscriptions[sender.tag];
    [subscription performSubscriptionWithStreamHandler:^(NSString *message) {
        NSLog(@"Message:%@", message);
        NSDictionary * jsonData = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        sender.titleLabel.text = [NSString stringWithFormat:@"%@", [jsonData objectForKey:@"data"]];
    }];
}

-(void)performTransition:(UIButton *)sender {
    NSString *transition = sender.titleLabel.text;
    ZettaTransition *tran = [self.detailItem getTransition:transition];
    [tran performTransition:transition andBlock:^(NSError *error) {
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
            [self.detailItem.transitions enumerateObjectsUsingBlock:^(ZettaTransition * obj, NSUInteger idx, BOOL *stop) {
                UIButton *transition = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [transition setFrame:CGRectMake(130, 60 + (idx * 35), 200, 40)];
                [transition setTitle:obj.name forState:UIControlStateNormal];
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

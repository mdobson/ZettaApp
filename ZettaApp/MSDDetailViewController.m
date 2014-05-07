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
#import "ZettaKit/ZettaTransitionField.h"

@interface MSDDetailViewController ()

@property (nonatomic, retain) NSMutableDictionary *forms;

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
    if (tran.fields.count > 1) {
        NSDictionary *fields = [self.forms objectForKey:transition];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        for (NSString *field in fields) {
            UITextField *f = (UITextField*)[fields objectForKey:field];
            [params setValue:f.text forKey:field];
        }
        NSLog(@"%@", params);
        [tran performTransitionWithParameters:params andBlock:^(NSError * error) {
            if (error) {
                NSLog(@"Error: %@", error);
            } else {
                NSLog(@"Transition: %@", transition);
            }
        }];
    } else {
        [tran performTransitionWithBlock:^(NSError *error) {
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
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

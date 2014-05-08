//
//  MSDComplexTransitionViewController.m
//  ZettaApp
//
//  Created by Matthew Dobson on 5/7/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import "MSDComplexTransitionViewController.h"
#import "ZettaKit/ZettaTransitionField.h"

@interface MSDComplexTransitionViewController ()

@property (nonatomic, retain) NSMutableArray *fields;

@end

@implementation MSDComplexTransitionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setZettaTransition:(ZettaTransition *)transition {
    self.transition = transition;
}

-(void) performTransition:(UIButton *) sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (UITextField *field in self.fields) {
        ZettaTransitionField * f = self.transition.fields[field.tag];
        [params setValue:field.text forKey:f.name];
    }
    NSLog(@"%@", params);
    [self.transition performTransitionWithParameters:params andBlock:^(NSError * error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Transition: %@", self.transition.name);
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.transition.name;
    self.fields = [[NSMutableArray alloc] init];
    
    
    UIView *formView = [[UIView alloc] initWithFrame:CGRectMake(20, 80, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self.transition.fields enumerateObjectsUsingBlock:^(ZettaTransitionField *field, NSUInteger fidx, BOOL *stop) {
        if (field.type == ZettaHidden) {
            UIButton *transition = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [transition setFrame:CGRectMake(0, 0 + (fidx * 35), 200, 40)];
            [transition setTitle:self.transition.name forState:UIControlStateNormal];
            [transition addTarget:self action:@selector(performTransition:) forControlEvents:UIControlEventTouchUpInside];
            [formView addSubview:transition];
        } else {
            UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(0, 0 + (fidx * 35), 200, 40)];
            text.layer.borderWidth = 0.5f;
            text.layer.borderColor = [[UIColor blueColor] CGColor];
            text.tag = fidx;
            [self.fields addObject:text];
            [formView addSubview:text];
        }
    }];
    [self.view addSubview:formView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

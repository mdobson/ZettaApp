//
//  MSDComplexTransitionViewController.h
//  ZettaApp
//
//  Created by Matthew Dobson on 5/7/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZettaKit/ZettaTransition.h"


@interface MSDComplexTransitionViewController : UIViewController

@property (nonatomic, retain) ZettaTransition *transition;

-(void) setZettaTransition:(ZettaTransition*) transition;

@end

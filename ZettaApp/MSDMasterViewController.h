//
//  MSDMasterViewController.h
//  ZettaApp
//
//  Created by Matthew Dobson on 5/6/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZettaKit/ZettaApp.h"

@interface MSDMasterViewController : UITableViewController<ZettaDelegate>

@property (nonatomic, retain) ZettaApp *app;

@end

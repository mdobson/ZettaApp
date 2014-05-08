//
//  MSDZettaActionCell.h
//  ZettaApp
//
//  Created by Matthew Dobson on 5/7/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "F3PlotStrip.h"

@interface MSDZettaActionCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UILabel *actionLabel;
@property (nonatomic, retain) IBOutlet F3PlotStrip *sparkline;

@end

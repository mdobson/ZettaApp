//
//  MSDZettaActionCell.m
//  ZettaApp
//
//  Created by Matthew Dobson on 5/7/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import "MSDZettaActionCell.h"

@implementation MSDZettaActionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.sparkline = [[F3PlotStrip alloc] init];
        self.sparkline.capacity = 300;
        self.sparkline.baselineValue = 0.0;
        self.sparkline.lineColor = [UIColor redColor];
        self.sparkline.showDot = NO;
    }
    return self;
}

-(IBAction)pushed:(id)sender {
    NSLog(@"Pushed");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

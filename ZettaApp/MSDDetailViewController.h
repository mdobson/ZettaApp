//
//  MSDDetailViewController.h
//  ZettaApp
//
//  Created by Matthew Dobson on 5/6/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZettaKit/ZettaMachine.h"
#import "F3PlotStrip.h"

@interface MSDDetailViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) ZettaMachine * detailItem;

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end

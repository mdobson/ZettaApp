//
//  MSDAppDelegate.h
//  ZettaApp
//
//  Created by Matthew Dobson on 5/6/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ApigeeiOSSDK/Apigee.h>

@interface MSDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ApigeeClient *client;
@property (strong, nonatomic) ApigeeMonitoringClient *monitoring;
@property (strong, nonatomic) ApigeeDataClient *data;

@end

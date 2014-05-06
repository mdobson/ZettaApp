//
//  MSDMasterViewController.m
//  ZettaApp
//
//  Created by Matthew Dobson on 5/6/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import "MSDMasterViewController.h"

#import "MSDDetailViewController.h"

#import "ZettaKit/ZettaApp.h"
#import "ZettaKit/ZettaMachine.h"

NSString *const AppEndpoint = @"http://zetta-cloud.herokuapp.com/hello";

@interface MSDMasterViewController () {
}
@end

@implementation MSDMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.app = [[ZettaApp alloc] initWithAppString:AppEndpoint];
    self.app.delegate = self;
}

-(void)didReceiveNewDevice:(ZettaMachine *)machine {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.app.machines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    ZettaMachine *machine = self.app.machines[indexPath.row];
    cell.textLabel.text = machine.name;
    return cell;
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ZettaMachine *machine = self.app.machines[indexPath.row];
        [[segue destinationViewController] setDetailItem:machine];
    }
}

@end

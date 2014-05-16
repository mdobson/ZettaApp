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

NSString *const AppEndpoint = @"http://zetta-cloud.herokuapp.com/mini-factory-detroit";

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
    
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    cell.textLabel.textColor = [UIColor colorWithRed:51./255.
                                               green:153./255.
                                                blue:204./255.
                                               alpha:1.0];
    
    ZettaMachine *machine = self.app.machines[indexPath.row];
    cell.textLabel.text = machine.name;
    cell.detailTextLabel.text = machine.state;
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70.0;
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

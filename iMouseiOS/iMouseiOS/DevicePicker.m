//
//  DevicePicker.m
//  iMouseiOS
//
//  Created by Will Cobb on 1/22/15.
//  Copyright (c) 2015 Apprentice Media LLC. All rights reserved.
//

#import "DevicePicker.h"

@implementation DevicePicker


- (void)viewDidLoad
{
    [super viewDidLoad];
    _bSocket = [[BonjourHandler alloc] init];
    _bSocket.delegate = self;
    [_bSocket start];
    [self setUpRechability];
}

-(void) viewDidAppear:(BOOL)animated
{
    _bSocket.delegate = self;
}

- (void)connectionEstablished
{
    [self performSegueWithIdentifier:@"RootToPad" sender:self];
}

-(void) connectionDisconnected
{
    UIViewController *prevVC = [self.navigationController.viewControllers objectAtIndex:0];
    [self.navigationController popToViewController:prevVC animated:YES];
}

-(void)updatedServices:(NSMutableArray *)services
{
    [self sortAndReloadTable];
}

#pragma mark * Table view callbacks

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger) [self.bSocket.services count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *	cell;
    NSNetService *      service;

    service = [self.bSocket.services objectAtIndex:(NSUInteger) indexPath.row];

    cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];

    cell.textLabel.text = service.name;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNetService *      service;

    #pragma unused(tableView)
    #pragma unused(indexPath)

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    // Find the service associated with the cell and start a connection to that.
    
    service = [self.bSocket.services objectAtIndex:(NSUInteger) indexPath.row];
    [_bSocket connectToService:service];
}

#pragma mark * Browser view callbacks

- (void)sortAndReloadTable
{
    // Sort the services by name.

    [self.bSocket.services sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 name] localizedCaseInsensitiveCompare:[obj2 name]];
    }];
    
    // Reload if the view is loaded.
    
    if (self.isViewLoaded) {
        [self.tableView reloadData];
    }
}


-(void)setUpRechability
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];

    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];

    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    if (remoteHostStatus == ReachableViaWiFi ) {
        NSLog(@"On WiFi");
        //[_bSocket start];
    } else {
        NSLog(@"No Wifi");
        //[_bSocket stop];
    }

}

- (void) handleNetworkChange:(NSNotification *)notice
{
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    if (remoteHostStatus == ReachableViaWiFi ) {
        NSLog(@"On WiFi");
        //[_bSocket start];
    } else {
        NSLog(@"No Wifi");
        //[_bSocket stop];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"RootToPad"]) {
        TouchPadViewController *vc = [segue destinationViewController];
        vc.bSocket = self.bSocket;
    } else if ([[segue identifier] isEqualToString:@"RootToMouse"]) {
        MouseViewController *vc = [segue destinationViewController];
        vc.bSocket = self.bSocket;
    }
    
}


- (void)dealloc
{
    
}



@end

//
//  DevicePicker.h
//  iMouseiOS
//
//  Created by Will Cobb on 1/22/15.
//  Copyright (c) 2015 Apprentice Media LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BonjourHandler.h"
#import "TouchPadViewController.h"
#import "MouseViewController.h"
@interface DevicePicker : UITableViewController <BonjourDelegate> {
    Reachability * reachability;
}

@property BonjourHandler * bSocket;

@end

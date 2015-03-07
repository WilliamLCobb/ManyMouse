//
//  TouchPadViewController.h
//  iMouseiOS
//
//  Created by Will Cobb on 1/21/15.
//  Copyright (c) 2015 Apprentice Media LLC. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "UDPClient.h"
#import "BonjourHandler.h"
#import "Reachability.h"
@interface TouchPadViewController : UIViewController <BonjourDelegate> {

    CGFloat lastSend;
    NSString * buffer;
    Reachability* reachability;
}

@property BonjourHandler * bSocket;
@property CGPoint lastTouch;

@property CGPoint firstTouch;
@property CGFloat firstTouchTime;

@end

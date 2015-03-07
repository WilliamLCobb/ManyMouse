//
//  MouseViewController.h
//  iMouseiOS
//
//  Created by Will Cobb on 1/22/15.
//  Copyright (c) 2015 Apprentice Media LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UDPClient.h"
#import "BonjourHandler.h"
#import "Reachability.h"
#import <CoreMotion/CoreMotion.h>
@interface MouseViewController : UIViewController <BonjourDelegate> {

    CGFloat lastSend;
    NSString * buffer;
    Reachability* reachability;
    
    BOOL leftDown;
    BOOL rightDown;
    
    CGPoint velocity;
    CGPoint lastAcceleration;
}

@property BonjourHandler * bSocket;
@property CGPoint lastTouch;

@property CGPoint firstTouch;
@property CGFloat firstTouchTime;

@property CMMotionManager   * motionManager;

@end

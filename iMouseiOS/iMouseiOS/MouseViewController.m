//
//  MouseViewController.m
//  iMouseiOS
//
//  Created by Will Cobb on 1/22/15.
//  Copyright (c) 2015 Apprentice Media LLC. All rights reserved.
//

#import "MouseViewController.h"

@implementation MouseViewController {
    UIAccelerationValue rollingX, rollingY, rollingZ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bSocket.delegate = self;
    buffer = @"";
    UILongPressGestureRecognizer *oneTapDown = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(oneTapDown:)];
    oneTapDown.minimumPressDuration = 0.001;
    [self.view addGestureRecognizer:oneTapDown];
    
    UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTap:)];
    oneTap.numberOfTapsRequired = 1;
    //[self.view addGestureRecognizer:oneTap];
    self.motionManager = [[CMMotionManager alloc] init];
    //self.motionManager.deviceMotionUpdateInterval = 0.3;
    lastAcceleration = CGPointZero;
    
    [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:self.motionManager.attitudeReferenceFrame toQueue:[NSOperationQueue mainQueue]
            withHandler:^(CMDeviceMotion *motion, NSError *error)
            {
                
                int kFilteringFactor = 0.1;
                
                // Subtract the low-pass value from the current value to get a simplified high-pass filter

                rollingX = (motion.userAcceleration.x * kFilteringFactor) + (rollingX * (1.0 - kFilteringFactor));

                rollingY = (motion.userAcceleration.y * kFilteringFactor) + (rollingY * (1.0 - kFilteringFactor));

                rollingZ = (motion.userAcceleration.z * kFilteringFactor) + (rollingZ * (1.0 - kFilteringFactor));

                 float accelX = motion.userAcceleration.x - rollingX;
                 float accelY = motion.userAcceleration.y - rollingY;
                 float accelZ = motion.userAcceleration.z - rollingZ;
                
                //if (motion.userAcceleration.x > 0.01 || motion.userAcceleration.y > 0.01 || motion.userAcceleration.x < -0.01 || motion.userAcceleration.y < -0.01) {
                    velocity = CGPointMake(velocity.x + (accelX + lastAcceleration.x) * 0.011, velocity.y + (accelY + lastAcceleration.y) * 0.011);
                    if (sqrt(pow((motion.userAcceleration.x + lastAcceleration.x), 2))< 0.01) {
                        //velocity = CGPointZero;
                    }
                    NSString * data = [NSString stringWithFormat:@"m#%i#%i", (int)(-velocity.x * 500), (int)(velocity.y * 500)];
                    [self send:data];
                
                    
                //} else {
                //    velocity = CGPointZero;
                //}
                
            }
     
     
     
    ];
    
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self.motionManager stopDeviceMotionUpdates];
}

-(void) recievedData:(NSData *)data
{
    NSString * dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([dataString isEqualToString:@"p"]) {
        [self send:@"p"];
    }
}

-(void) connectionDisconnected
{

}

-(void) updatedServices:(NSMutableArray *)services
{

}

-(void) send:(NSString *) data
{
    NSString * formattedData = [NSString stringWithFormat:@"!%@$", data];
    buffer = [buffer stringByAppendingString:formattedData];
    NSLog(@"%@", data);
    if (CACurrentMediaTime() - lastSend > 0.016) {
        lastSend = CACurrentMediaTime();
        [self.bSocket send:[[NSData alloc]	 initWithData:[buffer dataUsingEncoding:NSASCIIStringEncoding]]];
        buffer = @"";
    }
    
}

-(void) oneTapDown:(UILongPressGestureRecognizer*) sender
{
    
    CGPoint location = CGPointMake([sender locationInView:self.view].x, [sender locationInView:self.view].y);
    NSLog(@"%f", location.x);
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (location.x < self.view.frame.size.width/2 - 20) {
            [self send:@"ld"];
            leftDown = YES;
        } else if (location.x > self.view.frame.size.width/2 + 20) {
            [self send:@"rd"];
            rightDown = YES;
        }
    } else if (sender.state== UIGestureRecognizerStateEnded) {
        if (leftDown) {
            [self send:@"lu"];
            leftDown = NO;
        } else if (rightDown) {
            [self send:@"ru"];
            rightDown = NO;
        }
    }
}

-(void) oneTap:(UIPanGestureRecognizer *) sender
{
    /*NSLog(@"Up");
    if (leftDown) {
        [self send:@"lu"];
        leftDown = NO;
        NSLog(@"LU");
    } else if (rightDown) {
        [self send:@"ru"];
        leftDown = NO;
    }*/
}

-(void) oneMove:(UIPanGestureRecognizer *) sender
{
    CGPoint location = CGPointMake([sender translationInView:self.view].x - self.view.frame.size.width/2, [sender translationInView:self.view].y - self.view.frame.size.height/2);
    if ([sender state] == UIGestureRecognizerStateBegan) {
        if (location.x < self.view.frame.size.width/2 - 20) { //Left
            [self send:@"ld"];
            leftDown = YES;
            NSLog(@"LD");
        } else if (location.x > self.view.frame.size.width/2 + 20) { //Right
            [self send:@"rd"];
            rightDown = YES;
        }
    } else if ([sender state] == UIGestureRecognizerStateEnded) {
        if (leftDown) {
            [self send:@"lu"];
            leftDown = NO;
            NSLog(@"LU");
        } else if (rightDown) {
            [self send:@"ru"];
            leftDown = NO;
        }
    }
    //CGPoint movement = CGPointMake(location.x - _lastTouch.x,location.y - _lastTouch.y);
    //NSString * data = [NSString stringWithFormat:@"m#%i#%i", (int)movement.x * 2, (int)movement.y * 2];
    //[self send:data];
    _lastTouch = location;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

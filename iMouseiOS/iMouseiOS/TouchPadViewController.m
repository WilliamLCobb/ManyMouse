//
//  TouchPadViewController.m
//  iMouseiOS
//
//  Created by Will Cobb on 1/21/15.
//  Copyright (c) 2015 Apprentice Media LLC. All rights reserved.
//

#import "TouchPadViewController.h"

@implementation TouchPadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    buffer = @"";
    self.bSocket.delegate = self;
    UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTap)];
    oneTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:oneTap];
    
    UITapGestureRecognizer *twoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoTap)];
    twoTap.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:twoTap];
    
    UIPanGestureRecognizer * onePan =[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(oneMove:)];
    onePan.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer:onePan];
    
    UIPanGestureRecognizer * twoPan =[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(twoMove:)];
    twoPan.minimumNumberOfTouches = 2;
    twoPan.maximumNumberOfTouches = 2;
    [self.view addGestureRecognizer:twoPan];
    
    UIPanGestureRecognizer * threePan =[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(threeMove:)];
    threePan.minimumNumberOfTouches = 3;
    threePan.maximumNumberOfTouches = 3;
    [self.view addGestureRecognizer:threePan];
    
}

-(void) recievedData:(NSData *)data
{
    NSString * dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([dataString isEqualToString:@"p"]) {
        [self send:@"p"];
    }
    
}

-(void) updatedServices:(NSMutableArray *)services
{

}

-(void) send:(NSString *) data
{
    [self.bSocket send:[[NSData alloc] initWithData:[[NSString stringWithFormat:@"!%@$", data] dataUsingEncoding:NSASCIIStringEncoding]]];
    /*NSString * formattedData = [NSString stringWithFormat:@"!%@$", data];
    buffer = [buffer stringByAppendingString:formattedData];
    NSLog(@"%@", buffer);
    if (CACurrentMediaTime() - lastSend > 0.00) {
        lastSend = CACurrentMediaTime();
        [self.bSocket send:[[NSData alloc] initWithData:[buffer dataUsingEncoding:NSASCIIStringEncoding]]];
        NSLog(@"Sent: %@", buffer);
        buffer = @"";
    }*/
    
}

-(void) oneTap
{
    NSLog(@"One");
    [self send:@"ld"];
    [self send:@"lu"];
}

-(void) twoTap
{
    NSLog(@"Two");
    [self send:@"rd"];
    [self send:@"ru"];
}

-(void) oneMove:(UIPanGestureRecognizer *) sender
{
    CGPoint location = CGPointMake([sender translationInView:self.view].x - self.view.frame.size.width/2, [sender translationInView:self.view].y - self.view.frame.size.height/2);
    if ([sender state] == UIGestureRecognizerStateBegan) {
        _lastTouch = location;
    }
    NSLog(@"HEY");
    CGPoint movement = CGPointMake(location.x - _lastTouch.x,location.y - _lastTouch.y);
    NSString * data = [NSString stringWithFormat:@"m#%i#%i", (int)movement.x, (int)movement.y];
    if (movement.x != 0 && movement.y != 0)
        [self send:data];
    _lastTouch = location;
}

-(void) twoMove:(UIPanGestureRecognizer *) sender
{
    CGPoint location = CGPointMake([sender translationInView:self.view].x - self.view.frame.size.width/2, [sender translationInView:self.view].y - self.view.frame.size.height/2);
    if ([sender state] == UIGestureRecognizerStateBegan) {
        _lastTouch = location;
    }
    CGPoint movement = CGPointMake(location.x - _lastTouch.x,location.y - _lastTouch.y);
    NSString * data = [NSString stringWithFormat:@"w#%i#%i", (int)movement.x, (int)movement.y];
    if (movement.x != 0 && movement.y != 0)
        [self send:data];
    _lastTouch = location;
}

-(void) threeMove:(UIPanGestureRecognizer *) sender
{
    CGPoint location = CGPointMake([sender translationInView:self.view].x - self.view.frame.size.width/2, [sender translationInView:self.view].y - self.view.frame.size.height/2);
    if ([sender state] == UIGestureRecognizerStateBegan) {
        _lastTouch = location;
        [self send:@"ld"];
    }
    else if ([sender state] == UIGestureRecognizerStateEnded) {
        NSLog(@"Ended");
        [self send:@"lu"];
    }
    CGPoint movement = CGPointMake(location.x - _lastTouch.x,location.y - _lastTouch.y);
    NSString * data = [NSString stringWithFormat:@"m#%i#%i", (int)movement.x, (int)movement.y];
    if (movement.x != 0 && movement.y != 0)
        [self send:data];
    _lastTouch = location;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

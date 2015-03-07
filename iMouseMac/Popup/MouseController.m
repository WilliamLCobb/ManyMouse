//
//  MouseController.m
//  iMouse
//
//  Created by Will Cobb on 1/21/15.
//
//

#import "MouseController.h"

@implementation MouseController

void PostMouseEvent(CGMouseButton button, CGEventType type, const CGPoint point);

-(id) init
{
    if ((self = [super init]))
    {
        //_Socket = [[UDPHost alloc] initWithPort:5030];
        _bSocket = [[BonjourHandler alloc] init];
        _bSocket.delegate = self;
        [_bSocket start];
        _mouse = [[Mouse alloc] init];
        buffer = @"";
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(ping) userInfo:nil repeats:YES];
    }
    return self;
}

-(void) ping
{
    if (self.bSocket.streamOpenCount == 2) {
        [self.bSocket send:[[NSData alloc] initWithData:[@"p" dataUsingEncoding:NSASCIIStringEncoding]]];
        lastPing = CACurrentMediaTime();
    }
}

-(void) recievedPing
{
    NSLog(@"Ping: %f", (CACurrentMediaTime() - lastPing)/0.002);
}

-(void) connectionDisconnected
{
    
}

-(void) recievedData:(NSData *)data
{
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    buffer = [buffer stringByAppendingString:dataString];
    //NSLog(@"Buffer: %@", buffer);
    if ([[buffer substringToIndex:1] isEqualToString:@"!"] && [[buffer substringFromIndex:[buffer length]-1] isEqualToString:@"$"]) {
        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"!$"];
        NSString * move = [[buffer componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
        NSLog(@"Data: %@", buffer);
        if      ([move isEqualToString:@"p"]) [self recievedPing];
        else if ([move isEqualToString:@"ld"]) [_mouse leftDown];
        else if ([move isEqualToString:@"lu"]) [_mouse leftUp];
        else if ([move isEqualToString:@"rd"]) [_mouse rightDown];
        else if ([move isEqualToString:@"ru"]) [_mouse rightUp];
        else {
            NSArray * coords = [move componentsSeparatedByString:@"#"];
            if      ([coords[0] isEqualToString:@"m"])
                [_mouse shiftMouse:CGPointMake([coords[1] intValue], [coords[2] intValue])];
            else if ([coords[0] isEqualToString:@"w"])
                [_mouse shiftScrollWheel:CGPointMake([coords[1] intValue], [coords[2] intValue])];
        }
        buffer = @"";
    }
}

-(void) connectionEstablished
{
    
}

-(void)updatedServices:(NSMutableArray *)services
{
    
}

-(void) startUpdates
{
    //[NSThread detachNewThreadSelector:@selector(run) toTarget:self withObject:nil];
}






@end

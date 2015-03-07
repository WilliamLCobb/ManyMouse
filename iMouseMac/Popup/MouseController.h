//
//  MouseController.h
//  iMouse
//
//  Created by Will Cobb on 1/21/15.
//
//

#import <Foundation/Foundation.h>
#import "UDPHost.h"
#import "Mouse.h"
#import "BonjourHandler.h"
#import "Panel.h"
@interface MouseController : NSObject <BonjourDelegate> {
    NSString * buffer;
    CGFloat lastPing;
}

@property Panel * panel;

@property UDPHost * Socket;
@property BonjourHandler * bSocket;
@property Mouse * mouse;

-(void) startUpdates;
-(void) updatedServices:(NSMutableArray *)services;
@end

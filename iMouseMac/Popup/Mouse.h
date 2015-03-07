//
//  Mouse.h
//  iMouse
//
//  Created by Will Cobb on 1/21/15.
//
//

#import <Foundation/Foundation.h>

@interface Mouse : NSObject {
    BOOL leftDown;
}


-(void) leftDown;
-(void) leftUp;
-(void) rightDown;
-(void) rightUp;
-(void) shiftMouse:(NSPoint) point;
-(void) shiftScrollWheel:(CGPoint) point;

@end

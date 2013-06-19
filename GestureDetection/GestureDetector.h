//
//  GestureDetector.h
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 5/5/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GestureTypeUtility.h"

#define VERT_SWIPE_DRAG_MAX 85
#define HORZ_SWIPE          70
#define TAP_THRESHOLD       15
#define TAPS                3

@protocol GestureDetectorProtocol <NSObject>

- (void)gestureDetectedAs:(NSString *)gesture withArgument:(NSInteger)arg;

@end

@interface GestureDetector : NSObject
{
  BOOL isWaitingForInput;
  BOOL hasMoved;
  BOOL hasStarted;
  BOOL isValid;
  NSInteger currentSum;
  NSInteger startTouch;
  CGPoint startTouchPosition;
  CGPoint currentTouchPosition;
}

@property (strong, nonatomic) id <GestureDetectorProtocol> delegate;

- (void)touchBegan:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView *)view;
- (void)touchMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchEnded:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView *)view;

/** sets the validity of this gesture recognizer */
- (void)setValid:(BOOL) isVaild;
- (BOOL)isValid;

@end

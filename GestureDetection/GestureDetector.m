//
//  GestureDetector.m
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 5/5/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "GestureDetector.h"

@implementation GestureDetector

- (id)init
{
  self = [super init];
  if (self) {
    [self reset];
  }
  return self;
}

- (void)touchBegan:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView *)view
{
  startTouch = [[event allTouches] count];
  UITouch *touch = [touches anyObject];
  startTouchPosition = [touch locationInView:view];
  hasStarted = true;
  hasMoved = NO;
  isValid = YES;
}

- (void)touchMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  NSUInteger tempTaps = [[event allTouches] count];
  if (startTouch != tempTaps) {
    hasMoved = YES;
    if (startTouch < tempTaps) {
      startTouch = tempTaps;
    }
  }
}

- (void)touchEnded:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView *)view
{
  hasMoved = NO;
  UITouch *touch = [touches anyObject];
  currentTouchPosition = [touch locationInView:view];
  NSUInteger tempTaps = [[event allTouches] count];
  if (startTouch < tempTaps) {
    startTouch = tempTaps;
  }
}

- (void)setValid:(BOOL)valid
{
  isValid = valid;
}

- (BOOL)isValid
{
  return isValid;
}

- (void)reset
{
  isWaitingForInput = NO;
  hasMoved = NO;
  hasStarted = NO;
  currentSum = 0;
  startTouch = -1;
  isValid = YES;
}

@end

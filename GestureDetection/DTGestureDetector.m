//
//  GestureDetector.m
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 5/5/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "DTGestureDetector.h"

@implementation DTGestureDetector

- (id)init
{
  self = [super init];
  if (self) {
    [self reset];
  }
  return self;
}

- (id)initWithSharedState:(DTGestureDetectionSharedState *)sharedState
{
  [NSException raise:@"Method not implemented" format:@"Only initialize this class from the subclasses"];
  return nil;
}

- (void)touchBegan:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView *)view
{
  _sharedState.startTouch = [[event allTouches] count];
  UITouch *touch = [touches anyObject];
  _sharedState.startTouchPosition = [touch locationInView:view];
  _sharedState.hasStarted = true;
  _sharedState.hasMoved = NO;
  _sharedState.isValid = YES;
}

- (void)touchMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  NSUInteger tempTaps = [[event allTouches] count];
  if (_sharedState.startTouch != tempTaps) {
    _sharedState.hasMoved = YES;
    if (_sharedState.startTouch < tempTaps) {
      _sharedState.startTouch = tempTaps;
    }
  }
}

- (void)touchEnded:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView *)view
{
  _sharedState.hasMoved = NO;
  UITouch *touch = [touches anyObject];
  _sharedState.currentTouchPosition = [touch locationInView:view];
  NSUInteger tempTaps = [[event allTouches] count];
  if (_sharedState.startTouch < tempTaps) {
    _sharedState.startTouch = tempTaps;
  }
}

- (void)setValid:(BOOL)valid
{
  _sharedState.isValid = valid;
}

- (BOOL)isValid
{
  return _sharedState.isValid;
}

- (void)reset
{
  [_sharedState reset];
}

@end

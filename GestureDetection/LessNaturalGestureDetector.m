//
//  LessNaturalGestureDetector.m
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 4/30/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "Utility.h"

#import "LessNaturalGestureDetector.h"

@interface LessNaturalGestureDetector()

@end

@implementation LessNaturalGestureDetector

- (id)initWithSharedState:(DTGestureDetectionSharedState *)sharedState
{
  self = [super init];
  if (self) {
    super.sharedState = sharedState;
  }
  return self;
}

- (void)touchEnded:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView *)view
{
  [super touchEnded:touches withEvent:event inView:view];
  DTGestureDetectionSharedState *sharedState = super.sharedState;
  if ([Utility computeDistanceFrom:sharedState.currentTouchPosition to:sharedState.startTouchPosition] >= VERT_SWIPE_DRAG_MAX
      && sharedState.startTouch == 1) {
    // a flick, put it in a waiting state
    if (sharedState.isWaitingForInput) {
      sharedState.isWaitingForInput = NO;
      [self gestureDetectedWithValue:sharedState.currentSum];
    } else {
      sharedState.isWaitingForInput = YES;
      [self gestureDetectedWithValue:-2];
    }
    sharedState.currentSum = 0;
  } else if (fabs(sharedState.currentTouchPosition.x - sharedState.startTouchPosition.x) <= TAP_THRESHOLD) {
    if (sharedState.isWaitingForInput) {
      if (sharedState.currentSum == 0) {
        [self gestureDetectedWithValue:10 - sharedState.startTouch];
      } else {
        [self gestureDetectedWithValue:sharedState.currentSum + sharedState.startTouch];
        sharedState.currentSum = 0;
      }
      sharedState.isWaitingForInput = NO;
    } else if (sharedState.startTouch == 3) {
      sharedState.currentSum += sharedState.startTouch;
      sharedState.isWaitingForInput = YES;
      [self gestureDetectedWithValue:-1];
    } else {
      sharedState.isWaitingForInput = NO;
      [self gestureDetectedWithValue:sharedState.currentSum + sharedState.startTouch];
      sharedState.currentSum = 0;
    }
  }
}

- (void)gestureDetectedWithValue:(NSInteger)value
{
  if ([self.delegate respondsToSelector:@selector(gestureDetectedAs:withArgument:)]) {
    [self.delegate gestureDetectedAs:[self description] withArgument:value];
  }
}

- (NSString *)description
{
  return [GestureTypeUtility gestureTypeToString:LESS_NATURAL];
}

@end

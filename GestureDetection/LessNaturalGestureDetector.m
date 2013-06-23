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

- (void)touchEnded:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView *)view
{
  [super touchEnded:touches withEvent:event inView:view];
  if ([Utility computeDistanceFrom:currentTouchPosition to:startTouchPosition] >= VERT_SWIPE_DRAG_MAX) {
    // a flick, put it in a waiting state
    if (isWaitingForInput) {
      isWaitingForInput = NO;
      [self gestureDetectedWithValue:currentSum];
    } else {
      isWaitingForInput = YES;
      [self gestureDetectedWithValue:-2];
    }
    currentSum = 0;
  } else if (fabs(currentTouchPosition.x - startTouchPosition.x) <= TAP_THRESHOLD) {
    if (isWaitingForInput) {
      if (currentSum == 0) {
        [self gestureDetectedWithValue:10 - startTouch];
      } else {
        [self gestureDetectedWithValue:currentSum + startTouch];
        currentSum = 0;
      }
      isWaitingForInput = NO;
    } else if (startTouch == 3) {
      currentSum += startTouch;
      isWaitingForInput = YES;
      [self gestureDetectedWithValue:-1];
    } else {
      isWaitingForInput = NO;
      [self gestureDetectedWithValue:currentSum + startTouch];
      currentSum = 0;
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

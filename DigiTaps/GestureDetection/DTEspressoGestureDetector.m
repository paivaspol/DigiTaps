//
//  NaturalGestureDetector.m
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 4/30/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "../Utilities/Utility.h"

#import "DTEspressoGestureDetector.h"

@implementation DTEspressoGestureDetector

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
    // it's a swipe! return 0 + currentSum, and reset all the variables
    [self gestureDetectedWithValue:sharedState.currentSum];
    sharedState.currentSum = 0;
    sharedState.isWaitingForInput = NO;
  } else if ([Utility computeDistanceFrom:sharedState.currentTouchPosition to:sharedState.startTouchPosition] < VERT_SWIPE_DRAG_MAX) {  // this is a tap
    if (sharedState.startTouch == TAPS && sharedState.currentSum < 6) {
      sharedState.isWaitingForInput = true;
      sharedState.currentSum += TAPS;
      if (sharedState.currentSum == 3) {
        // set arg = -1, so the controller can play a click sound
        [self gestureDetectedWithValue:-1];
      } else {
        // set arg = -2, so the controller can play double click sound
        [self gestureDetectedWithValue:-2];
      }
    } else {
      [self gestureDetectedWithValue:sharedState.currentSum + sharedState.startTouch];
      sharedState.isWaitingForInput = false;
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
  return [GestureTypeUtility gestureTypeToString:NATURAL];
}
@end

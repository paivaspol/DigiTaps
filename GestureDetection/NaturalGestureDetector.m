//
//  NaturalGestureDetector.m
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 4/30/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "NaturalGestureDetector.h"

@implementation NaturalGestureDetector

- (id)init
{
  self = [super init];
  if (self) {

  }
  return self;
}

- (void)touchEnded:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView *)view
{
  [super touchEnded:touches withEvent:event inView:view];
  if ((fabsf(currentTouchPosition.y - startTouchPosition.y) >= VERT_SWIPE_DRAG_MAX)
      && (startTouch == 1)) {
    // it's a swipe! return 0 + currentSum, and reset all the variables
    [self gestureDetectedWithValue:currentSum];
    currentSum = 0;
    isWaitingForInput = NO;
  } else {  // this is a tap
    if (startTouch == TAPS && currentSum < 6) {
      isWaitingForInput = true;
      currentSum += TAPS;
      if (currentSum == 3) {
        // set arg = -1, so the controller can play a click sound
        [self gestureDetectedWithValue:-1];
      } else {
        // set arg = -2, so the controller can play double click sound
        [self gestureDetectedWithValue:-2];
      }
    } else {
      NSLog(@"current sum: %d, start touch: %d", currentSum, startTouch);
      [self gestureDetectedWithValue:currentSum + startTouch];
      isWaitingForInput = false;
      currentSum = 0;
    }
  }
}

- (void)gestureDetectedWithValue:(NSInteger)value
{
  if ([self.delegate respondsToSelector:@selector(gestureDetectedAs:withArgument:)]) {
    NSLog(@"NatGD: value=%d", value);
    NSLog(@"detector delegate: %@", [self delegate]);
    [self.delegate gestureDetectedAs:[self description] withArgument:value];

  }
}

- (NSString *)description
{
  return [GestureTypeUtility gestureTypeToString:NATURAL];
}
@end

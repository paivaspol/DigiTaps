//
//  BackspaceGestureDetector.m
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 5/5/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "BackspaceGestureDetector.h"

#import "Utility.h"

@implementation BackspaceGestureDetector

- (id)initWithSharedState:(DTGestureDetectionSharedState *)sharedState
{
  self = [super init];
  if (self) {
    super.sharedState = sharedState;
  }
  return self;
}

-(void)touchEnded:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView *)view
{
  [super touchEnded:touches withEvent:event inView:view];
  DTGestureDetectionSharedState *sharedState = super.sharedState;
  // Backspace detection
  if ([Utility computeDistanceFrom:sharedState.startTouchPosition to:sharedState.currentTouchPosition] >= HORZ_SWIPE
      && (sharedState.startTouch == 2) && [Utility computeDistanceFrom:sharedState.startTouchPosition to:sharedState.currentTouchPosition] > TAP_THRESHOLD) {
    // doesn't matter which way the user swiped
    if (sharedState.currentSum != 0) {
      sharedState.currentSum = 0;
      sharedState.isWaitingForInput = NO;
    } else if (sharedState.isWaitingForInput && sharedState.currentSum == 0) {
      // This case is for LessNatural one flick.
      sharedState.isWaitingForInput = NO;
    } else {
      if ([self.delegate respondsToSelector:@selector(gestureDetectedAs:withArgument:)]) {
        [self.delegate gestureDetectedAs:[self description] withArgument:-1];
      }
    }
  }
}

- (NSString *)description
{
  return [GestureTypeUtility gestureTypeToString:BACKSPACE];
}

@end

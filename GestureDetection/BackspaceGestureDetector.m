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

-(void)touchEnded:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView *)view
{
  [super touchEnded:touches withEvent:event inView:view];
  // Backspace detection
  if ([Utility computeDistanceFrom:startTouchPosition to:currentTouchPosition] >= HORZ_SWIPE
      && (startTouch == 2) && [Utility computeDistanceFrom:startTouchPosition to:currentTouchPosition] > TAP_THRESHOLD) {
    // doesn't matter which way the user swiped
    if (currentSum == 0) {
      if ([self.delegate respondsToSelector:@selector(gestureDetectedAs:withArgument:)]) {
        [self.delegate gestureDetectedAs:[self description] withArgument:-1];
      }
    } else {
      // there's something in memory, clear it out first
      currentSum = 0;
    }
  }
}

- (NSString *)description
{
  return [GestureTypeUtility gestureTypeToString:BACKSPACE];
}

@end

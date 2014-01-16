//
//  DTGestureDetectionSharedState.m
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 11/15/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "DTGestureDetectionSharedState.h"

@implementation DTGestureDetectionSharedState 

/* resets the properties */
- (void)reset
{
  _isWaitingForInput = NO;
  _hasMoved = NO;
  _hasStarted = NO;
  _currentSum = 0;
  _startTouch = -1;
  _isValid = YES;
}

@end

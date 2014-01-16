//
//  DTGestureDetectionSharedState.h
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 11/15/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GestureDetectorSharedState.h"

@interface DTGestureDetectionSharedState : GestureDetectorSharedState<GestureDetectorSharedStateProtocol>

@property BOOL isWaitingForInput;
@property BOOL hasMoved;
@property BOOL hasStarted;
@property BOOL isValid;
@property NSInteger currentSum;
@property NSInteger startTouch;
@property CGPoint startTouchPosition;
@property CGPoint currentTouchPosition;

@end

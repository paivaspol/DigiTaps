//
//  GestureDetector.h
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 5/5/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GestureDetector.h"
#import "DTGestureDetectionSharedState.h"
#import "GestureTypeUtility.h"

#define VERT_SWIPE_DRAG_MAX 85
#define HORZ_SWIPE          70
#define TAP_THRESHOLD       15
#define TAPS                3


@interface DTGestureDetector : GestureDetector

@property DTGestureDetectionSharedState *sharedState;

/** sets the validity of this gesture recognizer */
- (id)initWithSharedState:(DTGestureDetectionSharedState *)sharedState;
- (void)setValid:(BOOL) isVaild;
- (BOOL)isValid;
- (void)reset;

@end

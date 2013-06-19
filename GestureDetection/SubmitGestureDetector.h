//
//  SubmitGestureDetector.h
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 5/5/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "GestureDetector.h"

#define MENU_WAIT_TIME 0.35

@interface SubmitGestureDetector : GestureDetector
{
  NSTimer *timer;
}

@end

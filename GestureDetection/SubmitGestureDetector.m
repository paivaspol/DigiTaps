//
//  SubmitGestureDetector.m
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 5/5/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "SubmitGestureDetector.h"

@implementation SubmitGestureDetector

- (id)init
{
  if ((self = [super init]) != nil) {
  }
  return self;
}

- (void)touchBegan:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView *)view
{
  [super touchBegan:touches withEvent:event inView:view];
  if (startTouch == 1) {
    timer = [NSTimer scheduledTimerWithTimeInterval:MENU_WAIT_TIME target:self selector:@selector(submit:) userInfo:nil repeats:NO];
  }
}

- (void)touchEnded:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView *)view
{
  [super touchEnded:touches withEvent:event inView:view];
  [timer invalidate];
}

- (void)submit:(NSTimer *)timer {
  if (isValid && !hasMoved && [self.delegate respondsToSelector:@selector(gestureDetectedAs:withArgument:)]) {
    [self.delegate gestureDetectedAs:[self description] withArgument:-1];
  }
}

- (NSString *)description
{
  return [GestureTypeUtility gestureTypeToString:SUBMIT];
}

@end

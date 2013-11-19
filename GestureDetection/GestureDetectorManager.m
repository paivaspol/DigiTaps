//
//  GestureDetector.m
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 5/5/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "GestureDetectorManager.h"

#import "BackspaceGestureDetector.h"

@implementation GestureDetectorManager

- (id)init
{
  if ((self = [super init]) != nil) {
    gestureDetectors = [[NSMutableArray alloc] init];
    didDetectGesture = NO;
  }
  return self;
}

- (void)addGestureDetector:(GestureDetector *)detector
{
  [detector setDelegate:self];
  [gestureDetectors addObject:detector];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView *)view
{
  didDetectGesture = NO;
  for (DTGestureDetector *gd in gestureDetectors) {
    [gd touchBegan:touches withEvent:event inView:view];
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  for (DTGestureDetector *gd in gestureDetectors) {
    [gd touchMoved:touches withEvent:event];
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView *)view
{
  for (DTGestureDetector *gd in gestureDetectors) {
    [gd touchEnded:touches withEvent:event inView:view];
    if (didDetectGesture) {
      break;
    }
  }
  for (DTGestureDetector *gd in gestureDetectors) {
    [gd setValid:NO];
  }
}

- (void)gestureDetectedAs:(NSString *)gesture withArgument:(NSInteger)arg
{
  if ([self.delegate respondsToSelector:@selector(handleGesture:withArgument:)]) {
    [self.delegate handleGesture:[GestureTypeUtility stringToGestureType:gesture] withArgument:arg];
  }
}

- (void)setDidDetectGesture:(BOOL)didDetect
{
  didDetectGesture = didDetect;
}

/* resets the shared state property. */
- (void)reset
{
  for (DTGestureDetector *gd in gestureDetectors) {
    [gd reset];
  }
}

@end

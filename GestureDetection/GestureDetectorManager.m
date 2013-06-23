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
    GestureDetector *backspaceDetector = [[BackspaceGestureDetector alloc] init];
    [self addGestureDetector:backspaceDetector];
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
  NSLog(@"Touch began");
  didDetectGesture = NO;
  for (GestureDetector *gd in gestureDetectors) {
    [gd touchBegan:touches withEvent:event inView:view];
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  NSLog(@"Touch moved");
  for (GestureDetector *gd in gestureDetectors) {
    [gd touchMoved:touches withEvent:event];
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView *)view
{
    NSLog(@"Touch ended");
  for (GestureDetector *gd in gestureDetectors) {
    [gd touchEnded:touches withEvent:event inView:view];
    if (didDetectGesture) {
      break;
    }
  }
  for (GestureDetector *gd in gestureDetectors) {
    [gd setValid:NO];
  }
}

- (void)gestureDetectedAs:(NSString *)gesture withArgument:(NSInteger)arg
{
  if ([self.delegate respondsToSelector:@selector(handleGesture:withArgument:)]) {
    NSLog(@"Manager: arg = %d", arg);
    [self.delegate handleGesture:[GestureTypeUtility stringToGestureType:gesture] withArgument:arg];
  }
}

- (void)setDidDetectGesture:(BOOL)didDetect
{
  didDetectGesture = didDetect;
}

- (void)reset
{
  for (GestureDetector *gd in gestureDetectors) {
    [gd reset];
  }
}

@end

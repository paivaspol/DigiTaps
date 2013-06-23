//
//  Utility.m
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 6/20/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (double)computeDistanceFrom:(CGPoint)pointOne to:(CGPoint)pointTwo
{
  double deltaX = pointOne.x - pointTwo.x;
  double deltaY = pointOne.y - pointTwo.y;
  return sqrt(deltaX * deltaX + deltaY * deltaY);
}

+ (void)announceVoiceOverWithString:(NSString *)string andValue:(int)val
{
  if (UIAccessibilityIsVoiceOverRunning()) {
    if (val >= 0 && val < 9) {
      UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, [NSString stringWithFormat:string, val]);
    } else if (val == -1 || val == -2 || val == 9) {
      UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, string);
    }
  }
}

+ (void)announceVoiceOverWithString:(NSString *)string
{
  if (UIAccessibilityIsVoiceOverRunning()) {
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, string);
  }
}

@end

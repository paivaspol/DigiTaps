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

@end

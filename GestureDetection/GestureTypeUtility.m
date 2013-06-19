//
//  GestureType.m
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 5/17/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "GestureTypeUtility.h"

@implementation GestureTypeUtility

static NSString * const kBackspace = @"backspace";
static NSString * const kSubmit = @"submit";
static NSString * const kNatural = @"natural";
static NSString * const kLessNatural = @"less_natural";

+ (NSString *)gestureTypeToString:(GestureType)type
{
  switch (type) {
    case BACKSPACE:
      return @"backspace";
    case SUBMIT:
      return @"submit";
    case NATURAL:
      return @"natural";
    case LESS_NATURAL:
      return @"less_natural";
    default:
      break;
  }
}

+ (GestureType)stringToGestureType:(NSString *)enumStr
{
  if ([enumStr isEqualToString:kBackspace]) {
    return BACKSPACE;
  } else if ([enumStr isEqualToString:kSubmit]) {
    return SUBMIT;
  } else if ([enumStr isEqualToString:kNatural]) {
    return NATURAL;
  } else if ([enumStr isEqualToString:kLessNatural]) {
    return LESS_NATURAL;
  }
  return NULL;
}

@end

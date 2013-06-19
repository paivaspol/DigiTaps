//
//  GestureType.h
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 5/17/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum GestureType {
  BACKSPACE,
  SUBMIT,
  NATURAL,
  LESS_NATURAL
} GestureType;

@interface GestureTypeUtility : NSObject

+ (NSString *)gestureTypeToString:(GestureType)type;
+ (GestureType)stringToGestureType:(NSString *)enumStr;

@end

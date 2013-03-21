//
//  Logger.h
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 3/3/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum Event {
  GAME_START,
  GAME_END,
  GESTURE_TAP,
  GESTURE_SWIPE,
  NUMBER_PRESENTED
} Event;

@interface Logger : NSObject

+ (id)getInstance;

- (void)logWithEvent:(Event)event andParams:(NSDictionary *)params andUID:(NSUInteger)uid andGameId:(NSUInteger)gid andTaskId:(NSUInteger)tid andTime:(long)time andIsVoiceOverOn:(BOOL)isVoiceOverOn;

@end

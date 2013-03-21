//
//  Logger.m
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 3/3/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "Logger.h"

@interface Logger()

@end

@implementation Logger

+ (id)getInstance
{
  static Logger *instance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[Logger alloc] init];
  });
  return instance;
}

- (void)logWithEvent:(Event)event andParams:(NSDictionary *)params andUID:(NSUInteger)uid andGameId:(NSUInteger)gid andTaskId:(NSUInteger)tid andTime:(long)time andIsVoiceOverOn:(BOOL)isVoiceOverOn
{
  
}

@end

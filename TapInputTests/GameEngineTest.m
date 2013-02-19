//
//  GameEngineTest.m
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 1/17/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "GameEngineTest.h"

@implementation GameEngineTest

- (void)setUp
{
  gameEngine = [[GameEngine alloc] init];
}

- (void)testInitializeGame
{
  STAssertEquals(ENDED, [gameEngine state], @"Failed");
  [gameEngine initializeGame];
  STAssertEquals(STARTED, [gameEngine state], @"Failed");
}

@end

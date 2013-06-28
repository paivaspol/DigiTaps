//
//  GameEngine.h
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 1/17/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MISS_THRESHOLD    3
#define INITIAL_SIG       100
#define NUMBERS_PER_LEVEL 3
#define NUM_LEVEL         5

static CFStringRef gameIdKey = CFSTR("gameId");

typedef enum GameState {
  ACTIVE,
  IN_BETWEEN,
  ENDED
} GameState;

@interface GameEngine : NSObject
{
  @private
  int miss;
  int correct;
  int curNumberIndex;
  int curLevel;
  int gameId;
  CFNumberRef tempId;

  int totalDigits;
  int digitsMissed;

  GameState state;
  NSMutableArray *numberContainer;
  NSMutableArray *points;
}

// Singleton method
+ (id)getInstance;

- (void)initializeGame;
- (GameState)state;
- (int)numWrongTrials;
- (void)resetGame;

- (void)setStartingLevel:(int)level;
// Returns the current number to be input
- (NSString *)currentNumber;
// inputs the number for checking, with the time used
- (void)inputNumber:(int)number withTime:(NSTimeInterval)timeUsed;
// move the cursor to the next number
- (void)nextNumber;
// switch to the next level
- (void)nextLevel;
// gets the next level
- (int)currentLevel;
// generates the list of numbers for the level specified
- (void)generateForLevel:(int)level;
// returns the maximum level
- (int)getMaxLevel;
// returns number of correct trails
- (int)correct;
// returns number of miss trails
- (int)miss;
- (int)numbersPerLevel;
// returns the accuracy rate of the level
- (NSString *)getAccurancyRate;
// Returns an array of error rates
- (NSArray *)getPoints;

- (int)gameId;
- (int)taskId;

@end

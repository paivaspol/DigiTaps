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

typedef enum GameState {
  ACTIVE,
  IN_BETWEEN,
  ENDED
} GameState;

@interface GameEngine : NSObject
{
  @private
  int missCounter;
  int curNumberIndex;
  int curLevel;
  GameState state;
  NSMutableArray *numberContainer;
  int currentDivider;
}



- (void)initializeGame;
- (GameState)state;
- (int)numWrongTrials;
- (void)resetGame;

- (void)setStartingLevel:(int)level;
// Returns the current number to be input
- (int)currentNumber;
// inputs the number for checking, returns YES, if the numbers are equal
- (void)inputNumber:(int)number;
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

@end

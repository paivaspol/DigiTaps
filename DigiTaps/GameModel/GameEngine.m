//
//  GameEngine.m
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 1/17/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "GameEngine.h"

@interface GameEngine ()

@end

/* the base point */
static int const kBasePoint = 2;
/* the mid point */
static int const kMidPoint = 100;
/* the number number of digits */
static int const kNumDigits = 3;
/* all the possible digit */
static int digit[] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };
/* size of the digits available */
static int digitSize = 10;

@implementation GameEngine

+ (id)getInstance
{
  static GameEngine *instance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[GameEngine alloc] init];
  });
  return instance;
}

- (GameEngine *)init
{
  if ((self = [super init]) != nil) {
    state = ENDED;
    tempId = (CFNumberRef)CFPreferencesCopyAppValue(gameIdKey, kCFPreferencesCurrentApplication);
    totalTimeUsed = 0;
    if (tempId) {
      if (!CFNumberGetValue(tempId, kCFNumberIntType, &gameId)) {
        gameId = 0;
      }
    } else {
      gameId = 0;
    }
  }
  return self;
}

- (void)initializeGame
{
  // before incrementing, update the current gameId
  tempId = CFNumberCreate(NULL, kCFNumberIntType, &gameId);
  CFPreferencesSetAppValue(gameIdKey, tempId, kCFPreferencesCurrentApplication);
  gameId++;
  state = ACTIVE;
  [self resetGame];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"gamestarted" object:self];
}

- (void)wrongTrial:(NSString *)number
{
  miss++;
  digitsCorrect += [self numDigitWrong:number];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"wrongTrail" object:self];
}

- (int)numDigitWrong:(NSString *)numberStr
{
  int index = 0;
  int counter = 0;
  NSString* curNumber = [self currentNumber];
  while (index < [numberStr length] && index < [curNumber length]) {
    if ([numberStr characterAtIndex:index] == [curNumber characterAtIndex:index]) {
      counter++;
    }
    index++;
  }
  return counter;
}

- (void)inputNumber:(int)number withTime:(NSTimeInterval)timeUsed
{
  int curNumber = [[numberContainer objectAtIndex:curNumberIndex] intValue];
  NSString *numberStr = [NSString stringWithFormat:@"%d", number];
  int numDigit = [numberStr length];
  NSLog(@"num digit: %d, time used: %.3f", numDigit, timeUsed);
  totalTimeUsed += timeUsed;
  double rate = numDigit / timeUsed;
  int point = [self computePointFrom:rate withNumDigit:numDigit andIsWrong:(curNumber != number)];
  [points addObject:[NSNumber numberWithInt:point]];
  if (curNumber != number) {
    [self wrongTrial:numberStr];
  } else {
    correct++;
    digitsCorrect += [numberStr length];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"correctTrail" object:self];
  }
  [self nextNumber];
}

- (int)numDigits:(int)number
{
  int retval = 0;
  while (number > 0) {
    ++retval;
    number /= 10;
  }
  return retval;
}

- (void)generateForLevel:(int)level
{
  [self resetGame];
  state = ACTIVE;
  [[NSNotificationCenter defaultCenter] postNotificationName:@"levelGenerated" object:self];
  numberContainer = nil;
  numberContainer = [[NSMutableArray alloc] init];
  points = [[NSMutableArray alloc] init];
  for (int j = 0; j < NUMBERS_PER_LEVEL; j++) {
    NSMutableString *numberString = [[NSMutableString alloc] init];
    for (int idx = 0; idx < kNumDigits + curLevel - 1; idx++) {
      int index = arc4random_uniform(digitSize);
      [numberString appendString:[NSString stringWithFormat:@"%d", digit[index]]];
    }
    [numberContainer addObject:[NSString stringWithFormat:@"%@", [numberString description]]];
  }
}

- (void)setStartingLevel:(int)level
{
  curLevel = level;
}

- (NSString *)currentNumber
{
  NSString *retval = [numberContainer objectAtIndex:curNumberIndex];
  return retval;
}

- (GameState)state
{
  return state;
}

- (void)resetGame
{
  totalTimeUsed = 0;
  miss = 0;
  correct = 0;
  curNumberIndex = 0;
  digitsCorrect = 0;
  totalDigits = (kNumDigits + curLevel - 1) * NUMBERS_PER_LEVEL;
  NSLog(@"%d %d", kNumDigits, curLevel);
  points = [[NSMutableArray alloc] init];
}

- (int)numWrongTrials
{
  return miss;
}

- (void)nextNumber
{
  // compute the error of this number
  curNumberIndex++;
  if (curNumberIndex < NUMBERS_PER_LEVEL) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"numberChanged" object:self];
  } else {
    state = IN_BETWEEN;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"levelCompleted" object:self];
  }
}

- (NSString *)getAccurancyRate
{
  NSLog(@"%d %d", digitsCorrect, totalDigits);
  double percentAccuracy = 100.0 * digitsCorrect / totalDigits;
  return [NSString stringWithFormat:@"%.3f%%", percentAccuracy];
}

- (void)nextLevel
{
  [self resetGame];
  curLevel++;
}

- (int)currentLevel
{
  return curLevel;
}

- (int)getMaxLevel
{
  return NUM_LEVEL;
}

// returns number of correct trails
- (int)correct
{
  return correct;
}
// returns number of miss trails
- (int)miss
{
  return miss;
}

- (int)numbersPerLevel
{
  return NUMBERS_PER_LEVEL;
}

- (int)gameId
{
  return gameId;
}

- (int)taskId
{
  return curNumberIndex;
}

- (NSArray *)getPoints
{
  return [points copy];
}

// returns the total time used
- (NSTimeInterval)getTotalTimeUsed
{
  return totalTimeUsed;
}

// returns the average time used per number
- (NSTimeInterval)getAverageTimeUsed
{
  return totalTimeUsed / NUMBERS_PER_LEVEL;
}

- (double)getLevelPoint
{
  NSInteger sum = 0.0;
  for (int i = 0; i < [points count]; i++) {
    NSLog(@"points: %d", [[points objectAtIndex:i] integerValue]);
    sum += [[points objectAtIndex:i] intValue];
  }
  return 1.0 * sum / [points count];
}

/**
 * returns the point
 */
- (int)computePointFrom:(double)entryRate withNumDigit:(int)numDigit andIsWrong:(BOOL)isWrong
{
  if (isWrong) {
    return 0;
  }
  double expectedRate = [self baselineExpectedRate:numDigit];
  NSLog(@"Entry rate: %.3f", entryRate);
  return round(entryRate * kMidPoint / expectedRate);
}

- (double)baselineExpectedRate:(int)numDigit
{
  return numDigit * kBasePoint;
}

@end

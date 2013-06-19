//
//  GameEngine.m
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 1/17/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "GameEngine.h"

@interface GameEngine ()

@end

static int const kBasePoint = 2;
static int const kMidPoint = 10;

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
  miss = 0;
  curNumberIndex = 0;
  digitMiss = 0;
  state = ACTIVE;
  [[NSNotificationCenter defaultCenter] postNotificationName:@"gamestarted" object:self];
}

- (void)wrongTrial:(int)number
{
  miss++;
  // TODO: implement wrong digit counter.
  [[NSNotificationCenter defaultCenter] postNotificationName:@"wrongTrail" object:self];
}

- (int)numDigitWrong:(int)number
{
  return -1;
}

- (void)inputNumber:(int)number withTime:(NSTimeInterval)timeUsed
{
  int curNumber = [[numberContainer objectAtIndex:curNumberIndex] intValue];
  int numDigit = [self numDigits:curNumber];
  double rate = numDigit / timeUsed;
  int point = [self computePointFrom:rate withNumDigit:numDigit andIsWrong:(curNumber != number)];
  [points addObject:[NSNumber numberWithInt:point]];
  if (curNumber != number) {
    [self wrongTrial:number];
  } else {
    correct++;
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
  curNumberIndex = 0;
  miss = 0;
  digitMiss = 0;
  state = ACTIVE;
  [[NSNotificationCenter defaultCenter] postNotificationName:@"levelGenerated" object:self];
  
  numberContainer = nil;
  numberContainer = [[NSMutableArray alloc] init];
  for (int j = 0; j < NUMBERS_PER_LEVEL; j++) {
    int sig = INITIAL_SIG * pow(10, level);
    NSLog(@"sig: %d", sig);
    NSUInteger num = [self randomNumber:sig];
    [numberContainer addObject:[NSNumber numberWithInt:num]];
  }
  NSLog(@"%@", numberContainer);
}

- (void)setStartingLevel:(int)level
{
  curLevel = level;
}

- (int)currentNumber
{
  NSLog(@"in current number");
  NSNumber *retval = (NSNumber *) [numberContainer objectAtIndex:curNumberIndex];
  NSLog(@"fine!");
  return [retval intValue];
}

- (GameState)state
{
  return state;
}

- (void)resetGame
{
  [self initializeGame];
}

- (int)numWrongTrials
{
  return miss;
}

// Generates a random number with the specified digits
- (int)randomNumber:(int)significant
{
  uint32_t val = (unsigned) arc4random();
  val += significant;
  return val % (significant * 10);
}

- (void)nextNumber
{
  // compute the error of this number
  digitMiss = 0;
  curNumberIndex++;
  if (curNumberIndex < NUMBERS_PER_LEVEL) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"numberChanged" object:self];
  } else {
    state = IN_BETWEEN;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"levelCompleted" object:self];
  }
}

- (void)computeCurNumberError
{
  
}

- (void)nextLevel
{
  points = [[NSMutableArray alloc] init];
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

/**
 * returns the point
 */
- (int)computePointFrom:(double)entryRate withNumDigit:(int)numDigit andIsWrong:(BOOL)isWrong
{
  if (isWrong) {
    return 0;
  }
  double expectedRate = [self baselineExpectedRate:numDigit];
  return round((entryRate / expectedRate) * kMidPoint);
}

- (double)baselineExpectedRate:(int)numDigit
{
  return numDigit * kBasePoint;
}

@end

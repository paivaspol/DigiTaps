//
//  GameViewController.m
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 2/16/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "GameViewController.h"

#import "GameInformationManager.h"

@interface GameViewController ()

@end

@implementation GameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    gameEngine = [GameEngine getInstance];
    gameInfoManager = [GameInformationManager getInstance];
    playerId = [gameInfoManager getPlayerId];
    NSLog(@"playerId: %d", playerId);
    curInput = [[NSMutableString alloc] init];
    summaryViewController = [[SummaryViewController alloc] initWithNibName:@"SummaryViewController" bundle:[NSBundle mainBundle]];
    voiceOverQueue = [[NSMutableArray alloc] init];
    [summaryViewController setDelegate:self];
    [gameEngine resetGame];
    [self setupNotificationReceivers];
    [self setupSoundPlayers];
    [self.currentNumber setText:@""];
    didDisplaySummary = NO;
    logger = [Logger getInstance];
    numberStartTime = nil;
    UIGestureRecognizer *longPressRec = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self.view addGestureRecognizer:longPressRec];
    hasMoved = NO;
  }
  return self;
}

/**
 *  Sets the gesture detector manager with the manager being passed in
 */
- (void)setGestureDetectorManager:(GestureDetectorManager *)manager
{
  gestureDetectorManager = manager;
  [gestureDetectorManager setDelegate:self];
}

/**
 *  Sets up the sound player
 */
- (void)setupSoundPlayers
{
  NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"Correct" withExtension:@"wav"];
  AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(soundURL), &correctSound);
  CFRelease((__bridge CFTypeRef)(soundURL));
  soundURL = [[NSBundle mainBundle] URLForResource:@"Wrong" withExtension:@"wav"];
  AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(soundURL), &wrongSound);
  CFRelease((__bridge CFTypeRef)(soundURL));
  soundURL = [[NSBundle mainBundle] URLForResource:@"Backspace" withExtension:@"wav"];
  AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(soundURL), &backspaceSound);
  CFRelease((__bridge CFTypeRef)(soundURL));
  soundURL = [[NSBundle mainBundle] URLForResource:@"Click" withExtension:@"wav"];
  AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(soundURL), &clickSound);
  CFRelease((__bridge CFTypeRef)(soundURL));
  soundURL = [[NSBundle mainBundle] URLForResource:@"DoubleClick" withExtension:@"wav"];
  AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(soundURL), &doubleClickSound);
  CFRelease((__bridge CFTypeRef)(soundURL));
}

#pragma voiceover readback helper methods
- (void)respondAfterVoiceOverDidFinishReading:(NSNotification *)notification
{
  NSLog(@"GameVC: respond after voiceover is done");
  NSLog(@"GameVC: %@", voiceOverQueue);
  // read the next token out
  if ([voiceOverQueue count] > 0) {
    NSString *string = [voiceOverQueue lastObject];
    [voiceOverQueue removeLastObject];
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, string);
  }
}

#pragma view controller related
- (void)viewDidLoad
{
  [super viewDidLoad];
  UIBarButtonItem *quitButton = [[UIBarButtonItem alloc] initWithTitle:@"Quit"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(quitGameResponder)];
  self.navigationItem.rightBarButtonItem = quitButton;
}

- (void)viewWillAppear:(BOOL)animated
{
  [self.view setIsAccessibilityElement:YES];
  [self.view setAccessibilityTraits:UIAccessibilityTraitAllowsDirectInteraction];
  [self.view becomeFirstResponder];
  if (didDisplaySummary) {
    [self.navigationItem setHidesBackButton:NO animated:NO];
  }
}

- (void)viewDidAppear:(BOOL)animated
{
  [voiceOverQueue removeAllObjects];
  UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.view);
  [gameEngine generateForLevel:[gameEngine currentLevel]];
  [self setTitle:[NSString stringWithFormat:@"Level %d, %d numbers", [gameEngine currentLevel], [gameEngine numbersPerLevel]]];
  NSLog(@"gameid: %d", [gameEngine gameId]);
  [self updateCurrentNumber];
  [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(voiceOverAnnouceCurrentGameState) userInfo:nil repeats:NO];
  startTime = [[NSDate alloc] init];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma setters
- (void)setStartingLevel:(int)level
{
  startingLevel = level;
}


- (void)resetGameViewController
{
  [gameEngine resetGame];
  [self resetAllVariables];
  [self updateCurrentNumber];
  [self updateLevelDisplay];
}

- (void)resetAllVariables
{
  tapped = -1;
  [curInput setString:@""];
  [self.inputNumber setText:curInput];
}

#pragma mark touch handlers
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  if (numberStartTime == nil) {
    numberStartTime = [NSDate date];
  }
  startTouch = [[event allTouches] count];
  [gestureDetectorManager touchesBegan:touches withEvent:event inView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  NSUInteger tempTaps = [[event allTouches] count];
  if (tempTaps != startTouch) {
    hasMoved = YES;
  }
  [gestureDetectorManager touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  [gestureDetectorManager touchesEnded:touches withEvent:event inView:self.view];
  [self.navigationItem setHidesBackButton:YES animated:YES];
  [self logTapEvent:event];
  hasMoved = NO;
}

- (void)handleGesture:(GestureType)type withArgument:(NSInteger)arg
{
  [gestureDetectorManager setDidDetectGesture:YES];
  NSInteger val = arg;
  NSLog(@"GameViewController: val: %d, type: %d", val, type);
  if (type == BACKSPACE) {
    [self backspace];
  } else if (type == NATURAL) {
    if (val == -1) {
      // play a click sound, we are still waiting for something
      AudioServicesPlaySystemSound(clickSound);
    } else if (val == -2) {
      AudioServicesPlaySystemSound(doubleClickSound);
    } else {
      // it's a digit, append it to the current number
      UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, [NSString stringWithFormat:@"%d", val]);
      [curInput appendFormat:@"%d", val];
      NSLog(@"curInput: %@", curInput);
      [self.inputNumber setText:curInput];
    }
  } else if (type == LESS_NATURAL) {
    if (val == -1) {
      // play one click sound, we are still waiting for another gesture
      AudioServicesPlaySystemSound(clickSound);
      // we are waiting from the 10 side
    } else if (val == -2) {
      AudioServicesPlaySystemSound(doubleClickSound);
    } else {
      // it's a digit, append it to the current number
      UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, [NSString stringWithFormat:@"%d", val]);
      [curInput appendFormat:@"%d", val];
      [self.inputNumber setText:curInput];
    }
  }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
  switch (recognizer.state) {
    case UIGestureRecognizerStateBegan: {
      if ([gameEngine state] == ACTIVE && !hasMoved) {
        NSLog(@"%@", numberStartTime);
        NSTimeInterval interval = [numberStartTime timeIntervalSinceNow];
        [gameEngine inputNumber:[curInput intValue] withTime:interval];
        [self resetAllVariables];
        [self.navigationItem setHidesBackButton:YES animated:YES];
        numberStartTime = nil;
      }
      break;
    }
    default:
      break;
  }
}

#pragma SummaryViewControllerProtocol
- (void)nextLevel
{
  [gameEngine nextLevel];
}

- (void)quitGame
{
  [self.navigationController popToRootViewControllerAnimated:YES];
  didDisplaySummary = NO;
  [self logEvent:GAME_END andParams:@""];
}

#pragma AlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 1) {
    [self quitGame];
  }
  [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

#pragma mark helper methods
- (void)quitGameResponder
{
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Quit Game Confirmation" message:@"Are you sure you want to quit?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
  [alertView show];
}

- (void)updateCurrentNumber
{
  if (UIAccessibilityIsVoiceOverRunning()) {
    [voiceOverQueue removeAllObjects];
    [self addDigitsToVoiceOverQueue:[gameEngine currentNumber]];
  }
  [self.currentNumber setText:[NSString stringWithFormat:@"%d", [gameEngine currentNumber]]];
  [self logEvent:NUMBER_PRESENTED andParams:[NSString stringWithFormat:@"%d", [gameEngine currentNumber]]];
}

- (void)updateLevelDisplay
{
  [self.levelLabel setText:[NSString stringWithFormat:@"%d", [gameEngine currentLevel]]];
}

#pragma notification methods
- (void)setupNotificationReceivers
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(numberChanged:) name:@"numberChanged" object:gameEngine];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameStarted:) name:@"gamestarted" object:gameEngine];
  // brings up a summary view
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(levelCompleted:) name:@"levelCompleted" object:gameEngine];
  // continues the game
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(levelChanged:) name:@"levelGenerated" object:gameEngine];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wrongNumber:) name:@"wrongTrail" object:gameEngine];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(correctNumber:) name:@"correctTrail" object:gameEngine];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondAfterVoiceOverDidFinishReading:) name:UIAccessibilityAnnouncementDidFinishNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlayerId:) name:@"UserRegistered" object:gameInfoManager];
}

- (void)correctNumber:(NSNotification *)notification
{
  AudioServicesPlaySystemSound(correctSound);
}

- (void)wrongNumber:(NSNotification *)notification
{
  // PLAY WRONG SOUND
  AudioServicesPlaySystemSound(wrongSound);
}

- (void)gameStarted:(NSNotification *)notification
{
}

- (void)updatePlayerId:(NSNotification *)notification
{
  playerId = [gameInfoManager getPlayerId];
  NSLog(@"updated playerId with %d", playerId);
}

// backspace
- (void)backspace
{
  if ([curInput length] != 0) {
    if ([curInput length] == 1) {
      [curInput setString:@""];
    } else {
      [curInput setString:[[curInput substringToIndex:[curInput length] - 1] copy]];
    }
    [self.inputNumber setText:curInput];
  }
}

/**
 * Logging methods
 */
- (void)logTapEvent:(UIEvent *)event
{
  NSSet *allTouches = [event allTouches];
  NSMutableString *params = [NSMutableString stringWithFormat:@"numTouches: %d, ", [allTouches count]];
  int counter = 1;
  for (UITouch *touch in allTouches) {
    CGPoint location = [touch locationInView:self.view];
    [params appendFormat:@"[x%d:%f, y%d:%f] ", counter, location.x, counter, location.y];
    counter++;
  }
  [self logEvent:GESTURE_TAP andParams:params];
}

- (void)logEvent:(Type)eventType andParams:(NSString *)params
{
    NSDate *curDate = [NSDate date];
    NSTimeInterval diff = [curDate timeIntervalSinceDate:startTime];
    [logger logWithEvent:eventType andParams:params andUID:playerId andGameId:[gameEngine gameId] andTaskId:[gameEngine taskId] andTime:diff andIsVoiceOverOn:UIAccessibilityIsVoiceOverRunning()];
}

- (void)levelCompleted:(NSNotification *)notification
{
  // Display another view that shows the summary of the round
  [self.view setAccessibilityTraits:UIAccessibilityTraitNone];
  [self.view resignFirstResponder];
  [summaryViewController setDisplayNextLevel:([gameEngine currentLevel] < [gameEngine getMaxLevel])];
  [self presentViewController:summaryViewController animated:YES completion:nil];
  UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, summaryViewController.view);
  [self logEvent:LEVEL_END andParams:@""];
}

- (void)numberChanged:(NSNotification *)notification
{
  [curInput setString:@""];
  NSLog(@"number Changed");
  [self updateCurrentNumber];
  [self respondAfterVoiceOverDidFinishReading:nil];
}

- (void)addDigitsToVoiceOverQueue:(int)number
{
  while (number > 0) {
    int digit = number % 10;
    number /= 10;
    [voiceOverQueue addObject:[NSString stringWithFormat:@"%d", digit]];
  }
}

- (void)voiceOverAnnouceCurrentGameState
{
  NSString *message = [NSString stringWithFormat:@"Level %d, with %d numbers", [gameEngine currentLevel], [gameEngine numbersPerLevel]];
  UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, message);
}

- (void)levelChanged:(NSNotification *)notification
{
  [self updateCurrentNumber];
  [self updateLevelDisplay];
}

@end

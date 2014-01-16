//
//  GameViewController.m
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 2/16/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "GameViewController.h"

#import "../GameModel/GameInformationManager.h"

static NSString * const kQuitGame = @"Are you sure you want to quit?";
static NSString * const kCancel = @"Cancel";
static NSString * const kYes = @"Yes";

@interface GameViewController ()

@end

@implementation GameViewController

- (id)init
{
  self = [super init];
  if (self) {

  }
  return self;
}

// For [storyboard initializeViewController] to work.
- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
  }
  return self;
}

// Using .xib file.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)setupViewController
{
  gameEngine = [GameEngine getInstance];
  gameInfoManager = [GameInformationManager getInstance];
  playerId = [gameInfoManager getPlayerId];
  NSLog(@"playerId: %d", playerId);
  curInput = [[NSMutableString alloc] init];
  summaryViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:NULL] instantiateViewControllerWithIdentifier:@"SummaryViewController"];
  voiceOverQueue = [[NSMutableArray alloc] init];
  [summaryViewController setDelegate:self];
  [gameEngine resetGame];
  [self setupNotificationReceivers];
  [self setupSoundPlayers];
  [self.numberLabel setText:@""];
  didDisplaySummary = NO;
  logger = [Logger getInstance];
  numberStartTime = nil;
  UIGestureRecognizer *longPressRec = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
  [self.view addGestureRecognizer:longPressRec];
  hasMoved = NO;
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
- (void)voiceOverReadEachDigit:(NSNotification *)notification
{
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
  [self setupViewController];
  UIBarButtonItem *quitButton = [[UIBarButtonItem alloc] initWithTitle:@"Quit"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(quitGameResponder)];
  self.navigationItem.rightBarButtonItem = quitButton;
  
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }
}

- (void)viewWillAppear:(BOOL)animated
{
  [self.view setIsAccessibilityElement:YES];
  [self.view setAccessibilityTraits:UIAccessibilityTraitAllowsDirectInteraction];
  [self.view becomeFirstResponder];
  if (didDisplaySummary) {
    [self.navigationItem setHidesBackButton:NO animated:NO];
  } else {
    [gameEngine generateForLevel:[gameEngine currentLevel]];
    [self setTitle:[NSString stringWithFormat:@"Level %d", [gameEngine currentLevel]]];
  }
}

- (void)viewDidAppear:(BOOL)animated
{
  UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.view);
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
  pressedQuit = NO;
}

- (void)resetAllVariables
{
  tapped = -1;
  didDisplaySummary = NO;
  [curInput setString:@""];
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
  [self.descriptionLabel setText:@"Current Input"];
}

/**
 * This is where the screen update and gesture parsing takes place.
 */
- (void)handleGesture:(GestureType)type withArgument:(NSInteger)arg
{
  [gestureDetectorManager setDidDetectGesture:YES];
  NSInteger val = arg;
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
      [self.numberLabel setText:curInput];
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
      [self.numberLabel setText:curInput];
    }
  }
}

/**
 *  For handling the submit gesture. This is a special case that is hard to be handled.
 */
- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
  switch (recognizer.state) {
    case UIGestureRecognizerStateBegan: {
      if ([gameEngine state] == ACTIVE && !hasMoved) {
        NSTimeInterval interval = fabs([numberStartTime timeIntervalSinceNow]);
        NSInteger userInput = [curInput intValue];
        if ([curInput isEqualToString:@""]) {
          userInput = -1;
        }
        [self logEvent:NUMBER_ENTERED andParams:curInput];
        [gameEngine inputNumber:userInput withTime:interval];
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
  [self resetAllVariables];
  [gameEngine nextLevel];
}

- (void)quitGame
{
  [self.navigationController popToRootViewControllerAnimated:YES];
  [self logEvent:GAME_END andParams:@""];
  pressedQuit = YES;
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
// delegate method for quit
- (void)quitGameResponder
{
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kQuitGame message:@"" delegate:self cancelButtonTitle:kCancel otherButtonTitles:kYes , nil];
  [alertView show];
}

// updates the current number display
- (void)updateCurrentNumber
{
  if (UIAccessibilityIsVoiceOverRunning() && [[self.navigationController visibleViewController] isEqual:self]) {
    [voiceOverQueue removeAllObjects];
    [self addDigitsToVoiceOverQueue:[gameEngine currentNumber]];
  }
  [self.numberLabel setText:[gameEngine currentNumber]];
  [self logEvent:NUMBER_PRESENTED andParams:[gameEngine currentNumber]];
  [self.descriptionLabel setText:@"Current Number"];
}

// updates the level display
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
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voiceOverReadEachDigit:) name:UIAccessibilityAnnouncementDidFinishNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlayerId:) name:@"UserRegistered" object:gameInfoManager];
}

/**
 * Play the sounds for different states
 */
- (void)correctNumber:(NSNotification *)notification
{
  AudioServicesPlaySystemSound(correctSound);
}

- (void)wrongNumber:(NSNotification *)notification
{
  AudioServicesPlaySystemSound(wrongSound);
}

- (void)gameStarted:(NSNotification *)notification
{
  [self logEvent:GAME_START andParams:@""];
}

- (void)updatePlayerId:(NSNotification *)notification
{
  playerId = [gameInfoManager getPlayerId];
}

// backspace
- (void)backspace
{
  if ([curInput isEqualToString:@""]) {
    // The player hasn't put the number in, repeat the number.
    [voiceOverQueue removeAllObjects];
    [self addDigitsToVoiceOverQueue:[gameEngine currentNumber]];
    [self voiceOverReadEachDigit:nil];
    [self.numberLabel setText:[gameEngine currentNumber]];
    [self.descriptionLabel setText:@"Current Number"];
  } else {
    // Delete the number accordingly.
    if ([curInput length] != 0) {
      NSString *message;
      if ([curInput length] == 1) {
        message = [NSString stringWithFormat:@"%c", [curInput characterAtIndex:0]];
        [curInput setString:@""];
      } else {
        message = [NSString stringWithFormat:@"%c", [curInput characterAtIndex:([curInput length] - 1)]];
        [curInput setString:[[curInput substringToIndex:[curInput length] - 1] copy]];
      }
      UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, message);
      [self.numberLabel setText:curInput];
    }
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

// log an event
- (void)logEvent:(Type)eventType andParams:(NSString *)params
{
  NSDate *curDate = [NSDate date];
  NSTimeInterval diff = [curDate timeIntervalSinceDate:startTime];
  [logger logWithEvent:eventType andParams:params andUID:playerId andGameId:[gameEngine gameId] andTaskId:[gameEngine taskId] andTime:diff andIsVoiceOverOn:UIAccessibilityIsVoiceOverRunning()];
}

// responder when the level is completed
- (void)levelCompleted:(NSNotification *)notification
{
  // Display another view that shows the summary of the round
  [gestureDetectorManager reset];
  [self.view setAccessibilityTraits:UIAccessibilityTraitNone];
  [self.view resignFirstResponder];
  [summaryViewController setDisplayNextLevel:([gameEngine currentLevel] < [gameEngine getMaxLevel])];
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:summaryViewController];
  [self presentViewController:navController animated:YES completion:nil];
  UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, summaryViewController.view);
  [self logEvent:LEVEL_END andParams:@""];
}

// responder when the number changes
- (void)numberChanged:(NSNotification *)notification
{
  [gestureDetectorManager reset];
  [curInput setString:@""];
  [self updateCurrentNumber];
  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(voiceOverReadEachDigit:) userInfo:nil repeats:NO];
}

// adds each digit to the voice over queue
- (void)addDigitsToVoiceOverQueue:(NSString *)number
{
  for (int index = [number length] - 1; index >= 0; --index) {
    char curCharacter = [number characterAtIndex:index];
    [voiceOverQueue addObject:[NSString stringWithFormat:@"%c", curCharacter]];
  }
}

// announces the current game state
- (void)voiceOverAnnouceCurrentGameState
{
  if ([[self.navigationController visibleViewController] isEqual:self]) {
    NSString *message = [NSString stringWithFormat:@"Level %d", [gameEngine currentLevel]];
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, message);
  }
}

// responder when the level changes
- (void)levelChanged:(NSNotification *)notification
{
  [self logEvent:LEVEL_START andParams:@""];
  [self updateCurrentNumber];
  [self updateLevelDisplay];
}

@end

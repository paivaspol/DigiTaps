//
//  GameViewController.m
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 2/16/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@end

@implementation GameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    gameEngine = [GameEngine getInstance];
    curInput = [[NSMutableString alloc] init];
    summaryViewController = [[SummaryViewController alloc] initWithNibName:@"SummaryViewController" bundle:[NSBundle mainBundle]];
    voiceOverQueue = [[NSMutableArray alloc] init];
    [summaryViewController setDelegate:self];
    [gameEngine resetGame];
    [self setupNotificationReceivers];
    [self setupSoundPlayers];
    didDisplaySummary = NO;
  }
  return self;
}

- (void)setupSoundPlayers
{
  NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"Correct" withExtension:@"wav"];
  AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(soundURL), &correctSound);
  soundURL = [[NSBundle mainBundle] URLForResource:@"Wrong" withExtension:@"wav"];
  AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(soundURL), &wrongSound);
  soundURL = [[NSBundle mainBundle] URLForResource:@"Backspace" withExtension:@"wav"];
  AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(soundURL), &backspaceSound);
  soundURL = [[NSBundle mainBundle] URLForResource:@"Click" withExtension:@"wav"];
  AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(soundURL), &clickSound);
  soundURL = [[NSBundle mainBundle] URLForResource:@"DoubleClick" withExtension:@"wav"];
  AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(soundURL), &doubleClickSound);
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
  UILongPressGestureRecognizer *longPressRec = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
  [longPressRec setNumberOfTouchesRequired:1];
  [longPressRec setMinimumPressDuration: MENU_WAIT_TIME];
  [self.view addGestureRecognizer:longPressRec];
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

- (void)setIsNatural:(BOOL)natural
{
  isMoreNatural = natural;
}

- (void)resetGameViewController
{
  [gameEngine resetGame];
  [self updateCurrentNumber];
  [self updateLevelDisplay];
}

- (void)resetAllVariables
{
  isWaitingForInput = NO;
  hasStarted = NO;
  hasMoved = NO;
  startTouch = -1;
  currentSum = 0;
  tapped = -1;
  [curInput setString:@""];
  [self.inputNumber setText:curInput];
}

#pragma mark touch handlers
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  startTouch = [[event allTouches] count];
  UITouch *touch = [touches anyObject];
  startTouchPosition = [touch locationInView:self.view];
  hasStarted = true;
  hasMoved = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  NSUInteger tempTaps = [[event allTouches] count];
  if (startTouch < tempTaps) {
    hasMoved = YES;
    startTouch = tempTaps;
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  // A touch is done
  if ([gameEngine state] != ACTIVE) {
    return;
  }
  
  hasMoved = NO;
  
  UITouch *touch = [touches anyObject];
  CGPoint currentTouchPosition = [touch locationInView:self.view];
  
  NSUInteger tempTaps = [[event allTouches] count];
  if (startTouch < tempTaps) {
    startTouch = tempTaps;
  }
  
  // Backspace detection
  if (fabsf(startTouchPosition.x - currentTouchPosition.x) >= HORZ_SWIPE
      && (startTouch == 2) && fabs(currentTouchPosition.x - startTouchPosition.x) > TAP_THRESHOLD) {
    if (startTouchPosition.x > currentTouchPosition.x) {
      // swipe left
      if (currentSum == 0) {
        [self backspace];
      } else {
        // there's something in memory, clear it out first
        currentSum = 0;
      }
    }
    AudioServicesPlaySystemSound(backspaceSound);
  }
  
  int val = -1;
  if (isMoreNatural) {
    if ((fabsf(currentTouchPosition.y - startTouchPosition.y) >= VERT_SWIPE_DRAG_MAX)
        && (startTouch == 1)) {
      [curInput appendFormat:@"%d", currentSum];
      val = currentSum;
      currentSum = 0;
      isWaitingForInput = NO;
    } else if (fabs(currentTouchPosition.x - startTouchPosition.x) <= TAP_THRESHOLD) {
      // a tap
      val = [self naturalGestureHandler];
    }
  } else {
    [self lessNaturalGestureHandler:&val currentTouchPosition:currentTouchPosition];
  }
  
  if (isWaitingForInput && currentSum == 6) {
    
  } else if (isWaitingForInput) {
    AudioServicesPlaySystemSound(clickSound);
  }
  
  if (val != -1) {
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, [NSString stringWithFormat:@"%d", val]);
  }
  hasStarted = false;
  startTouch = -1;
  [self.inputNumber setText:curInput];
  [self.navigationItem setHidesBackButton:YES animated:YES];
}

# pragma gesture detection handlers

- (void)lessNaturalGestureHandler:(int *)val_p currentTouchPosition:(CGPoint)currentTouchPosition
{
  if (fabsf(currentTouchPosition.y - startTouchPosition.y) >= VERT_SWIPE_DRAG_MAX && (startTouch == 1)) {
    // a flick, put it in a waiting state
    if (isWaitingForInput) {
      isWaitingForInput = NO;
      [curInput appendFormat:@"%d", currentSum];
      *val_p = currentSum;
    } else {
      isWaitingForInput = YES;
      currentSum = 0;
      AudioServicesPlaySystemSound(doubleClickSound);
    }
  } else if (fabs(currentTouchPosition.x - startTouchPosition.x) <= TAP_THRESHOLD) {
    if (isWaitingForInput) {
      if (currentSum == 0) {
        *val_p = 10 - startTouch;
      } else {
        *val_p = currentSum + startTouch;
        currentSum = 0;
      }
      [curInput appendFormat:@"%d", *val_p];
      isWaitingForInput = NO;
      
    } else if (startTouch == 3) {
      currentSum += startTouch;
      isWaitingForInput = YES;
      AudioServicesPlaySystemSound(clickSound);
    } else {
      isWaitingForInput = NO;
      *val_p = currentSum + startTouch;
      currentSum = 0;
      [curInput appendFormat:@"%d", *val_p];
    }
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

// backspace
- (void)backspace
{
  if ([curInput length] != 0) {
    NSString *deletedString = [NSString stringWithFormat:@"%c", [curInput characterAtIndex:[curInput length] - 1]];
    if ([curInput length] == 1) {
      [curInput setString:@""];
    } else {
      [curInput setString:[[curInput substringToIndex:[curInput length] - 1] copy]];
    }
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, deletedString);
  }
}

// Logic for getting the number, return the number inputted
- (int)naturalGestureHandler
{
  int val = -1;
  if (isMoreNatural) {
    // general case, input numbers
    if (startTouch == TAPS && currentSum < 6) {
      isWaitingForInput = true;
      currentSum += TAPS;
      if (currentSum == 3) {
        AudioServicesPlaySystemSound(clickSound);
      } else {
        AudioServicesPlaySystemSound(doubleClickSound);
      }
    } else {
      val = currentSum + startTouch;
      NSLog(@"got: %d", val);
      [curInput appendFormat:@"%d", val];
      isWaitingForInput = false;
      currentSum = 0;
    }
  }
  return val;
}

- (void)updateCurrentNumber
{
  if (UIAccessibilityIsVoiceOverRunning()) {
    [voiceOverQueue removeAllObjects];
    NSLog(@"GameVC: %d", [gameEngine currentNumber]);
    [self addDigitsToVoiceOverQueue:[gameEngine currentNumber]];
  }
  [self.currentNumber setText:[NSString stringWithFormat:@"%d", [gameEngine currentNumber]]];
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
}

- (void)correctNumber:(NSNotification *)notification
{
  AudioServicesPlaySystemSound(correctSound);
}

- (void)wrongNumber:(NSNotification *)notification
{
  // PLAY WRONG SOUND
  NSLog(@"wrong!");
  AudioServicesPlaySystemSound(wrongSound);
}

- (void)gameStarted:(NSNotification *)notification
{
}

- (void)levelCompleted:(NSNotification *)notification
{
  // Display another view that shows the summary of the round
  [self.view setAccessibilityTraits:UIAccessibilityTraitNone];
  [self.view resignFirstResponder];
  [summaryViewController setDisplayNextLevel:([gameEngine currentLevel] < [gameEngine getMaxLevel])];
  [self presentViewController:summaryViewController animated:YES completion:nil];
  UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, summaryViewController.view);
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
  NSLog(@"GameVC: VoiceOver announceGameState");
  NSString *message = [NSString stringWithFormat:@"Level %d, with %d numbers", [gameEngine currentLevel], [gameEngine numbersPerLevel]];
  UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, message);
}

- (void)levelChanged:(NSNotification *)notification
{
  NSLog(@"levelChanged");
  [self updateCurrentNumber];
  [self updateLevelDisplay];
}

#pragma longPress handler
- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
  switch (recognizer.state) {
    case UIGestureRecognizerStateBegan: {
      if ([gameEngine state] == ACTIVE && !hasMoved) {
        [gameEngine inputNumber:[curInput intValue]];
        [self resetAllVariables];
        [self.navigationItem setHidesBackButton:YES animated:YES];
      }
      break;
    }
    default:
      break;
  }
}

@end

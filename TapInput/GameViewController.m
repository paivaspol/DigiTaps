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
    gameEngine = [[GameEngine alloc] init];
    curInput = [[NSMutableString alloc] init];
    summaryViewController = [[SummaryViewController alloc] initWithNibName:@"SummaryViewController" bundle:[NSBundle mainBundle]];
    [summaryViewController setDelegate:self];
    [gameEngine resetGame];
    [self setupNotificationReceivers];
    [self setupSoundPlayers];
    [self setTitle:@"Game"];
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
                                                                action:@selector(backButtonPressed)];
  self.navigationItem.rightBarButtonItem = quitButton;
  [gameEngine setStartingLevel:startingLevel];
  [gameEngine generateForLevel:[gameEngine currentLevel]];
}

- (void)viewWillAppear:(BOOL)animated
{
  [self.view setIsAccessibilityElement:YES];
  [self.view setAccessibilityTraits:UIAccessibilityTraitAllowsDirectInteraction];
  [self.view becomeFirstResponder];
  [self.navigationItem setHidesBackButton:NO animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
  [self updateCurrentNumber];
  [self voiceOverAnnouceCurrentGameState];
  NSString *message = [NSString stringWithFormat:@"Game Started"];
  UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, message);

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

#pragma mark touch handlers
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  NSLog(@"started with %d", [[event allTouches] count]);
  startTouch = [[event allTouches] count];
  UITouch *touch = [touches anyObject];
  startTouchPosition = [touch locationInView:self.view];
  hasStarted = true;
  hasMoved = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  NSLog(@"moved with %d", [[event allTouches] count]);
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
  NSLog(@"val: %d", val);
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
      NSLog(@"got: %d", currentSum);
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
      NSLog(@"got: %d", *val_p);
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
      NSLog(@"got: %d", *val_p);
      [curInput appendFormat:@"%d", *val_p];
    }
  }
}

#pragma SummaryViewControllerProtocol
- (void)nextLevel
{
  [gameEngine nextLevel];
  [gameEngine generateForLevel:[gameEngine currentLevel]];
}

- (void)quitGame
{
  [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark helper methods
// backspace
- (void)backspace
{
  if ([curInput length] != 0) {
    if ([curInput length] == 1) {
      [curInput setString:@""];
    } else {
      [curInput setString:[[curInput substringToIndex:[curInput length] - 1] copy]];
    }
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
  NSLog(@"game started VC");
}

- (void)levelCompleted:(NSNotification *)notification
{
  // Display another view that shows the summary of the round
  [self.view setAccessibilityTraits:UIAccessibilityTraitNone];
  [self.view resignFirstResponder];
  [summaryViewController setDisplayNextLevel:([gameEngine currentLevel] < [gameEngine getMaxLevel])];
  [self presentViewController:summaryViewController animated:YES completion:nil];
  UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, summaryViewController.view);
  NSString *message = [NSString stringWithFormat:@"Level %d completed", [gameEngine currentLevel]];
  UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, message);
}

- (void)numberChanged:(NSNotification *)notification
{
  [curInput setString:@""];
  NSLog(@"number Changed");
  [self updateCurrentNumber];
  NSString *message = [NSString stringWithFormat:@"Current number is %d", [gameEngine currentNumber]];
  UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, message);
}

- (void)voiceOverAnnouceCurrentGameState
{
  NSString *message = [NSString stringWithFormat:@"Level %d", [gameEngine currentLevel]];
  UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, message);
  message = [NSString stringWithFormat:@"Current number is %d", [gameEngine currentNumber]];
  UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, message);
}

- (void)levelChanged:(NSNotification *)notification
{
  NSLog(@"levelChanged");
  [self updateCurrentNumber];
  [self updateLevelDisplay];
  [self voiceOverAnnouceCurrentGameState];
}

#pragma longPress handler
- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
  switch (recognizer.state) {
    case UIGestureRecognizerStateBegan: {
      if ([gameEngine state] == ACTIVE && !hasMoved) {
        [gameEngine inputNumber:[curInput intValue]];
        [curInput setString:@""];
        [self.inputNumber setText:curInput];
        [self.navigationItem setHidesBackButton:YES animated:YES];
      }
      break;
    }
    default:
      break;
  }
}

- (void)backButtonPressed
{
  [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

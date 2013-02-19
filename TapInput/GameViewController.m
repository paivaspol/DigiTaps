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
}

#pragma view controller related
- (void)viewDidLoad
{
  [super viewDidLoad];
  UILongPressGestureRecognizer *longPressRec = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
  [longPressRec setNumberOfTouchesRequired:1];
  [longPressRec setMinimumPressDuration: MENU_WAIT_TIME];
  [self.view addGestureRecognizer:longPressRec];
}

- (void)viewWillAppear:(BOOL)animated
{
  [self.view setIsAccessibilityElement:YES];
  [self.view setAccessibilityTraits:UIAccessibilityTraitAllowsDirectInteraction];
  [self.view becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
  [gameEngine nextLevel];
  [self updateCurrentNumber];
  NSString *message = [NSString stringWithFormat:@"Game Started"];
  UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, message);
  [self voiceOverAnnouceCurrentGameState];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma setters
- (void)setStartingLevel:(int)level
{
  [gameEngine setStartingLevel:level];
}

- (void)setIsNatural:(BOOL)natural
{
  isMoreNatural = natural;
}

- (void)resetGameViewController
{
  [gameEngine resetGame];
}

#pragma mark touch handlers
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *touch = [touches anyObject];
  startTouchPosition = [touch locationInView:self.view];
  hasStarted = true;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  if ([gameEngine state] != ACTIVE) {
    return;
  }
  
  UITouch *touch = [touches anyObject];
  CGPoint currentTouchPosition = [touch locationInView:self.view];
  startTouch = [[event allTouches] count];
  
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
    } else if (fabs(currentTouchPosition.x - startTouchPosition.x) <= TAP_THRESHOLD) {
      // a tap
      val = [self inputDigit];
    }
  } else {
    if (fabsf(currentTouchPosition.y - startTouchPosition.y) >= VERT_SWIPE_DRAG_MAX && (startTouch == 1)) {
      // a flick, put it in a waiting state
      if (isWaitingForInput) {
        isWaitingForInput = NO;
        NSLog(@"got: %d", currentSum);
        [curInput appendFormat:@"%d", currentSum];
        val = currentSum;
      } else {
        isWaitingForInput = YES;
        currentSum = 0;
      }
    } else if (fabs(currentTouchPosition.x - startTouchPosition.x) <= TAP_THRESHOLD) {
      if (isWaitingForInput) {
        if (currentSum == 0) {
          val = 10 - startTouch;
        } else {
          val = currentSum + startTouch;
          currentSum = 0;
        }
        NSLog(@"got: %d", val);
        [curInput appendFormat:@"%d", val];
        isWaitingForInput = NO;
        
      } else if (startTouch == 3) {
        currentSum += startTouch;
        isWaitingForInput = YES;
      } else {
        isWaitingForInput = NO;
        val = currentSum + startTouch;
        currentSum = 0;
        NSLog(@"got: %d", val);
        [curInput appendFormat:@"%d", val];
      }
    }
  }
  if (val != -1) {
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, [NSString stringWithFormat:@"%d", val]);
  }
  hasStarted = false;
  NSLog(@"val: %d", val);
  [self.inputNumber setText:curInput];
}

#pragma SummaryViewControllerProtocol
- (void)nextLevel
{
  [gameEngine nextLevel];
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
- (int)inputDigit
{
  int val = -1;
  if (isMoreNatural) {
    // general case, input numbers
    if (startTouch == TAPS && currentSum < 6) {
      isWaitingForInput = true;
      currentSum += TAPS;
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
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(levelChanged:) name:@"levelChanged" object:gameEngine];
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
      if ([gameEngine state] == ACTIVE) {
        [gameEngine inputNumber:[curInput intValue]];
        [self.inputNumber setText:@""];
      }
      break;
    }
    default:
      break;
  }
}

#pragma IBAction
- (IBAction)backButtonPressed:(id)sender
{
  [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

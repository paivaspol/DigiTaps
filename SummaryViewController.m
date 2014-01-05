//
//  SummaryViewController.m
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 2/3/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "SummaryViewController.h"

#import "GameCenterManager.h"

@interface SummaryViewController ()

@end

@implementation SummaryViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
  }
  return self;
}

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
  logger = [Logger getInstance];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setupViewController];
  UIBarButtonItem *quit = [[UIBarButtonItem alloc]
                                 initWithTitle:@"Menu"
                                 style:UIBarButtonItemStyleBordered target:self action:@selector(quitButton:)];    
  self.navigationItem.leftBarButtonItem = quit;
  self.title = @"Summary";
  
  // make sure that iOS7 display it properly :)
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }
  // Do any additional setup after loading the view from its nib.
}

- (BOOL)canBecomeFirstResponder
{
  return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
  int64_t score = (int64_t) [gameEngine getLevelPoint];
  [self.numbersCorrect setText:[NSString stringWithFormat:@"Correct: %d", [gameEngine correct]]];
  [self.numbersWrong setText:[NSString stringWithFormat:@"Wrong: %d", [gameEngine miss]]];
  [self.accuracy setText:[NSString stringWithFormat:@"Accuracy: %@", [gameEngine getAccurancyRate]]];
  [self.point setText:[NSString stringWithFormat:@"%lld", score]];
  [self.avgTimeLabel setText:[NSString stringWithFormat:@"Time per Number: %.3fs", [gameEngine getAverageTimeUsed]]];
  [GameCenterManager reportScore:score forCategory:[NSString stringWithFormat:@"level%d", [gameEngine currentLevel]]];
  
  if ([gameEngine currentLevel] < [gameEngine getMaxLevel]) {
    UIBarButtonItem *next = [[UIBarButtonItem alloc]
                             initWithTitle:@"Next"
                             style:UIBarButtonItemStyleBordered target:self action:@selector(nextLevelButton:)];
    self.navigationItem.rightBarButtonItem = next;
    
    [next setIsAccessibilityElement:YES];
    [next setAccessibilityTraits:UIAccessibilityTraitButton];
    [next setAccessibilityLabel:@"Next Level"];
    [next setAccessibilityHint:@"Next Level"];
  }
  
  if ([gameEngine currentLevel] >= [gameEngine getMaxLevel]) {
    // hide the next button
    self.navigationItem.rightBarButtonItem = nil;
  }
}

- (void)viewDidAppear:(BOOL)animated
{
  [self becomeFirstResponder];
  [logger sendLogsToServer];
  [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(voiceOverAnnouceCurrentGameState) userInfo:nil repeats:NO];
}

- (void)voiceOverAnnouceCurrentGameState
{
  NSString *summaryText = [NSString stringWithFormat:@"%d correct, %d wrong", [gameEngine correct], [gameEngine miss]];
  NSString *message = [NSString stringWithFormat:@"Level %d completed. %@", [gameEngine currentLevel], summaryText];
  UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, message);
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)quitButton:(id)sender {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to quit?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
  [alertView show];
}

- (void)nextLevelButton:(id)sender {
  if ([self.delegate respondsToSelector:@selector(nextLevel)]) {
    [self.delegate nextLevel];
    [self dismissViewControllerAnimated:YES completion:nil];
  }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 1) {
    if ([self.delegate respondsToSelector:@selector(quitGame)]) {
      [self.delegate quitGame];
      [self dismissViewControllerAnimated:YES completion:nil];
    }
  }
}

- (void)setDisplayNextLevel:(BOOL)shouldDisplay
{
  shouldDisplayNextButton = shouldDisplay;
}

@end

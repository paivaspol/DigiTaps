//
//  SummaryViewController.m
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 2/3/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "SummaryViewController.h"

#import "GameCenterManager.h"

@interface SummaryViewController ()

@end

@implementation SummaryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    gameEngine = [GameEngine getInstance];
    logger = [Logger getInstance];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.nextBut setIsAccessibilityElement:YES];
  [self.nextBut setAccessibilityTraits:UIAccessibilityTraitButton];
  [self.nextBut setAccessibilityLabel:@"Next Level"];
  [self.nextBut setAccessibilityHint:@"Next Level"];
  
  UIBarButtonItem *quit = [[UIBarButtonItem alloc]
                                 initWithTitle:@"Menu"
                                 style:UIBarButtonItemStyleBordered target:self action:@selector(quitButton:)];
  
  UIBarButtonItem *next = [[UIBarButtonItem alloc]
                                 initWithTitle:@"Next"
                                 style:UIBarButtonItemStyleBordered target:self action:@selector(nextLevelButton:)];
  
  self.navigationItem.leftBarButtonItem = quit;
  self.navigationItem.rightBarButtonItem = next;
  
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
  [self.nextBut setEnabled:shouldDisplayNextButton];
  [self.numbersCorrect setText:[NSString stringWithFormat:@"%d", [gameEngine correct]]];
  [self.numbersWrong setText:[NSString stringWithFormat:@"%d", [gameEngine miss]]];
  [self.accuracy setText:[gameEngine getAccurancyRate]];
  int64_t score = (int64_t) [gameEngine getLevelPoint];
  [self.point setText:[NSString stringWithFormat:@"%lld", score]];
  [GameCenterManager reportScore:score forCategory:[NSString stringWithFormat:@"level%d", [gameEngine currentLevel]]];
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

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
  UIBarButtonItem *quit = [[UIBarButtonItem alloc]
                                 initWithTitle:@"Menu"
                                 style:UIBarButtonItemStyleBordered target:self action:@selector(quitButton:)];    
  self.navigationItem.leftBarButtonItem = quit;

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
  self.title = @"Summary";
  
  // make sure that iOS7 display it properly :)
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }
  // Do any additional setup after loading the view from its nib.
  _currentView = self.view;
  UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
  [self setUpViewForOrientation:interfaceOrientation];
}

- (BOOL)canBecomeFirstResponder
{
  return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
  [self.landscapeNumbersCorrect setText:[NSString stringWithFormat:@"%d", [gameEngine correct]]];
  [self.landscapeNumbersWrong setText:[NSString stringWithFormat:@"%d", [gameEngine miss]]];
  [self.landscapeAccuracy setText:[gameEngine getAccurancyRate]];
  int64_t score = (int64_t) [gameEngine getLevelPoint];
  [self.landscapePoint setText:[NSString stringWithFormat:@"%lld", score]];
  [self.portraitNumbersCorrect setText:[NSString stringWithFormat:@"%d", [gameEngine correct]]];
  [self.portraitNumbersWrong setText:[NSString stringWithFormat:@"%d", [gameEngine miss]]];
  [self.portraitAccuracy setText:[gameEngine getAccurancyRate]];
  [self.portraitPoint setText:[NSString stringWithFormat:@"%lld", score]];
  [GameCenterManager reportScore:score forCategory:[NSString stringWithFormat:@"level%d", [gameEngine currentLevel]]];
  
  if ([gameEngine currentLevel] < [gameEngine getMaxLevel]) {
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
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
  [self setUpViewForOrientation:toInterfaceOrientation];
}

-(void)setUpViewForOrientation:(UIInterfaceOrientation)orientation
{
  [_currentView removeFromSuperview];
  if (UIInterfaceOrientationIsLandscape(orientation)) {
    if (![self.view isEqual:_landscapeView]) {
      [self.view addSubview:_landscapeView];
      _landscapeView.frame = self.view.bounds;
      _currentView = _landscapeView;
      [self.view setNeedsLayout];
    }
  } else {
    if (![self.view isEqual:_portraitView]) {
      [self.view addSubview:_portraitView];
      _portraitView.frame = self.view.bounds;
      _currentView = _portraitView;
      [self.view setNeedsLayout];
    }
  }
}


@end

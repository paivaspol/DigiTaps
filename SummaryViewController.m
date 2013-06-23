//
//  SummaryViewController.m
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 2/3/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "SummaryViewController.h"

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
  NSArray *points = [gameEngine getPoints];
  NSMutableString *str = [[NSMutableString alloc] init];
  for (int i = 0; i < [points count]; i++) {
    NSInteger pt = [[points objectAtIndex:i] intValue];
    [str appendFormat:@"%d: %d\n", i, pt];
  }
  [self.display setText:[str description]];
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

- (IBAction)quitButton:(id)sender {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to quit?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
  [alertView show];
}

- (IBAction)nextLevelButton:(id)sender {
  if ([self.delegate respondsToSelector:@selector(nextLevel)]) {
    [self.delegate nextLevel];
    [self dismissViewControllerAnimated:YES completion:nil];
  }
}

- (IBAction)postData:(id)sender {

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

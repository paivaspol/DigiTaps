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
    // Custom initialization
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
}

- (void)viewDidAppear:(BOOL)animated
{
  [self becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)quitButton:(id)sender {
  if ([self.delegate respondsToSelector:@selector(quitGame)]) {
    [self.delegate quitGame];
    [self dismissViewControllerAnimated:YES completion:nil];
  }
}

- (IBAction)nextLevelButton:(id)sender {
  if ([self.delegate respondsToSelector:@selector(nextLevel)]) {
    [self.delegate nextLevel];
    [self dismissViewControllerAnimated:YES completion:nil];
  }
}

- (void)setDisplayNextLevel:(BOOL)shouldDisplay
{
  shouldDisplayNextButton = shouldDisplay;
}

@end

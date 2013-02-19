//
//  StartMenuViewController.m
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 2/16/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "StartMenuViewController.h"

@interface StartMenuViewController ()

@end

@implementation StartMenuViewController

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
  [self.navigationController setNavigationBarHidden:YES];
  [self initializeViewControllers];
  UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"Tap input game");
  // Do any additional setup after loading the view from its nib.
}

- (void)initializeViewControllers
{
  gameEngine = [[GameEngine alloc] init];
  userAgreementViewController = [[UserAgreementViewController alloc] init];
  modeSelectorViewController = [[ModeSelectorViewController alloc] init];
  [modeSelectorViewController setDelegate:self];
  levelSelectorViewController = [[LevelSelectorViewController alloc] initWithNumLevels:[gameEngine getMaxLevel]];
  [levelSelectorViewController setDelegate:self];
  gameViewController = [[GameViewController alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
  //[self presentViewController:userAgreementViewController animated:YES completion:nil];
  [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender {
  [self.navigationController pushViewController:levelSelectorViewController animated:YES];
  [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark UserAgreementVCProtocol
- (void)agreed
{

}

#pragma mark LevelSelectorViewControllerProtocol
- (void)startLevel:(int)level
{
  NSLog(@"Start Level");
  [self.navigationController pushViewController:modeSelectorViewController animated:YES];
  [gameViewController setStartingLevel:level - 1];
}

#pragma mark ModeSelectorProtocol
- (void)startGameWithNaturalMode:(BOOL)isNatural
{
  NSLog(@"starting game");
  [gameViewController setIsNatural:isNatural];
  [gameViewController resetGameViewController];
  [self.navigationController pushViewController:gameViewController animated:YES];
  [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end

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
}

- (void)initializeViewControllers
{
  gameEngine = [GameEngine getInstance];
  userAgreementViewController = [[UserAgreementViewController alloc] init];
  [userAgreementViewController setDelegate:self];
  modeSelectorViewController = [[ModeSelectorViewController alloc] init];
  [modeSelectorViewController setDelegate:self];
  levelSelectorViewController = [[LevelSelectorViewController alloc] initWithNumLevels:[gameEngine getMaxLevel]];
  [levelSelectorViewController setDelegate:self];
  gameViewController = [[GameViewController alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
//  [self presentViewController:userAgreementViewController animated:YES completion:nil];
  [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
  if (!CFPreferencesGetAppBooleanValue(showAgreementKey, kCFPreferencesCurrentApplication, &didAccept)) {
    didAccept = false;
  }
  if (!didAccept) {
    [self presentViewController:userAgreementViewController animated:YES completion:nil];
  }  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender {
  [self.navigationController pushViewController:modeSelectorViewController animated:YES];
  [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark UserAgreementVCProtocol
- (void)agreed
{
  NSLog(@"exec");
  didAccept = true;
  dispatch_queue_t updatePreferenceQueue = dispatch_queue_create("updatePref", NULL);
  dispatch_async(updatePreferenceQueue, ^{
    CFPreferencesSetAppValue(showAgreementKey, kCFBooleanTrue, kCFPreferencesCurrentApplication);
  });
}

#pragma mark LevelSelectorViewControllerProtocol
- (void)startLevel:(int)level
{
  [gameEngine setStartingLevel:level];
  [gameViewController resetGameViewController];
  [self.navigationController pushViewController:gameViewController animated:YES];
}

#pragma mark ModeSelectorProtocol
- (void)startGameWithNaturalMode:(BOOL)isNatural
{
  [gameViewController setIsNatural:isNatural];
  [self.navigationController pushViewController:levelSelectorViewController animated:YES];
}

@end

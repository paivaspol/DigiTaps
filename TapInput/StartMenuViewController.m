//
//  StartMenuViewController.m
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 2/16/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//
#import <GameKit/GameKit.h>

#import "StartMenuViewController.h"

#import "CoreDataModelWrapper.h"
#import "Event.h"

/* gesture managers */
#import "GestureDetectorManager.h"
#import "BackspaceGestureDetector.h"
#import "LessNaturalGestureDetector.h"
#import "NaturalGestureDetector.h"

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
  [self initializeViewControllers];
  [self.navigationController setNavigationBarHidden:YES];
  self.navigationController.navigationBar.tintColor = [UIColor grayColor];
  UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"Tap input game");
  
  // make sure that iOS7 display it properly :)
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }
}

- (void)initializeViewControllers
{
  gameEngine = [GameEngine getInstance];
  gameInfoManager = [GameInformationManager getInstance];
  userAgreementViewController = [[UserAgreementViewController alloc] init];
  [userAgreementViewController setDelegate:self];
  modeSelectorViewController = [[ModeSelectorViewController alloc] init];
  [modeSelectorViewController setDelegate:self];
  levelSelectorViewController = [[LevelSelectorViewController alloc] initWithNumLevels:[gameEngine getMaxLevel]];
  [levelSelectorViewController setDelegate:self];
  gameViewController = [[GameViewController alloc] init];
  demographicsViewController = [[DemographicsViewController alloc] init];
  [demographicsViewController setDelegate:self];
  registrationNavController = [[UINavigationController alloc] initWithRootViewController:userAgreementViewController];
  [registrationNavController.navigationItem setHidesBackButton:YES];
  gameCenterManager = [[GameCenterManager alloc] init];
  [gameCenterManager setDelegate:self];
  tutorialViewController = [[TutorialViewController alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
  [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
  if (![gameInfoManager didAgreeToAgreement]) {
    [self presentViewController:registrationNavController animated:YES completion:nil];
  }
  if ([GameCenterManager isGameCenterAvailable]) {
    [gameCenterManager authenticateLocalUser];
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender {
  UIButton *but = (UIButton *)sender;
  if ([but tag] == 0) {
    // show the tutorial
    [self.navigationController pushViewController:tutorialViewController animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
  } else if ([but tag] == 1) {
    // start the game! select the mode
    [self.navigationController pushViewController:modeSelectorViewController animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
  } else if ([but tag] == 2) {
    // leaderboard button, display the leaderboard
    [self displayLeaderboard:nil];
  }
}

#pragma mark UserAgreementVCProtocol
// fire after the user agree to the user agreement
- (void)agreed
{
  [gameInfoManager setAgreementPref:YES];
  [registrationNavController pushViewController:demographicsViewController animated:YES];
}

#pragma mark LevelSelectorViewControllerProtocol
- (void)startLevel:(int)level
{
  [gameEngine setStartingLevel:level];
  [gameViewController resetGameViewController];
  [self.navigationController pushViewController:gameViewController animated:YES];
}

#pragma mark Leaderboard display
- (void)displayLeaderboard: (NSString *)leaderboardID
{
  GKGameCenterViewController *gameCenterViewController = [[GKGameCenterViewController alloc] init];
  if (gameCenterViewController != nil) {
    gameCenterViewController.gameCenterDelegate = self;
    gameCenterViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
    [self presentViewController:gameCenterViewController animated:YES completion:nil];
  }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ModeSelectorProtocol
- (void)startGameWithNaturalMode:(BOOL)isNatural
{
  GestureDetectorManager *gdm = [[GestureDetectorManager alloc] init];
  DTGestureDetectionSharedState *sharedState = [[DTGestureDetectionSharedState alloc] init];
  DTGestureDetector *backspaceDetector = [[BackspaceGestureDetector alloc] initWithSharedState:sharedState];
  [gdm addGestureDetector:backspaceDetector];
  GestureDetector *tap;
  if (isNatural) {
    tap = [[NaturalGestureDetector alloc] initWithSharedState:sharedState];
  } else {
    tap = [[LessNaturalGestureDetector alloc] initWithSharedState:sharedState];
  }
  [gdm addGestureDetector:tap];
  [gameViewController setGestureDetectorManager:gdm];
  [self.navigationController pushViewController:levelSelectorViewController animated:YES];
}

#pragma mark DemographicsViewController
- (void)registerCompletedWithUserId:(int)uid{
  NSLog(@"registered");
}

- (IBAction)dumpLogs:(id)sender
{
  NSPersistentStoreCoordinator *coordinator = [CoreDataModelWrapper getPersistentStoreCoordinator];
  NSManagedObjectContext *objContext = [[NSManagedObjectContext alloc] init];
  [objContext setPersistentStoreCoordinator:coordinator];
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entityDescription = [[[CoreDataModelWrapper getManagedObjectModel] entitiesByName] objectForKey:@"Event"];
  [fetchRequest setEntity:entityDescription];
  
  NSError *e = nil;
  NSArray *result = [objContext executeFetchRequest:fetchRequest error:&e];
  if (!result) {
    [NSException raise:@"Fetch failed" format:@"Reason: %@", [e localizedDescription]];
  }
  for (Event *event in result) {
    NSLog(@"%@", event.eventType);
  }
}

- (IBAction)clearLogs:(id)sender {
  [CoreDataModelWrapper clearAllData];
}

#pragma mark GameCenterManagerProtocol
- (void)processGameCenterAuth:(NSError *)error
{
  NSLog(@"Authorized");
}

@end

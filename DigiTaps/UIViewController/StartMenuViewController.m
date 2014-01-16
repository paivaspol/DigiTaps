//
//  StartMenuViewController.m
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 2/16/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//
#import <GameKit/GameKit.h>

#import "StartMenuViewController.h"

#import "../Logging/CoreDataModelWrapper.h"
#import "../Logging/Event.h"

/* gesture managers */
#import "../GestureDetection/GestureDetectorManager.h"
#import "../GestureDetection/DTBackspaceGestureDetector.h"
#import "../GestureDetection/DTCappuccinoGestureDetector.h"
#import "../GestureDetection/DTEspressoGestureDetector.h"

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
  
  // make sure that iOS7 display it properly :)
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }
}

- (void)initializeViewControllers
{
  gameEngine = [GameEngine getInstance];
  gameInfoManager = [GameInformationManager getInstance];
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:NULL];
  userAgreementViewController = [storyboard instantiateViewControllerWithIdentifier:@"UserAgreementViewController"];
  [userAgreementViewController setDelegate:self];
  modeSelectorViewController = [storyboard instantiateViewControllerWithIdentifier:@"ModeSelectorViewController"];
  [modeSelectorViewController setDelegate:self];
  levelSelectorViewController = [[LevelSelectorViewController alloc] initWithNumLevels:[gameEngine getMaxLevel]];
  [levelSelectorViewController setDelegate:self];
  gameViewController = [storyboard instantiateViewControllerWithIdentifier:@"GameViewController"];
  demographicsViewController = [storyboard instantiateViewControllerWithIdentifier:@"DemographicsViewController"];
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
  NSLog(@"Selected mode");
  GestureDetectorManager *gdm = [[GestureDetectorManager alloc] init];
  DTGestureDetectionSharedState *sharedState = [[DTGestureDetectionSharedState alloc] init];
  DTGestureDetector *backspaceDetector = [[DTBackspaceGestureDetector alloc] initWithSharedState:sharedState];
  [gdm addGestureDetector:backspaceDetector];
  GestureDetector *tap;
  if (isNatural) {
    tap = [[DTEspressoGestureDetector alloc] initWithSharedState:sharedState];
  } else {
    tap = [[DTCappuccinoGestureDetector alloc] initWithSharedState:sharedState];
  }
  [gdm addGestureDetector:tap];
  [gameViewController setGestureDetectorManager:gdm];
  [self.navigationController pushViewController:levelSelectorViewController animated:YES];
}

#pragma mark DemographicsViewController
- (void)registerCompletedWithUserId:(int)uid{
  NSLog(@"registered with %d", uid);
}

/*
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
*/
 
#pragma mark GameCenterManagerProtocol
- (void)processGameCenterAuth:(NSError *)error
{
  NSLog(@"Authorized");
}

@end

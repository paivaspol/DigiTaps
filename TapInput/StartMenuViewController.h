//
//  StartMenuViewController.h
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 2/16/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DemographicsViewController.h"  // user demographics questionaire
#import "UserAgreementViewController.h" // user agreement modal vc
#import "ModeSelectorViewController.h"  // vc for selecting the mode
#import "LevelSelectorViewController.h" // level selector
#import "GameEngine.h"  // Game engine
#import "GameInformationManager.h"  // Game information manager
#import "GameViewController.h"  // Game view controller
#import "GameCenterManager.h"  // Game Center Manager
#import "TutorialViewController.h"

enum mode {
  TUTORIAL,
  REGULAR
} typedef Mode;

@interface StartMenuViewController : UIViewController
  < UserAgreementViewControllerProtocol,
    ModeSelectorProtocol,
    LevelSelectorProtocol,
    DemographicsViewControllerProtocol,
    GameCenterManagerProtocol,
    GKGameCenterControllerDelegate>
{
  @private
  UserAgreementViewController   *userAgreementViewController;
  ModeSelectorViewController    *modeSelectorViewController;
  LevelSelectorViewController   *levelSelectorViewController;
  GameViewController            *gameViewController;
  GameEngine                    *gameEngine;
  GameInformationManager        *gameInfoManager;
  DemographicsViewController    *demographicsViewController;
  TutorialViewController        *tutorialViewController;
  
  // flow control for user agreement and demographics
  UINavigationController        *registrationNavController;
  // game center manager
  GameCenterManager             *gameCenterManager;
}

@property (strong, nonatomic) IBOutlet UIButton *startGame;
@property (strong, nonatomic) IBOutlet UIButton *tutorial;
@property (strong, nonatomic) IBOutlet UIButton *dumpLogBut;
@property (strong, nonatomic) IBOutlet UIButton *clearLogs;

- (IBAction)buttonPressed:(id)sender;
- (IBAction)dumpLogs:(id)sender;
- (IBAction)clearLogs:(id)sender;

@end

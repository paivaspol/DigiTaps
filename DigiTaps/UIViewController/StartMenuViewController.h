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
#import "GameViewController.h"  // Game view controller
#import "../Tutorials/TutorialViewController.h"

#import "../GameCenter/GameCenterManager.h"  // Game Center Manager
#import "../GameModel/GameEngine.h"  // Game engine
#import "../GameModel/GameInformationManager.h"  // Game information manager

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

- (IBAction)buttonPressed:(id)sender;

@end

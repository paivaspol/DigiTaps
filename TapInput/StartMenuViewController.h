//
//  StartMenuViewController.h
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 2/16/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserAgreementViewController.h" // user agreement modal vc
#import "ModeSelectorViewController.h"  // vc for selecting the mode
#import "LevelSelectorViewController.h" // level selector
#import "GameEngine.h"  // Game engine
#import "GameViewController.h"  // Game view controller

enum mode {
  TUTORIAL,
  REGULAR
} typedef Mode;

@interface StartMenuViewController : UIViewController
  <UserAgreementViewControllerProtocol,
   ModeSelectorProtocol, LevelSelectorProtocol>
{
  @private
  UserAgreementViewController   *userAgreementViewController;
  ModeSelectorViewController    *modeSelectorViewController;
  LevelSelectorViewController   *levelSelectorViewController;
  GameViewController            *gameViewController;
  GameEngine                    *gameEngine;
}

@property (strong, nonatomic) IBOutlet UIButton *startGame;
@property (strong, nonatomic) IBOutlet UIButton *tutorial;

- (IBAction)buttonPressed:(id)sender;

@end

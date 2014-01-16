//
//  GameViewController.h
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 2/16/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

#import "../GameModel/GameEngine.h"
#import "../GameModel/GameInformationManager.h"
#import "../GestureDetection/GestureDetectorManager.h"
#import "../Logging/Logger.h"

#import "SummaryViewController.h"

@interface GameViewController : UIViewController<GestureDetectorManagerProtocol, SummaryViewControllerProtocol, UIAlertViewDelegate>
{
  @private
  GameEngine                  *gameEngine;
  GameInformationManager      *gameInfoManager;
  GestureDetectorManager      *gestureDetectorManager;
  SummaryViewController       *summaryViewController;
  Logger                      *logger;
  BOOL                        didDisplaySummary;
  int                         startingLevel;
  NSUInteger                  playerId;
  NSUInteger                  tapped;
  NSMutableString             *curInput;
  NSMutableArray              *voiceOverQueue;
  SystemSoundID               correctSound;
  SystemSoundID               wrongSound;
  SystemSoundID               backspaceSound;
  SystemSoundID               clickSound;
  SystemSoundID               doubleClickSound;
  NSDate                      *startTime;
  NSDate                      *numberStartTime;
  NSInteger                   startTouch;
  BOOL                        hasMoved;
  BOOL                        pressedQuit;
}

@property (strong, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong, nonatomic) IBOutlet UILabel *levelLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

- (void)setStartingLevel:(int)level;
- (void)resetGameViewController;
- (void)setGestureDetectorManager:(GestureDetectorManager *)manager;

@end

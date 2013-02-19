//
//  GameViewController.h
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 2/16/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

#import "GameEngine.h"
#import "SummaryViewController.h"

#define VERT_SWIPE_DRAG_MAX 85
#define HORZ_SWIPE          70
#define TAP_THRESHOLD       15
#define TAPS                3
#define MENU_WAIT_TIME      0.35

@interface GameViewController : UIViewController<SummaryViewControllerProtocol>
{
  @private
  GameEngine                  *gameEngine;
  BOOL                        isMoreNatural;
  BOOL                        isWaitingForInput;
  BOOL                        hasStarted;
  BOOL                        didShowUserAgreement;
  CGPoint                     startTouchPosition;
  NSUInteger                  startTouch;
  int                         currentSum;
  int                         curLevel;
  NSUInteger                  tapped;
  SummaryViewController       *summaryViewController;
  NSMutableString             *curInput;
  SystemSoundID               correctSound;
  SystemSoundID               wrongSound;
  SystemSoundID               backspaceSound;
}

@property (strong, nonatomic) IBOutlet UILabel *currentNumber;
@property (strong, nonatomic) IBOutlet UILabel *inputNumber;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UILabel *levelLabel;

- (IBAction)backButtonPressed:(id)sender;

- (void)setStartingLevel:(int)level;
- (void)setIsNatural:(BOOL)natural;
- (void)resetGameViewController;

@end

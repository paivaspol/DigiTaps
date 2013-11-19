//
//  SummaryViewController.h
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 2/3/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Logger.h"
#import "SVProgressHUD.h"
#import "GameEngine.h"

@protocol SummaryViewControllerProtocol <NSObject>

- (void)quitGame;
- (void)nextLevel;

@end

@interface SummaryViewController : UIViewController<UIAlertViewDelegate>
{
  @private
  BOOL shouldDisplayNextButton;
  GameEngine *gameEngine;
  Logger *logger;
  UIView *_currentView;
}
@property (strong, nonatomic) IBOutlet UIView *portraitView;
@property (strong, nonatomic) IBOutlet UIView *landscapeView;
@property (strong, nonatomic) id <SummaryViewControllerProtocol> delegate;
@property (strong, nonatomic) IBOutlet UILabel *landscapeNumbersCorrect;
@property (strong, nonatomic) IBOutlet UILabel *landscapeNumbersWrong;
@property (strong, nonatomic) IBOutlet UILabel *landscapePoint;
@property (strong, nonatomic) IBOutlet UILabel *landscapeAccuracy;
@property (strong, nonatomic) IBOutlet UILabel *portraitNumbersCorrect;
@property (strong, nonatomic) IBOutlet UILabel *portraitNumbersWrong;
@property (strong, nonatomic) IBOutlet UILabel *portraitPoint;
@property (strong, nonatomic) IBOutlet UILabel *portraitAccuracy;

- (void)setDisplayNextLevel:(BOOL)shouldDisplay;

@end

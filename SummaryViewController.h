//
//  SummaryViewController.h
//  TapInput
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
}

@property (strong, nonatomic) id <SummaryViewControllerProtocol> delegate;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *quitBut;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *nextBut;
@property (strong, nonatomic) IBOutlet UILabel *numbersCorrect;
@property (strong, nonatomic) IBOutlet UILabel *numbersWrong;
@property (strong, nonatomic) IBOutlet UIButton *postData;
@property (strong, nonatomic) IBOutlet UITextView *display;
@property (strong, nonatomic) IBOutlet UILabel *accuracy;

- (void)setDisplayNextLevel:(BOOL)shouldDisplay;

@end

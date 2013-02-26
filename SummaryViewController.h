//
//  SummaryViewController.h
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 2/3/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SummaryViewControllerProtocol <NSObject>

- (void)quitGame;
- (void)nextLevel;

@end

@interface SummaryViewController : UIViewController
{
  @private
  BOOL shouldDisplayNextButton;
}

@property (strong, nonatomic) id <SummaryViewControllerProtocol> delegate;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *quitBut;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *nextBut;
@property (strong, nonatomic) IBOutlet UILabel *numbersCorrect;
@property (strong, nonatomic) IBOutlet UILabel *numbersWrong;

- (IBAction)quitButton:(id)sender;
- (IBAction)nextLevelButton:(id)sender;

- (void)setDisplayNextLevel:(BOOL)shouldDisplay;

@end

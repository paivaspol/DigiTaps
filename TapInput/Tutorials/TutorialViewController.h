//
//  TutorialViewController.h
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 5/19/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialViewController : UIViewController
{
  UIView *_currentView;
}

@property (strong, nonatomic) IBOutlet UIView *portraitView;
@property (strong, nonatomic) IBOutlet UIView *landscapeView;
@property (strong, nonatomic) IBOutlet UIButton *overview;
@property (strong, nonatomic) IBOutlet UIButton *natural;
@property (strong, nonatomic) IBOutlet UIButton *lessNatural;

- (IBAction)handleButton:(id)sender;

@end

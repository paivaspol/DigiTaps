//
//  OverviewTutorialViewController
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 5/18/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OverviewPracticeViewController.h"

@interface OverviewTutorialViewController : UIViewController
{
  OverviewPracticeViewController *opvc;
  UIView *_currentView;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *portraitView;
@property (strong, nonatomic) IBOutlet UIView *landscape35InfoView;
@property (strong, nonatomic) IBOutlet UIView *landscape4InfoView;

@end

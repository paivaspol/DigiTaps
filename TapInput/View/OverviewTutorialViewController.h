//
//  TutorialViewController.h
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 5/18/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OverviewPracticeViewController.h"

@interface OverviewTutorialViewController : UIViewController
{
  OverviewPracticeViewController *opvc;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *infoView;

@end

//
//  NaturalTutorialViewController.h
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 5/19/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GestureDetectorManager.h"
#import "NaturalPracticeViewController.h"

@interface NaturalTutorialViewController : UIViewController
{
  NaturalPracticeViewController *npvc;
  UIView *_currentView;
}
@property (strong, nonatomic) IBOutlet UIView *landscape35InfoView;
@property (strong, nonatomic) IBOutlet UIView *landscape4InfoView;
@property (strong, nonatomic) IBOutlet UIView *portraitView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

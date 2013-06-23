//
//  LessNaturalTutorialViewController.h
//  TapInput
//
//  Created by Vaspol Ruamviboonsuk on 5/19/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LessNaturalPracticeViewController.h"

@interface LessNaturalTutorialViewController : UIViewController
{
  LessNaturalPracticeViewController *lnpvc;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *infoView;

@end

//
//  DemographicsViewController.h
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 3/24/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SVProgressHUD.h"

#import "GameInformationManager.h"

@protocol DemographicsViewControllerProtocol <NSObject>

// executed after done the userid has been returned.
- (void)registerCompletedWithUserId:(int)uid;

@end

@interface DemographicsViewController : UIViewController
{
}

@property (assign, nonatomic) id <DemographicsViewControllerProtocol> delegate;

@property (strong, nonatomic) IBOutlet UIView *demographicsView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)donePressed:(id)sender;

@end

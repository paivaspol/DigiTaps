//
//  UserAgreementViewController.h
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 1/24/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserAgreementViewControllerProtocol;

@interface UserAgreementViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIBarButtonItem *agreeButton;
@property (assign, nonatomic) id <UserAgreementViewControllerProtocol> delegate;

- (IBAction)agree:(id)sender;

@end

@protocol UserAgreementViewControllerProtocol <NSObject>

- (void)agreed;

@end

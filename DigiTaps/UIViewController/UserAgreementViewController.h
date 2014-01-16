//
//  UserAgreementViewController.h
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 1/24/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AgreementSectionDisplayViewController.h"

@protocol UserAgreementViewControllerProtocol;

@interface UserAgreementViewController : UITableViewController
{
  AgreementSectionDisplayViewController *agreementDisplay;
}

@property (assign, nonatomic) id <UserAgreementViewControllerProtocol> delegate;

@property (assign) BOOL showedModally;

@end

@protocol UserAgreementViewControllerProtocol <NSObject>

- (void)agreed;

@end

//
//  AgreementSectionDisplayViewController.h
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 1/8/14.
//  Copyright (c) 2014 MobileAccessibility. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum AgreementSection {
  kOverview = 0,
  kPurpose = 1,
  kBenefits = 2,
  kProcedures = 3,
  kRisks = 4,
  kOther = 5,
  kContact = 6
} AgreementSection;

@interface AgreementSectionDisplayViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *contentView;
@property (assign, nonatomic) AgreementSection agreementSection;

@end

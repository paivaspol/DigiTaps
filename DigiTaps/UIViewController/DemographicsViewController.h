//
//  DemographicsViewController.h
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 3/24/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SVProgressHUD.h"
#import "BSKeyboardControls.h"

#import "../GameModel/GameInformationManager.h"

@protocol DemographicsViewControllerProtocol <NSObject>

// executed after done the userid has been returned.
- (void)registerCompletedWithUserId:(int)uid;

@end

@interface DemographicsViewController : UITableViewController<BSKeyboardControlsDelegate, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate>
{
}

@property (assign, nonatomic) id <DemographicsViewControllerProtocol> delegate;

@property (retain, nonatomic) BSKeyboardControls *keyboardControls;

@property (strong, nonatomic) IBOutlet UITextField *ageField;
@property (strong, nonatomic) IBOutlet UITextField *genderField;
@property (strong, nonatomic) IBOutlet UITextField *possessionTimeField;
@property (strong, nonatomic) IBOutlet UITextField *identityField;
@property (strong, nonatomic) IBOutlet UITextField *useField;





@end

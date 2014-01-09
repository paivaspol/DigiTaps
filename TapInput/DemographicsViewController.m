//
//  DemographicsViewController.m
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 3/24/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "DemographicsViewController.h"

#define SYSTEM_VERSION_LESS_THAN(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

static NSString *kAgeField = @"age";
static NSString *kGenderField = @"gender";
static NSString *kPossessionTimeField = @"possession";
static NSString *kIdentityField = @"identity";
static NSString *kUsageField = @"usage";

@interface DemographicsViewController ()
{
  NSMutableDictionary *fieldValues;
}

@end

@implementation DemographicsViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
  }
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)setupViewController
{
  [self setTitle:@"Demographics"];
//  UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Register" style:UIBarButtonItemStyleDone target:self action:@selector(donePressed:)];
  //[self.navigationItem setRightBarButtonItem:doneButton];
  NSArray *fields = @[ self.ageField, self.genderField, self.possessionTimeField, self.identityField, self.useField ];
  
  for (int fieldIndex = 0; fieldIndex < 5; ++fieldIndex) {
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    [pickerView setDelegate:self];
    [pickerView setDataSource:self];
    [pickerView setTag: fieldIndex];
    UITextField *currentTextField = [fields objectAtIndex:fieldIndex];
    [currentTextField setInputView:pickerView];
  }
  
  fieldValues = [[NSMutableDictionary alloc] init];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // make sure that iOS7 display it properly :)
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }
  // Do any additional setup after loading the view from its nib.
  [self setupViewController];
  NSArray *fields = @[ self.ageField, self.genderField, self.possessionTimeField, self.identityField, self.useField ];
  self.keyboardControls = [[BSKeyboardControls alloc] initWithFields:fields];
  [self.keyboardControls setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.tableView reloadData];
  [self.navigationItem setHidesBackButton:YES];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)donePressed:(id)sender {
  if ([self.delegate respondsToSelector:@selector(registerCompletedWithUserId:)]) {
    // registers the player with the server
    GameInformationManager *gameInfoManager = [GameInformationManager getInstance];
    [SVProgressHUD showWithStatus:@"Registering..." maskType:SVProgressHUDMaskTypeClear];
    int playerId = [gameInfoManager registerPlayer:fieldValues];
    [SVProgressHUD dismiss];
    [self.delegate registerCompletedWithUserId:playerId];
  }
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == 10) {
    NSLog(@"got here!");
    if ([self.ageField.text isEqualToString:@""] || [self.genderField.text isEqualToString:@""] || [self.possessionTimeField.text isEqualToString:@""] || [self.identityField.text isEqualToString:@""] || [self.useField.text isEqualToString:@""]) {
      // The user did not compeletely fill out all the fields
      // Popup an alert and force the user to complete the form
      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Incomplete Form" message:@"Please fill up all the fields." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
      [alertView show];
    } else {
      [self donePressed:nil];
    }
  }
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -
#pragma mark Text Field Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  [self.keyboardControls setActiveField:textField];
  if ([textField.text isEqualToString:@""]) {
    UIPickerView *pickerView = (UIPickerView *) textField.inputView;
    [self pickerView:pickerView didSelectRow:0 inComponent:0];
  }
}

#pragma mark -
#pragma mark Text View Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
  [self.keyboardControls setActiveField:textView];
}

#pragma mark -
#pragma mark Keyboard Controls Delegate

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
  UIView *view;
  if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
    view = field.superview.superview;
  } else {
    view = field.superview.superview.superview;
  }
  [self.tableView scrollRectToVisible:view.frame animated:YES];
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
  [self.view endEditing:YES];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  switch (pickerView.tag) {
    case 0:
      // age
      return 7;
    case 1:
      // gender
      return 2;
    case 2:
      // length of possession
      return 5;
    case 3:
      // identify yourself
      return 3;
    case 4:
      // accessibility tool usage
      return 4;
    default:
      return 0;
  }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  switch (pickerView.tag) {
    case 0: {
      // age picker view
      switch (row) {
        case 0:
          return @"Under 18";
        case 1:
          return @"19 - 25";
        case 2:
          return @"26 - 32";
        case 3:
          return @"33 - 37";
        case 4:
          return @"38 - 45";
        case 5:
          return @"46 - 55";
        case 6:
          return @"Above 55";
        default:
          return @"";
      }
    }
    case 1: {
      // gender
      switch (row) {
        case 0:
          return @"Male";
        case 1:
          return @"Female";
        default:
          return @"";
      }
    }
    case 2: {
      // length of possession
      switch (row) {
        case 0:
          return @"Less than 3 months";
        case 1:
          return @"3 - 6 months";
        case 2:
          return @"6 - 9 months";
        case 3:
          return @"9 - 12 months";
        case 4:
          return @"Over a year";
        default:
          return @"";
      }
    }
    case 3: {
      // identify yourself
      switch (row) {
        case 0:
          return @"Sighted (neither blind nor low-vision)";
        case 1:
          return @"Blind";
        case 2:
          return @"Low-vision";
        default:
          return @"";
      }
    }
    case 4: {
      // accessibility tool usage
      switch (row) {
        case 0:
          return @"VoiceOver";
        case 1:
          return @"Zoom";
        case 2:
          return @"Both";
        case 3:
          return @"Neither";
      }
    }
    default:
      return @"";
  }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
  UITextField *currentTextField = (UITextField *) [self.keyboardControls activeField];
  [currentTextField setText:[self pickerView:pickerView titleForRow:row forComponent:component]];
  switch (pickerView.tag) {
    case 0:
      [fieldValues setObject:[NSNumber numberWithInt:row] forKey:kAgeField];
      break;
    case 1:
      [fieldValues setObject:[NSNumber numberWithInt:row] forKey:kGenderField];
      break;
    case 2:
      [fieldValues setObject:[NSNumber numberWithInt:row] forKey:kPossessionTimeField];
      break;
    case 3:
      [fieldValues setObject:[NSNumber numberWithInt:row] forKey:kIdentityField];
      break;
    case 4:
      [fieldValues setObject:[NSNumber numberWithInt:row] forKey:kUsageField];
      break;
    default:
      break;
  }
}

# pragma mark alert view
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  // do nothing force the user to only cancel
}

@end

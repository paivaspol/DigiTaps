//
//  DemographicsViewController.m
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 3/24/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "DemographicsViewController.h"

#define SYSTEM_VERSION_LESS_THAN(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface DemographicsViewController ()

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
  UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Register" style:UIBarButtonItemStyleDone target:self action:@selector(donePressed:)];
  [self.navigationItem setRightBarButtonItem:doneButton];
  
  UIPickerView *experiencePickerView = [[UIPickerView alloc] init];
  [experiencePickerView setDelegate:self];
  [experiencePickerView setDataSource:self];
  [experiencePickerView setTag: 0];
  [self.experienceField setInputView:experiencePickerView];
  
  UIPickerView *usagePickerView = [[UIPickerView alloc] init];
  [usagePickerView setDelegate:self];
  [usagePickerView setDataSource:self];
  [usagePickerView setTag:1];
  [self.useField setInputView:usagePickerView];
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
  NSArray *fields = @[ self.ageField, self.genderField, self.experienceField, self.useField ];
  self.keyboardControls = [[BSKeyboardControls alloc] initWithFields:fields];
  [self.keyboardControls setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
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
    NSMutableDictionary *dummy = [[NSMutableDictionary alloc] init];
    [dummy setValue:@"dummyValue" forKey:@"DummyKey"];
    int playerId = [gameInfoManager registerPlayer:dummy];
    [SVProgressHUD dismiss];
    [self.delegate registerCompletedWithUserId:playerId];
  }
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Text Field Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  [self.keyboardControls setActiveField:textField];
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
  if (pickerView.tag == 0) {
    // This is for accessibilityPickerView
    return 3;
  } else if (pickerView.tag == 1) {
    // This is for usagePickerView
    return 4;
  }
  return 0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  if (pickerView.tag == 0) {
    switch (row) {
      case 0:
        return @"0";
      case 1:
        return @"1";
      case 2:
        return @"2";
    }
  } else if (pickerView.tag == 1) {
    // This is for usagePickerView
    switch (row) {
      case 0:
        return @"VoiceOver";
      case 1:
        return @"Zoom";
      case 2:
        return @"Both";
      case 3:
        return @"None";
    }
  }
  return @"Hello";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
  UITextField *currentTextField = (UITextField *) [self.keyboardControls activeField];
  [currentTextField setText:[self pickerView:pickerView titleForRow:row forComponent:component]];
}

@end

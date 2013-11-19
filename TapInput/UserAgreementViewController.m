//
//  UserAgreementViewController.m
//  DigiTaps
//
//  Created by Vaspol Ruamviboonsuk on 1/24/13.
//  Copyright (c) 2013 MobileAccessibility. All rights reserved.
//

#import "UserAgreementViewController.h"

@interface UserAgreementViewController ()

@end

@implementation UserAgreementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    [self setTitle:@"User Agreement"];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Agree" style:UIBarButtonItemStyleDone target:self action:@selector(agree:)];
    [self.navigationItem setRightBarButtonItem:doneButton];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)agree:(id)sender {
  if ([self.delegate respondsToSelector:@selector(agreed)]) {
    [self.delegate agreed];
  }
}
@end

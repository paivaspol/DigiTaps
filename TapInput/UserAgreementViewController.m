//
//  UserAgreementViewController.m
//  TapInput
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

- (IBAction)agree:(id)sender {
  if ([self.delegate respondsToSelector:@selector(agreed)]) {
    NSLog(@"Agreed");
    [self.delegate agreed];
  }
  [self dismissViewControllerAnimated:YES completion:nil];
}
@end
